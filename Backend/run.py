from flask import Flask, jsonify
from flask_cors import CORS
from groq import Groq
import os

app = Flask(__name__)
CORS(app)

# Use environment variable for security
client = Groq(api_key="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")
@app.route('/generate-task')
def generate_task():
    try:
        response = client.chat.completions.create(
            model="llama3-8b-8192",
            messages=[
                {
                    "role": "system",
                    "content": (
                        "You are a quest master for a fantasy RPG-style productivity app. "
                        "Generate exactly 7 short RPG-style daily quests that help users improve their real-life habits. "
                        "Each quest should be written in a fun, fantasy or gamified style, with a name that’s 2–5 words long. "
                        "After the quest name, include a short (2-3 words) explanation in parentheses describing exactly what the user should do "
                        "(e.g., 'Do 15 pushups' or 'Read 5 pages'). "
                        "Return only 7 quests with no intro, no numbering, and no extra text — only the quests, as plain bullet points."
                    )
                },
                {
                    "role": "user",
                    "content": "Give me today's 7 epic quests!"
                }
            ],
            temperature=0.7,
        )

        content = response.choices[0].message.content.strip()

        # Extract each bullet point (clean up if it includes "-", "•", or numbering)
        tasks = [
            line.strip("-•0123456789. ").strip()
            for line in content.split("\n")
            if line.strip()
        ]

        return jsonify(tasks[:7])  # Return only first 7 if extra

    except Exception as e:
        print("Error:", e)
        return jsonify({"error": str(e)}), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
