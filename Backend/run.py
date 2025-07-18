from flask import Flask, jsonify
from flask_cors import CORS
from groq import Groq
import os

app = Flask(__name__)
CORS(app)

# Set your actual API key here or load from env
client = Groq(api_key="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")

@app.route('/generate-task')
def generate_task():
    try:
        response = client.chat.completions.create(
            model="llama3-8b-8192",
            messages=[
                {
                    "role": "system",
                    "content": "You're a quest master in a gamified RPG-style productivity app. Generate 5 **very short** daily quests in fun, fantasy-themed language (max 7 words each), for fitness, learning, and habits. give in proper quatation without using 'asterisk' (*).Don't type like 'Here is your today's 5 task' or anything. Explain the task in 2-3 words"
                },
                {
                    "role": "user",
                    "content": "Give me today's 5 epic quests!"
                }
            ],
            temperature=0.7,
        )

        content = response.choices[0].message.content.strip()
        tasks = [task.strip("-•1234567890. ") for task in content.split("\n") if task.strip()]
        return jsonify(tasks)

    except Exception as e:
        print("Error:", e)
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
