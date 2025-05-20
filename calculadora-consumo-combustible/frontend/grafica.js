document.addEventListener('DOMContentLoaded', function() {
    if (!document.getElementById('grafica')) return;

    const params = new URLSearchParams(window.location.search);
    const velocidadUsuario = parseFloat(params.get('velocidad'));
    const consumoUsuario = parseFloat(params.get('consumo'));

    const datasetBase = {
      label: 'Consumo (L/100km)',
      type: 'line',
      data: [
        {x: 30, y: 11.5}, {x: 40, y: 9.0}, {x: 50, y: 7.5}, {x: 60, y: 6.5},
        {x: 70, y: 6.0}, {x: 80, y: 5.8}, {x: 90, y: 6.0}, {x: 100, y: 6.4},
        {x: 110, y: 7.0}, {x: 120, y: 7.8}, {x: 130, y: 8.8}, {x: 140, y: 10.0},
        {x: 150, y: 11.3}, {x: 160, y: 12.8}, {x: 170, y: 14.5}, {x: 180, y: 16.3}
      ],
      borderColor: 'rgb(75, 192, 192)',
      tension: 0.3,
      fill: false,
      pointRadius: 4,
      pointBackgroundColor: '#007BFF'
    };

    const datasets = [datasetBase];

    if (!isNaN(velocidadUsuario) && !isNaN(consumoUsuario)) {
      datasets.push({
        label: 'Tu Consumo Estimado',
        data: [{ x: velocidadUsuario, y: consumoUsuario }],
        backgroundColor: 'red',
        borderColor: 'red',
        pointRadius: 8,
        type: 'scatter'
      });
    }

    const ctx = document.getElementById('grafica').getContext('2d');
    new Chart(ctx, {
      type: 'scatter',
      data: { datasets: datasets },
      options: {
        responsive: true,
        plugins: {
          legend: { position: 'top' },
          title: {
            display: true,
            text: 'Relación entre Velocidad y Consumo de Combustible'
          },
          tooltip: {
            callbacks: {
              label: function(context) {
                if (context.dataset.label === "Tu Consumo Estimado") {
                  const x = context.raw.x;
                  const y = context.raw.y;
                  return `Tu Consumo Estimado: (${x}, ${y})`;
                }
                return context.dataset.label + ": " + context.formattedValue;
              }
            }
          }
        },
        scales: {
          x: {
            title: {
              display: true,
              text: 'Velocidad (km/h)'
            },
            type: 'linear',
            min: 20,
            max: 190
          },
          y: {
            title: {
              display: true,
              text: 'Consumo (L/100 km)'
            },
            min: 4,
            max: 18
          }
        }
      }
    });
});
