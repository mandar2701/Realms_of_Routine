from flask import Flask, jsonify
from flask_cors import CORS
import google.generativeai as genai
import json
import re # Import the regular expression module

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})

# It's better practice to load the API key from environment variables
# For now, your existing method is fine for development.
genai.configure(api_key="AIzaSyBaCX12uX9RqsEiWQVZaItAVavWdub30rw")
model = genai.GenerativeModel('gemini-2.5-flash-lite') # Use the latest flash model

@app.route('/generate-task')
def generate_task():
    try:
        # --- Simplified and more direct prompt ---
        prompt = (
            "You are a quest master for a fantasy RPG productivity app. "
            "Generate a list of exactly 7 short, RPG-themed daily quests. "
            "Each quest needs a name (2-4 words) along with a description in parentheses: short but meaningful instruction (e.g., 'drink 1 liter water', 'read 20 pages') and a difficulty (Low, Medium, or High). "
            "Return ONLY a single, raw, valid JSON object with two keys: 'tasks' (a list of 7 task name strings) and "
            "'difficulties' (a list of 7 difficulty strings). Do not include any markdown, explanations, or any text outside of the JSON object."
            "\n\nExample response format:\n"
            '{"tasks": ["Dawn Patrol (Go for a morning walk)", "Alchemist\'s Brew (Make a cup of coffee)"], "difficulties": ["High", "Medium", "Low"]}'
        )

        response = model.generate_content(prompt)
        content = response.text.strip()

        # ✅ --- ROBUST JSON PARSING LOGIC ---
        # Find the JSON block using regular expressions
        # This looks for the first '{' to the last '}'
        json_match = re.search(r'\{.*\}', content, re.DOTALL)

        if not json_match:
            raise ValueError("No valid JSON object found in the AI response.")

        # Extract the matched JSON string
        json_string = json_match.group(0)

        # Parse the extracted JSON string
        data = json.loads(json_string)

        if "tasks" not in data or "difficulties" not in data or not isinstance(data["tasks"], list) or not isinstance(data["difficulties"], list):
            raise ValueError("JSON is missing required keys or keys are not lists.")

        # Ensure the lists have content before sending
        if not data["tasks"] or not data["difficulties"]:
            raise ValueError("AI returned empty lists.")

        return jsonify(data)

    except Exception as e:
        print(f"--- ERROR in /generate-task: {e} ---")
        print(f"--- Raw AI Response was: ---\n{content}\n--------------------------")
        # Provide a reliable fallback response
        fallback_data = {
            "tasks": [
                "Morning Stretch", "Hydrate Thyself", "Read a Scroll", "Tidy Your Quarters",
                "Midday Walk", "Plan Tomorrow", "Evening Reflection"
            ],
            "difficulties": ["Low", "Low", "Medium", "Medium", "Low", "High", "Low"]
        }
        return jsonify(fallback_data), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)