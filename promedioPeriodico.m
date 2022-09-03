function [ promedioPeriodico ] = promedioPeriodico( datos, periodoEnMinutos )
%Divide los datos (de tamaño x habitual en 1440) en periodos 
%   Usar periodoEnMinutos un numero que divida x sin residuo

for j=1:size(datos,2)
    for i=1:size(datos,1)/periodoEnMinutos
        promedioPeriodico(i,j) = mean(datos((i*periodoEnMinutos-periodoEnMinutos+1): i*periodoEnMinutos));
    end
end

end

