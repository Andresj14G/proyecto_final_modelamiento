% calculo_consumo_y_gasto.m
% Función principal para calcular consumo y gasto estimado
function [consumo, gasto, emisiones, gasto_mensual] = calculo_consumo_y_gasto(velocidad, peso, terreno, distancia, tipo_motor, anio, viajes_mes)

  % Normalizar tipo_motor
  if iscell(tipo_motor), tipo_motor = tipo_motor{1}; end
  tipo_motor = lower(strtrim(char(tipo_motor)));
  tipo_motor = strrep(tipo_motor, 'á','a');
  tipo_motor = strrep(tipo_motor, 'é','e');
  tipo_motor = strrep(tipo_motor, 'í','i');
  tipo_motor = strrep(tipo_motor, 'ó','o');
  tipo_motor = strrep(tipo_motor, 'ú','u');

  disp(['Tipo de motor normalizado: ', tipo_motor]);

  velocidades   = [30 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180];
  consumos_base = [11.5 9.0 7.5 6.5 6.0 5.8 6.0 6.4 7.0 7.8 8.8 10.0 11.3 12.8 14.5 16.3];

  switch tipo_motor
    case 'gasolina', ajuste_motor = 1.0;
    case 'diesel',   ajuste_motor = 0.85;
    case 'hibrido',  ajuste_motor = 0.70;
    otherwise,       ajuste_motor = 1.0;
  end

  if anio >= 2020
    ajuste_anio = 1.0;
  elseif anio >= 2010
    ajuste_anio = 1.1;
  else
    ajuste_anio = 1.2;
  end

  ajuste_peso = peso / 1000;
  switch terreno
    case 1, ajuste_terreno = 1.0;
    case 2, ajuste_terreno = 1.2;
    case 3, ajuste_terreno = 0.9;
    otherwise, ajuste_terreno = 1.0;
  end

  consumos_final = consumos_base .* ajuste_motor .* ajuste_anio .* ajuste_peso .* ajuste_terreno;
  consumo = IntLineal(velocidad, velocidades, consumos_final);

  switch tipo_motor
    case 'gasolina', factor_emision = 2.31;
    case 'diesel',   factor_emision = 2.68;
    case 'hibrido',  factor_emision = 1.20;
    otherwise,       factor_emision = 2.31;
  end
  emisiones = (consumo/100) * distancia * factor_emision;

  gasto = calcular_gasto_con_regresion(consumo, distancia);
  gasto_mensual = gasto * viajes_mes;
end

function y = IntLineal(x, X, Y)
  if numel(X) ~= numel(Y), error('X e Y deben tener la misma longitud.'); end
  if isempty(X) || x <= X(1), y = Y(1); return;
  elseif x >= X(end), y = Y(end); return; end
  for i = 1:numel(X)-1
    if x >= X(i) && x <= X(i+1)
      y = (Y(i+1) - Y(i)) / (X(i+1) - X(i)) * (x - X(i)) + Y(i);
      return;
    end
  end
end

function [m, b] = mincuadlin(X, Y)
  n = numel(X);
  A = [sum(X.^2), sum(X); sum(X), n];
  B = [sum(X .* Y); sum(Y)];
  sol = A \ B;
  m = sol(1);
  b = sol(2);
end

function gasto_estimado = calcular_gasto_con_regresion(consumo, distancia)
  % Datos realistas generados por el modelo base
  consumos = [15.15, 10.94, 9.76, 10.77, 13.13, 16.83];
  gastos   = [42122.91, 30422.10, 27145.87, 29954.07, 36506.52, 46803.23];

  [m, b] = mincuadlin(consumos, gastos);
  gasto_estimado_100km = m * consumo + b;
  gasto_estimado = (gasto_estimado_100km / 100) * distancia;
end
