function [ datosConcatenados ] = concatenarDatos( datosMes )
%CONCATENARDATOS Concatena diferentes filas en una sola columna
%Por ejemplo hace una matriz de 3x3 en una de 9x1 eliminando las columnas 1 y 2 

datosConcatenados = 0;
for i=1: size(datosMes,2);
    datosConcatenadosTemp = datosMes(:,i);
    datosConcatenados = [datosConcatenados; datosConcatenadosTemp];
end
datosConcatenados(1) = [];
end

