document.getElementById('calcular').addEventListener('click', function() {
    const modelo = document.getElementById('modelo').value.trim();
    const tipo_motor = document.getElementById('tipo_motor').value;
    const anio = parseInt(document.getElementById('anio').value);
    const velocidad = parseFloat(document.getElementById('velocidad').value);
    const peso = parseFloat(document.getElementById('peso').value);
    const terreno = document.getElementById('terreno').value;
    const distancia = parseFloat(document.getElementById('distancia').value);
    const viajes_mes = parseInt(document.getElementById('viajes_mes').value);

    const resultadoDiv = document.getElementById('resultado');

    if (modelo === '') {
        resultadoDiv.innerHTML = "<span class='error'>Debe ingresar un modelo de vehículo.</span>";
        return;
    }

    if (isNaN(anio) || anio < 1980 || anio > 2025) {
        resultadoDiv.innerHTML = "<span class='error'>Ingrese un año válido (1980–2025).</span>";
        return;
    }


    if (isNaN(velocidad) || velocidad < 30 || velocidad > 180) {
        resultadoDiv.innerHTML = "<span class='error'>La velocidad debe estar entre 30 y 180 km/h.</span>";
        return;
    }

    if (isNaN(peso) || peso < 900) {
        resultadoDiv.innerHTML = "<span class='error'>El peso debe ser al menos 900 kg.</span>";
        return;
    }

    if (isNaN(distancia) || distancia <= 0) {
        resultadoDiv.innerHTML = "<span class='error'>La distancia debe ser un número positivo.</span>";
        return;
    }

     if (isNaN(viajes_mes) || viajes_mes <= 0) {
        resultadoDiv.innerHTML = "<span class='error'>Ingrese un número válido de viajes.</span>";
        return;
    }

    const datos = {
        modelo: modelo,
        tipo_motor: tipo_motor,
         anio: anio,
        velocidad: velocidad,
        peso: peso,
        terreno: terreno,
        distancia: distancia,
        viajes_mes: viajes_mes
        
       
    };

    // Hacer la solicitud al servidor
    fetch(`${window.env.API_URL}/calcular`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(datos)
    })
    .then(response => response.json())
    .then(data => {
        let resultadoHTML = `<strong>Modelo:</strong> ${modelo}<br>`;
        resultadoHTML += `<strong>Tipo de motor:</strong> ${tipo_motor}<br>`;
        resultadoHTML += `<strong>Consumo estimado:</strong> ${data.consumo_estimado} litros/100 km<br>`;
        resultadoHTML += `<strong>Gasto estimado:</strong> ${data.gasto_estimado} COP<br>`;
        resultadoHTML += `<strong>Emisiones estimadas:</strong> ${data.emisiones_estimadas} kg CO₂<br>`;
        resultadoHTML += `<strong>Gasto mensual estimado:</strong> ${data.gasto_mensual_estimado} COP`;
        resultadoHTML += `<p class="info"> Este valor representa el gasto total aproximado en combustible durante el mes, basado en el número de viajes que realizaste y las condiciones del trayecto.</p>`;
        resultadoHTML += `<a href="grafica.html?velocidad=${velocidad}&consumo=${data.consumo_estimado}" target="_blank"><button style="margin-top: 15px;">Ver Gráfica</button></a>`;
        resultadoDiv.innerHTML = resultadoHTML;
    })
    .catch(error => {
        console.error('Error:', error);
        resultadoDiv.innerHTML = "<span class='error'>Error al obtener los resultados. Verifique la consola.</span>";
    });
});



