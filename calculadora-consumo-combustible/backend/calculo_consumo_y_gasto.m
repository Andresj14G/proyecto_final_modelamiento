% Función principal para calcular consumo y gasto estimado
function [consumo, gasto, emisiones, gasto_mensual] = calculo_consumo_y_gasto(velocidad, peso, terreno, distancia, tipo_motor, anio, viajes_mes)

  disp(['Tipo de motor recibido: ', tipo_motor]);
  
    % Datos de velocidad y consumo base
    velocidades = [30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180];
    consumos_base = [11.5, 9.0, 7.5, 6.5, 6.0, 5.8, 6.0, 6.4, 7.0, 7.8, 8.8, 10.0, 11.3, 12.8, 14.5, 16.3];

    % Ajuste por tipo de motor
tipo_motor = lower(strtrim(tipo_motor));
switch tipo_motor
    case 'gasolina'
        ajuste_motor = 1.0;
    case 'diesel'
        ajuste_motor = 0.85;
    case 'hibrido'
        ajuste_motor = 0.70;
    otherwise
        ajuste_motor = 1.0; % Por defecto gasolina
end

% Ajuste por año del vehículo
if anio >= 2020
    ajuste_anio = 1.0;
elseif anio >= 2010
    ajuste_anio = 1.1;
else
    ajuste_anio = 1.2;
end



    % Ajuste por peso y terreno
    ajuste_peso = peso / 1000;
    switch terreno
        case 1 % Plano
            ajuste_terreno = 1.0;
        case 2 % Subida
            ajuste_terreno = 1.2;
        case 3 % Bajada
            ajuste_terreno = 0.9;
        otherwise
            ajuste_terreno = 1.0;
    end

    % Consumos ajustados
    consumos_final = consumos_base .* ajuste_terreno .* ajuste_peso .* ajuste_motor .* ajuste_anio;
    % Interpolación para el consumo estimado
    consumo = IntLineal(velocidad, velocidades, consumos_final);

% Emisiones de CO₂
    switch tipo_motor
        case 'gasolina', factor_emision = 2.31;
        case 'diesel', factor_emision = 2.68;
        case 'hibrido', factor_emision = 1.20;
        otherwise, factor_emision = 2.31;
    end
    emisiones = (consumo / 100) * distancia * factor_emision;


    % Calcular el gasto estimado
   gasto = calcular_gasto_con_regresion(consumo, distancia);
   gasto_mensual = gasto * viajes_mes;
end
  

% Función de interpolación lineal
function y = IntLineal(x, X, Y)
    y = NaN;
    if numel(X) ~= numel(Y)
        error('Los vectores X e Y deben tener la misma longitud.');
    end
    if isempty(X) || x < X(1)
        y = Y(1);
        return;
    elseif x > X(end)
        y = Y(end);
        return;
    end
    for i = 1:numel(X)-1
        if x >= X(i) && x <= X(i+1)
            y = (Y(i+1) - Y(i)) / (X(i+1) - X(i)) * (x - X(i)) + Y(i);
            return;
        end
    end
end

% Regresión lineal por mínimos cuadrados
function [m, b] = mincuadlin(X, Y)
    n = numel(X);
    A = zeros(2, 2);
    A(2, 2) = n;
    B = zeros(2, 1);
    for i = 1:n
        A(1, 1) = A(1, 1) + X(i)^2;
        A(1, 2) = A(1, 2) + X(i);
        A(2, 1) = A(2, 1) + X(i);
        B(1, 1) = B(1, 1) + X(i) * Y(i);
        B(2, 1) = B(2, 1) + Y(i);
    end
    sol = A \ B;
    m = sol(1, 1);
    b = sol(2, 1);
end

% Cálculo del gasto estimado con regresión lineal
function gasto_estimado = calcular_gasto_con_regresion(consumo, distancia)
    % Precio de la gasolina en COP por galón
    precio_galon = 15831;
    precio_litro = precio_galon / 3.78541;

    % Calcular el gasto directamente
    gasto_estimado = (consumo / 100) * distancia * precio_litro;
end

