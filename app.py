
from flask import Flask, request, jsonify
import pickle
import numpy as np
from flask_cors import CORS

app = Flask(__name__)
cors = CORS(app, resources={r"/predict": {"origins": "*"}})

# Load model saat aplikasi dimulai
with open('rf_pickle.pkl', 'rb') as r:
    model = pickle.load(r, encoding='latin1')


@app.route('/predict', methods=['POST'])
# @cross_origin()
def predict():
    if request.method == 'POST':
        try:
            data = request.json

            accelerations = float(data['accelerations'])
            movement = float(data['movement'])
            uterine = float(data['uterine'])
            light = float(data['light'])
            severe = float(data['severe'])
            prolongued = float(data['prolongued'])
            abnormal = float(data['abnormal'])
            percentage = float(data['percentage'])

            input_data = np.array(
                (accelerations, movement, uterine, light, severe, prolongued, abnormal, percentage))
            input_data = np.reshape(input_data, (1, -1))

            isJanin = model.predict(input_data)

            # Konversi hasil prediksi ke integer
            result = {'result': int(isJanin[0])}

            return jsonify(result), 200

        except Exception as e:
            return jsonify({'error': str(e)}), 500


if __name__ == '__main__':
    app.run()
