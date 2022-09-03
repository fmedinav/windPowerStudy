function [ datosMensuales ] = obtenerDatos( rutaMes )
%GETDATA Summary of this function goes here
%   Detailed explanation goes here

fileType = '*.xlsx';
folderMesNombre = fullfile(rutaMes, fileType);
datosArchivosMes = dir(folderMesNombre);


%Se buscan datos en la carpeta declarada como folder
% Tienen que tener formato específico y estar completos se deben manipular
% antes de usar este metodo
for i=1: numel(datosArchivosMes); 
    datosMes{i}=xlsread(fullfile(rutaMes, datosArchivosMes(i).name),'H3:H1442');
end
datosMensuales = cell2mat(datosMes);

end

