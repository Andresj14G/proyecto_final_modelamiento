import os
from oct2py import Oct2Py
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app, origins="*")

# Inicializa Oct2Py
oc = Oct2Py()

# Ruta al script de Octave
oc.addpath(os.path.join(os.getcwd(), 'calculadora-consumo-combustible', 'backend'))


@app.route('/')
def index():
    return 'Bienvenido a la calculadora de consumo de combustible'

@app.route('/calcular', methods=['POST'])
def calcular():
    data = request.get_json(force=True)
    print("JSON recibido:", data)

    velocidad = data['velocidad']
    peso = data['peso']
    terreno = data['terreno']
    distancia = data['distancia']
    tipo_motor = str(data['tipo_motor'])
    anio = int(data['anio'])
    viajes_mes = int(data['viajes_mes'])
    modelo = str (data['modelo'])



    # Mapeo del tipo de terreno
    terreno_map = {'Plano': 1, 'Subida': 2, 'Bajada': 3}
    terreno_num = terreno_map.get(terreno, 1)

    # Llamada a Octave
    consumo_estimado, gasto_estimado, emisiones_estimadas, gasto_mensual_estimado = oc.calculo_consumo_y_gasto(
        velocidad, peso, terreno_num, distancia, tipo_motor, anio, viajes_mes, nout=4
    )

    return jsonify({
        'consumo_estimado': round(float(consumo_estimado), 2),
        'gasto_estimado': round(float(gasto_estimado), 2),
        'emisiones_estimadas': round(float(emisiones_estimadas), 2),
        'gasto_mensual_estimado': round(float(gasto_mensual_estimado), 2)
    })
if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=False)