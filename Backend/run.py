from flask import Flask, jsonify
from flask_cors import CORS
# Import the Google Generative AI library
import google.generativeai as genai
import os

app = Flask(__name__)
CORS(app)

# Use an environment variable for the API key
# The genai.configure() function will automatically read from GEMINI_API_KEY
#genai.configure(api_key="AIzaSyBnavFsTqiGZvAPzbaINsiUk9ZysNyXfIg")

genai.configure(api_key="AIzaSyBnavFsTqiGZvAPzbaINsiUk9ZysNyXfIg")
# Initialize the Gemini model
# Note: You can choose a different Gemini model if needed
model = genai.GenerativeModel('gemini-2.5-flash-lite')

@app.route('/generate-task')
def generate_task():
    try:
        # Use the Gemini model to generate content
        response = model.generate_content(
            "You are a quest master for a fantasy RPG-style productivity app. "
            "Generate exactly 7 short RPG-style daily quests that help users improve their real-life habits. "
            "Each quest should be written in a fun, fantasy or gamified style, with a name that’s 2–5 words long. "
            "After the quest name, include a short (2-3 words) explanation in parentheses describing exactly what the user should do "
            "(e.g., 'Do 15 pushups' or 'Read 5 pages'). "
            "Return only 7 quests with no intro, no numbering, and no extra text — only the quests, as plain bullet points."
            "Remove the bullet points from the response."
        )

        # Get the text from the response object
        content = response.text.strip()

        # Extract each bullet point
        tasks = [
            line.strip("-• ").strip()
            for line in content.split("\n")
            if line.strip()
        ]

        return jsonify(tasks[:7])

    except Exception as e:
        print("Error:", e)
        return jsonify({"error": str(e)}), 500


if __name__ == '__main__':
    # Make sure to set your GEMINI_API_KEY environment variable before running
    # On Linux/macOS: export GEMINI_API_KEY="YOUR_API_KEY"
    # On Windows: set GEMINI_API_KEY="YOUR_API_KEY"
    app.run(host='0.0.0.0', port=5000)