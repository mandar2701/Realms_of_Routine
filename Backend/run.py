import os
from flask import Flask, jsonify, request
from flask_cors import CORS
import google.generativeai as genai
import json
import re

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})

# Load Gemini API key from environment variable
genai.configure(api_key=os.getenv("GEMINI_API_KEY"))
model = genai.GenerativeModel('gemini-2.5-flash-lite')

import os
from flask import Flask, jsonify, request
from flask_cors import CORS
import google.generativeai as genai
import json
import re

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})

# Load Gemini API key from environment variable
genai.configure(api_key=os.getenv("GEMINI_API_KEY"))
model = genai.GenerativeModel('gemini-pro')

@app.route('/generate-task', methods=['POST'])
def generate_task():
    try:
        # --- 1. Read hero details from POST JSON ---
        data_in = request.get_json() or {}
        duty = data_in.get('duty', 'Physical Well-being')
        focus = data_in.get('focus', 'Daily Habits')
        goal = data_in.get('goal', 'Achieve small victories')

        print(f"📥 Received Hero details - Duty: {duty}, Focus: {focus}, Goal: {goal}")

        # --- 2. Build personalized prompt ---
        personalization_details = (
            f"The user's Hero details are: "
            f"Duty: '{duty}', Focus: '{focus}', Goal: '{goal}'."
        )

        prompt = (
            "You are a quest master for a fantasy RPG productivity app. "
            f"{personalization_details} "
            "Generate a list of exactly 7 short, RPG-themed daily quests. "
            "Each quest needs a name (2-4 words) along with a description in parentheses: short but meaningful instruction (e.g., 'drink 1 liter water', 'read 20 pages') and a difficulty (Low, Medium, or High). "
            "Return ONLY a single, raw, valid JSON object with two keys: 'tasks' (a list of 7 task name strings) and "
            "'difficulties' (a list of 7 difficulty strings). Do not include any markdown, explanations, or any text outside of the JSON object. "
            "Ensure the number of tasks matches the number of difficulties (exactly 7 each)."
            "\n\nExample response format:\n"
            '{"tasks": ["Dawn Patrol (Go for a morning walk)", "Alchemist\'s Brew (Make a cup of coffee)"], "difficulties": ["Low", "Medium","High"]}'
        )

    print("🧠 Sending prompt to Gemini...")
        response = model.generate_content(prompt)
        content = response.text.strip()
        print(f"🤖 Gemini raw response: {content}")

        # --- 3. Extract JSON from AI response ---
        json_match = re.search(r'\{.*\}', content, re.DOTALL)
        if not json_match:
            raise ValueError("No valid JSON object found in the AI response.")

        data_out = json.loads(json_match.group(0))
        print(f"✅ Parsed JSON: {data_out}")

        return jsonify(data_out)

    except Exception as e:
        print(f"❌ ERROR in /generate-task: {type(e).__name__}: {e}")
        # Minimal fallback
        fallback_data = {
            "tasks": [
                f"Minor Training (Stretch for 10 min, supporting Duty: {duty})",
                f"Focus Scroll (Read about Goal: {goal})",
                "Cleanse the Artifact (Tidy up workspace)",
                "Hydration Ritual (Drink water)",
                f"Review Strategy (Top steps for Focus: {focus})",
                "Seek Silence (Meditate 5 min)",
                "Evening Log (Plan next day)"
            ],
            "difficulties": ["Low", "Medium", "Low", "Low", "Medium", "Low", "High"]
        }
        return jsonify(fallback_data), 500

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
