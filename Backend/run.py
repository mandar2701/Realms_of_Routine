from flask import Flask, jsonify
from flask_cors import CORS
import google.generativeai as genai
import json

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})

genai.configure(api_key="AIzaSyBaCX12uX9RqsEiWQVZaItAVavWdub30rw")
model = genai.GenerativeModel('gemini-2.5-flash-lite')

@app.route('/generate-task')
def generate_task():
    try:
        prompt = (
            "You are a quest master for a fantasy RPG productivity app. "
            "Generate exactly 7 short RPG-style daily quests. Each quest must include:\n"
            "1. Task name: 2-5 words, must be the first thing on the line, no numbers, bullets, or preamble.\n"
            "2. Action in parentheses: short but meaningful instruction (e.g., 'drink 1 liter water', 'read 20 pages').\n"
            "3. Difficulty: Low, Medium, or High, **based on the actual effort or challenge of the task**. Do not default to Low.\n\n"
            "Return strictly valid JSON with keys 'tasks' and 'difficulties', each list containing exactly 7 items. "
            "The response must start directly with the first task name, without any extra text, numbering, or explanations.\n"
            "Example:\n"
            '{"tasks": ["Morning Pushups", "Read Book"], "difficulties": ["High", "Medium"]}'
        )

        response = model.generate_content(prompt)
        content = response.text.strip()

        # Parse AI response as JSON
        try:
            data = json.loads(content)
            if "tasks" not in data or "difficulties" not in data:
                raise ValueError("Missing keys in AI response")
            data["tasks"] = data["tasks"][:7]
            data["difficulties"] = data["difficulties"][:7]
        except (json.JSONDecodeError, ValueError):
            # Fallback: parse AI lines if not valid JSON
            tasks = []
            difficulties = []
            for line in content.split("\n"):
                line = line.strip("-• ").strip()
                if not line:
                    continue
                # Extract task name
                name = line.split("(")[0].strip() if "(" in line else line
                tasks.append(name)
                # Extract difficulty if present in line
                diff = None
                for d in ["Low", "Medium", "High"]:
                    if d.lower() in line.lower():
                        diff = d
                        break
                difficulties.append(diff if diff else "Medium")
            data = {"tasks": tasks[:7], "difficulties": difficulties[:7]}

        return jsonify(data)

    except Exception as e:
        print("Error:", e)
        return jsonify({
            "tasks": ["Sample Task 1", "Sample Task 2", "Sample Task 3", 
                      "Sample Task 4", "Sample Task 5", "Sample Task 6", "Sample Task 7"],
            "difficulties": ["Medium"]*7,
            "error": str(e)
        }), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
