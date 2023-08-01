from flask import Flask, request, jsonify
import pickle
import  numpy as np
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Mengizinkan permintaan dari domain yang berbeda (untuk komunikasi dengan Flutter)

@app.route('/', methods=['POST'])
def predict_janin():
    with open('rf_pickle.pkl', 'rb') as r:
        model = pickle.load(r)

    data = request.get_json()
    accelerations = float(data['accelerations'])
    movement = float(data['movement'])
    uterine = float(data['uterine'])
    light = float(data['light'])
    severe = float(data['severe'])
    prolongued = float(data['prolongued'])
    abnormal = float(data['abnormal'])
    percentage = float(data['percentage'])

    datas = np.array((accelerations, movement, uterine, light, severe, prolongued, abnormal, percentage))
    datas = np.reshape(datas, (1, -1))

    isJanin = model.predict(datas)

    # Mengembalikan hasil prediksi dalam bentuk JSON
    return jsonify({'isJanin': int(isJanin[0])})

if __name__ == "__main__":
    app.run(debug=True)