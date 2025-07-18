# Flask entry point
# backend/app.py
from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # So Flutter can fetch

@app.route('/generate-task')
def generate_task():
    tasks = [
        "Read 10 pages of a book",
        "Do 15 pushups",
        "Clean your desk",
        "Review yesterday's work",
        "Plan your day"
    ]
    return jsonify(tasks)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)



    