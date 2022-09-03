function [ weibull ] = weibull( datos, numeroDeIntervalos, tamanoIntervalo  )
%WEIBULL Calcula distribución de Weibull contiene resultados como
%frecuencias, etc, factor de escala y forma, desv. estandar mensual
%   Recibe de parametros los datos, numero de intervalos y el tamaño de los
%   intervalos

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
desviacionEstandar = std(datosConcatenados);
velocidadMedia = mean(datosConcatenados);
intervalos = [0:.1:20];
frecuenciaRelativa = (100/length(datosConcatenados)).*frecuencia;
frecuenciaRelativaAcumulada = (100/length(datosConcatenados)).*frecuenciaAcumulada;
factorDeForma = (desviacionEstandar/velocidadMedia)^-1.086; % adimensional
factorDeEscala = velocidadMedia/(gamma(1+1/factorDeForma));  % c = (m/s) Valor Cercano a la media
weibull = ((factorDeForma/factorDeEscala)*((intervalos/factorDeEscala).^(factorDeForma-1)).*exp(-(intervalos/factorDeEscala).^factorDeForma))*100;
weibullAcumulado = 1-exp(-(intervalos/factorDeEscala).^(factorDeForma));
%

% figure(1);
% plot(weibull);
% hold on

% figure(2);
% plot(frecuencia);
% hold on;
% bar(frecuencia);
% 
% figure(3);
% bar(frecuenciaRelativa);
% 
% figure(4);
% bar(frecuenciaRelativaAcumulada);
% 


end

