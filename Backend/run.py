import os
from flask import Flask, jsonify, request
from flask_cors import CORS
import google.generativeai as genai
import json
import re
import requests

app = Flask(__name__)
# Allow CORS from all origins for all endpoints, which is appropriate for development/Render deployment
CORS(app, resources={r"/*": {"origins": "*"}})

# It's better practice to load the API key from environment variables
genai.configure(api_key=os.getenv("GEMINI_API_KEY"))
model = genai.GenerativeModel('gemini-2.5-flash-lite')

# Define the base URL of your Node.js API
NODE_API_URL = "https://realms-of-routine-node-js.onrender.com" # Adjust if your backend runs on a different port

# FIX: Change the route to match the client's request path (/generate_task - with underscore)
# FIX: Change methods to accept POST requests.
@app.route('/generate-task', methods=['POST'])
def generate_task():
    # Initialize variables for safe use in fallback block
    username = None
    hero_duty = 'Physical Well-being'
    hero_focus = 'Daily Habits'
    hero_goal = 'Achieve small victories'

    try:
        # FIX: For POST requests, read data from the JSON body
        data = request.get_json()
        if not data:
            raise ValueError("No JSON payload received.")

        # --- 1. Get username from the request body ---
        # Assuming the client is sending { "username": "..." }
        username = data.get('username')

        if not username:
            raise ValueError("Username is required in the request body")

        # --- 2. Fetch Hero data from your Node.js API ---
        # The Node.js route needs to exist: /api/hero/{username}
        response = requests.get(f"{NODE_API_URL}/api/hero/{username}")
        response.raise_for_status()  # This will raise an error for bad responses
        hero_data = response.json()

        hero_duty = hero_data.get('duty', hero_duty)
        hero_focus = hero_data.get('focus', hero_focus)
        hero_goal = hero_data.get('goal', hero_goal)

        # --- 3. Build the Personalised Prompt ---
        personalization_details = (
            f"The user's Hero details are: "
            f"Duty: '{hero_duty}', "
            f"Focus: '{hero_focus}', "
            f"Goal: '{hero_goal}'. "
            "The quests must be directly inspired by and relevant to these details."
        )


        # Original prompt preserved exactly as you provided
        prompt = (
            "You are a quest master for a fantasy RPG productivity app. "
            f"{personalization_details} "
            "Generate a list of exactly 7 short, RPG-themed daily quests. "
            "Each quest needs a name (2-4 words) along with a description in parentheses: short but meaningful instruction (e.g., 'drink 1 liter water', 'read 20 pages') and a difficulty (Low, Medium, or High). "
            "Return ONLY a single, raw, valid JSON object with two keys: 'tasks' (a list of 7 task name strings) and "
            "'difficulties' (a list of 7 difficulty strings). Do not include any markdown, explanations, or any text outside of the JSON object."
            "\n\nExample response format:\n"
            '{"tasks": ["Dawn Patrol (Go for a morning walk)", "Alchemist\'s Brew (Make a cup of coffee)"], "difficulties": ["High", "Medium", "Low"]}'
        )


        response = model.generate_content(prompt)
        content = response.text.strip()

        # --- 4. Robust JSON Parsing ---
        json_match = re.search(r'\{.*\}', content, re.DOTALL)

        if not json_match:
            raise ValueError("No valid JSON object found in the AI response.")

        json_string = json_match.group(0)
        data = json.loads(json_string)

        if ("tasks" not in data or "difficulties" not in data or
                not isinstance(data["tasks"], list) or not isinstance(data["difficulties"], list) or
                len(data["tasks"]) != 7 or len(data["difficulties"]) != 7):
            raise ValueError(f"JSON format error or lists do not contain exactly 7 items. Found {len(data.get('tasks', []))} tasks.")

        return jsonify(data)

    except requests.exceptions.RequestException as e:
        # Handle Node API errors (e.g., Hero data not found, 404/500 from Node)
        print(f"--- ERROR in /generate_task (Node API Request Failed): {e} ---")
        # Use fallback data with a custom message.
        fallback_data = {
            "tasks": [
                f"Minor Training (Stretch for 10 minutes, supporting Duty: {hero_duty})",
                f"Focus Scroll (Read a book related to Goal: {hero_goal})",
                "Cleanse the Artifact (Tidy up your desk)",
                "Hydration Ritual (Drink 3 glasses of water)",
                f"Review Strategy (Outline the top 3 steps for Focus: {hero_focus})",
                "Seek Silence (Meditate for 5 minutes)",
                "Evening Log (Review and plan next day's tasks)"
            ],
            "difficulties": ["Low", "Medium", "Low", "Low", "Medium", "Low", "High"],
            "warning": "Personalized quests could not be generated as Hero data fetch failed. Using generic quests."
        }
        return jsonify(fallback_data), 200 # Return 200/OK so app doesn't crash, but warn user.

    except Exception as e:
        # Handle all other errors (e.g., JSON parsing failure, missing username)
        print(f"--- ERROR in /generate_task: {e} ---")

        # Fallback tailored to the parameters if available, or generic if not.
        fallback_data = {
            "tasks": [
                f"Minor Training (Stretch for 10 minutes, supporting Duty: {hero_duty})",
                f"Focus Scroll (Read a book related to Goal: {hero_goal})",
                "Cleanse the Artifact (Tidy up your desk)",
                "Hydration Ritual (Drink 3 glasses of water)",
                f"Review Strategy (Outline the top 3 steps for Focus: {hero_focus})",
                "Seek Silence (Meditate for 5 minutes)",
                "Evening Log (Review and plan next day's tasks)"
            ],
            "difficulties": ["Low", "Medium", "Low", "Low", "Medium", "Low", "High"]
        }
        # Use a generic error message for other failures.
        return jsonify(fallback_data), 500

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)