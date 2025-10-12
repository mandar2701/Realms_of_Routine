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
        data = request.get_json() or {}
        duty = data.get('duty', 'Physical Well-being')
        focus = data.get('focus', 'Daily Habits')
        goal = data.get('goal', 'Achieve small victories')

        print(f"📥 Hero details - Duty: {duty}, Focus: {focus}, Goal: {goal}")

        personalization_details = (
            f"The user's Hero details are: "
            f"Duty: '{duty}', Focus: '{focus}', Goal: '{goal}'."
        )

        prompt = (
            "You are a quest master for a fantasy RPG productivity app. "
            f"{personalization_details} "
            "Generate a list of exactly 7 short, RPG-themed daily quests. "
            "Each quest must have a name and a difficulty. "
            "Return only a valid JSON object with two keys: 'tasks' and 'difficulties'."
        )

        response = model.generate_content(prompt)
        content = response.text.strip()

        json_match = re.search(r'\{.*\}', content, re.DOTALL)
        if not json_match:
            raise ValueError("No valid JSON object found in the AI response.")

        return jsonify(json.loads(json_match.group(0)))

    except Exception as e:
        print(f"❌ ERROR: {type(e).__name__}: {e}")
        return jsonify({"error": str(e)}), 500


if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
