function [ datosMayorA ] = datosMayorA( datos, umbral )
%MAYORA Summary of this function goes here
%   Detailed explanation goes here
mayorA = 0;
datosConcatenados = concatenarDatos(datos);
datosMayorA = 0;
for i=1 : length(datosConcatenados)
    if datosConcatenados(i)> umbral
        datosMayorA = [datosMayorA; datosConcatenados(i)];
        mayorA = mayorA + 1;
    end
end
datosMayorA(1) = [];
    

end

