import os
from flask import Flask, jsonify, request
from flask_cors import CORS
import google.generativeai as genai
import json
import re
import requests # Make sure to install this library: pip install requests

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})

# It's better practice to load the API key from environment variables
genai.configure(api_key=os.getenv("GEMINI_API_KEY"))
model = genai.GenerativeModel('gemini-pro')

# Define the base URL of your Node.js API
NODE_API_URL = "https://realms-of-routine-node-js.onrender.com" # Adjust if your backend runs on a different port

@app.route('/generate-task', methods=['GET'])
def generate_task():
    try:
        username = request.args.get('username')
        print(f"📥 Received request for username: {username}")
        if not username:
            raise ValueError("Username is required")

        response = requests.get(f"{NODE_API_URL}/api/hero/{username}")
        print(f"🌐 Fetched hero data status: {response.status_code}")
        response.raise_for_status()
        hero_data = response.json()
        print(f"🦸 Hero data: {hero_data}")

        hero_duty = hero_data.get('duty', 'Physical Well-being')
        hero_focus = hero_data.get('focus', 'Daily Habits')
        hero_goal = hero_data.get('goal', 'Achieve small victories')

        personalization_details = (
            f"The user's Hero details are: "
            f"Duty: '{hero_duty}', Focus: '{hero_focus}', Goal: '{hero_goal}'."
        )

        prompt = (
            "You are a quest master for a fantasy RPG productivity app. "
            f"{personalization_details} "
            "Generate a list of exactly 7 short, RPG-themed daily quests. "
            "Each quest must have a name and a difficulty. "
            "Return only a valid JSON object with two keys: 'tasks' and 'difficulties'."
        )

        print("🧠 Sending prompt to Gemini...")
        response = model.generate_content(prompt)
        content = response.text.strip()
        print(f"🤖 Gemini raw response: {content}")

        json_match = re.search(r'\{.*\}', content, re.DOTALL)
        if not json_match:
            raise ValueError("No valid JSON object found in the AI response.")

        data = json.loads(json_match.group(0))
        print(f"✅ Parsed JSON: {data}")

        return jsonify(data)

    except Exception as e:
        print(f"❌ ERROR in /generate-task: {type(e).__name__}: {e}")
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)