function [ datosExtrapolados ] = extrapolarDatos( datos, altura )
%EXTRAPOLARDATOS La funci�n calcula los datos de viento a la altura
%indicada el argumento de entrada

h0 = 10;        %Altura de los datos tomados
h1 = altura;    %Altura de los datos a extrapolar
beta = .12;     %Beta seleccionada var�a en funci�n del terreno (ver p�gina 352 centrales FV)

datosExtrapolados = datos*(h1/h0)^beta;


end

