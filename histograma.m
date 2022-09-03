function [ frecuencia ] = histograma( data, numeroDeIntervalos, tamanoDelIntervalo)
%HISTOGRAMA Hace un histograma con los datos recibidos con el numero de
%intervalos recibidos
%   Los datos deben venir sin concatenar

datos = concatenarDatos(data);
maxDatos = max(datos);
minDatos = min(datos);
intervalos = [1:numeroDeIntervalos];

%Conteo de frecuencia acumulada
for i=1: numeroDeIntervalos
    frecuenciaAcumulada(i) = nnz(datos(:)< tamanoDelIntervalo*i);
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
frecuenciaRelativa = (1/length(datos)).*frecuencia*100;
frecuenciaRelativaAcumulada = (1/length(datos)).*frecuenciaAcumulada*100;

% figure(1);
% bar(frecuencia);
% 
% figure(2);
% bar(frecuenciaRelativa);
% 
% figure(3);
% bar(frecuenciaRelativaAcumulada);


end

