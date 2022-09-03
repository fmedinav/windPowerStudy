function [ promedioPorHora ] = promedioHora( datos )
%PORHORAS Summary of this function goes here
%   Detailed explanation goes here

for i=1:24
    promedioPorHora(i,1)=mean(concatenarDatos(datos((i*60-60)+1:60*i,:)));
end
    
end

