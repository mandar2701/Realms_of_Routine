from flask import Flask, jsonify
from flask_cors import CORS
# Import the Google Generative AI library
import google.generativeai as genai
import os
import json


app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})


# Use an environment variable for the API key
# The genai.configure() function will automatically read from GEMINI_API_KEY
#genai.configure(api_key="AIzaSyBnavFsTqiGZvAPzbaINsiUk9ZysNyXfIg")

genai.configure(api_key="AIzaSyCLn0Cm0bPHY06W8vPpJwqTB4pXXs_GkTg")
# Initialize the Gemini model
# Note: You can choose a different Gemini model if needed
model = genai.GenerativeModel('gemini-2.5-flash-lite')
# Initialize Gemini model
@app.route('/generate-task')
def generate_task():
    try:
        prompt = (
            "You are a quest master for a fantasy RPG productivity app. "
            "Generate exactly 7 short RPG-style daily quests that help users improve real-life habits. "
            "Each quest must include a 2-5 word name, a short action in parentheses (like 'Do 10 pushups'), "
            "and a difficulty level (Low, Medium, High). "
            "Return strictly JSON with keys 'tasks' and 'difficulties', each a list of 7 items. "
            "Example output: "
            '{"tasks": ["Morning Pushups", "Read Book"], "difficulties": ["Medium", "Low"]}'
        )

        response = model.generate_content(prompt)
        content = response.text.strip()

        # Attempt to parse AI response as JSON
        try:
            data = json.loads(content)
            # Ensure both keys exist
            if "tasks" not in data or "difficulties" not in data:
                raise ValueError("Missing keys in AI response")
            # Limit to 7 tasks/difficulties
            data["tasks"] = data["tasks"][:7]
            data["difficulties"] = data["difficulties"][:7]

        except (json.JSONDecodeError, ValueError):
            # Fallback parsing if AI did not return proper JSON
            tasks = []
            difficulties = []
            for line in content.split("\n"):
                line = line.strip("-• ").strip()
                if not line:
                    continue
                # Extract difficulty if included
                diff = "Medium"
                if "Low" in line:
                    diff = "Low"
                elif "Medium" in line:
                    diff = "Medium"
                elif "High" in line:
                    diff = "High"
                # Extract task name before parentheses
                if "(" in line:
                    name = line.split("(")[0].strip()
                else:
                    name = line
                tasks.append(name)
                difficulties.append(diff)

            data = {
                "tasks": tasks[:7],
                "difficulties": difficulties[:7]
            }

        return jsonify(data)

    except Exception as e:
        print("Error:", e)
        # Always return valid JSON even on error
        return jsonify({
            "tasks": ["Sample Task 1", "Sample Task 2", "Sample Task 3", 
                      "Sample Task 4", "Sample Task 5", "Sample Task 6", "Sample Task 7"],
            "difficulties": ["Medium"]*7,
            "error": str(e)
        }), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
