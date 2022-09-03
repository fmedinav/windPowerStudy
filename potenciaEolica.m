function [ potenciaEolica ] = potenciaEolica( datos, coeficienteDePotencia, radioDeCaptacion)
%POTENCIAEOLICA Calcula la potencia de acuerdo al coeficiente dado y al
%radio de captacion dado en metros
%   Usar CP de 1 para potencia disponible y 16/27 para máxima. Usar otros
%   coeficientes dependiendo de la eficiencia de los aerogeneradores.

densidadDelAire = 1.225;
areaDeCaptacion = pi*radioDeCaptacion^2; %m2

potenciaEolica = (1/2)*densidadDelAire*coeficienteDePotencia*areaDeCaptacion*datos.^3;

end

