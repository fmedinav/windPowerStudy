function [ frecuencia ] = rayleigh( datos, numeroDeIntervalos, tamanoIntervalo  )
%WEIBULL Calcula distribución de rayleigh contiene resultados como
%frecuencias, etc, factor de escala = 2 y forma, desv. estandar mensual
%   Detailed explanation goes here

datosConcatenados = concatenarDatos(datos);
%Conteo de frecuencia acumulada
for i=1: numeroDeIntervalos
    frecuenciaAcumulada(i) = nnz(datosConcatenados(:)< tamanoIntervalo*i);
end

%Con la frecuencia acumulada se obtiene la frecuencia por intervalo con
%este for
for i=1: numeroDeIntervalos
    if i==1
        frecuencia(i) = frecuenciaAcumulada(i);
    else
        frecuencia(i) = frecuenciaAcumulada(i)-frecuenciaAcumulada(i-1) ;
    end
  
end

frecuencia = transpose(frecuencia);

%Se calculan frecuencias relativas y acumulada factor de forma y los datos
%necesarios para calcular distribucion de weibul con los datos capturados
desviacionEstandarMensual = std(datosConcatenados);
velocidadMediaMensual = mean(datosConcatenados);
intervalos = [0:.1:20];
frecuenciaRelativa = (1/length(datosConcatenados)).*frecuencia;
frecuenciaRelativaAcumulada = (1/length(datosConcatenados)).*frecuenciaAcumulada;
factorDeForma = 2;
%factorDeForma = (desviacionEstandarMensual/velocidadMediaMensual)^-1.086; % adimensional
factorDeEscala = velocidadMediaMensual/(gamma(1+1/factorDeForma));  % c = (m/s) Valor Cercano a la media
rayleigh = (factorDeForma/factorDeEscala)*((intervalos/factorDeEscala).^(factorDeForma-1)).*exp(-(intervalos/factorDeEscala).^factorDeForma);
rayleighAcumulado = 1-exp(-(intervalos/factorDeEscala).^(factorDeForma));
%

figure(1);
plot(rayleigh);
figure(2);
plot(frecuencia);
hold on;
bar(frecuencia);
hold on;
end

