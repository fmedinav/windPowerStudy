% Inicializacion Se borran variables anteriores y se establecen los
% archivos y carpetas
clear all
clc
folder = 'C:\Vientos\04 Abril';
fileType = '*.xlsx';
folderMesNombre = fullfile(folder, fileType);
datosArchivosMes = dir(folderMesNombre);


%Se buscan datos en la carpeta declarada como folder
% Tienen que tener formato específico y estar completos se deben manipular
% antes de usar este metodo
for i=1: numel(datosArchivosMes); 
    datosMes{i}=xlsread(fullfile(folder, datosArchivosMes(i).name),'H3:H1442');
end
datosMensuales = cell2mat(datosMes);
%

%Por días
%Se calculan velocidad media y desviacion estandar para cada dia capturado 
%y se guardan en la matriz velocidadesMediasDiarias
%De tamaño de los días del mes (31 o menos) una media para cada dia
for i=1: size(datosMes,2);
    velocidadesMediasDiaria{i} = mean(datosMes{1,i});
    desviacionEstandarDiaria{i} = std(datosMes{1,i},0); %El segundo argumento es 0 para n-1 y 1 para N
end
%%%%%%%%

%Por mes 
%Se calcula media y desviacion estandar de todos los datos del mes 1440x30
%(o por el numero de días capturados)
%Para ellos hay que concatenar en una sola columna todos los datos del mes
%creando la matriz datosConcatenados
datosConcatenados = 0;
for i=1: size(datosMes,2);
    datosConcatenadosTemp = datosMes{1,i};
    datosConcatenados = [datosConcatenados; datosConcatenadosTemp];
end
velocidadMediaMensual= mean(datosConcatenados);
desviacionEstandarMensual = std(datosConcatenados);
%%%%%%%%%%%%


%Por horas
%Se calcula una media y desviación Estándar para una hora en específico
%incluyendo los datos de todos los dias del mes en esa hora en especifico
%arrojando como resultado la matriz de tamaño 24 velocidadMediaHora y
%desviacionEstandarHora
for k=1 : 24;
    datosConcatenadosHora = 0;
    datosHorasCell{k} = datosMensuales((1+60*k)-60:k*60,1:numel(datosArchivosMes));
    datosHorasMatTemp = cell2mat(datosHorasCell(1,k));
    
    for i=1: size(datosHorasMatTemp,2);
        datosConcatenadosHoraTemp = datosHorasMatTemp(:,i);
        datosConcatenadosHora = [datosConcatenadosHora; datosConcatenadosHoraTemp];
    end
    velocidadMediaHora(k)= mean(datosConcatenadosHora(2:end));          %Se corta el primer valor por la necesidad de inicializar datosConcatenadosHora
    desviacionEstandarHora (k) = std(datosConcatenadosHora(2:end));     %Y y al concatenarlos se agregaba el primer valor como un cero y arrojaba datos erroneos
    
end
%%%%%

%Constantes de cálculo de potencias
densidadDelAire = 1.225; %kg/m3
radioDeTurbina = .9; %m longitud del aspa del generador
areaDeCaptacion = pi*radioDeTurbina^2; %m2
coeficienteDePotencia = 16/27; %adimensional
%%%%

%Potencia disponible por dia (valor por valor)
potenciaDisponibleDiaria = (1/2)*densidadDelAire*areaDeCaptacion*datosMensuales.^3; % Pw = 1/2pAVw3  (W)
potenciaPromedioDisponibleDiaria = mean(potenciaDisponibleDiaria);                    %Pw = 1/2pAVw3  (W)
potenciaPromedioAprovechableDiaria = coeficienteDePotencia.*potenciaPromedioDisponibleDiaria; % Pt = 1/2pAVw3  (W)
densidadDePotenciaPromedioDiaria = potenciaPromedioDisponibleDiaria.*areaDeCaptacion;
potenciaDisponibleHora = (1/2)*densidadDelAire*areaDeCaptacion*velocidadMediaHora.^3;
%

% Creacion de datos para histograma
maxMes = max(datosConcatenados);
minMes = min(datosConcatenados);
numeroDeClases = 20;    %Se usan 20 clases
tamanoIntervalo = 1;    %Se selecciona arbitrariamente un tamaño de 1m/s
intervalos = [1:numeroDeClases];

%Conteo de frecuencia acumulada
for i=1: numeroDeClases
    frecuenciaAcumulada(i) = nnz(datosConcatenados(:)< tamanoIntervalo*i);
end

%Con la frecuencia acumulada se obtiene la frecuencia por intervalo con
%este for
for i=1: numeroDeClases
    if i==1
        frecuencia(i) = frecuenciaAcumulada(i);
    else
        frecuencia(i) = frecuenciaAcumulada(i)-frecuenciaAcumulada(i-1) ;
    end
  
end

%Se calculan frecuencias relativas y acumulada factor de forma y los datos
%necesarios para calcular distribucion de weibul con los datos capturados
frecuenciaRelativa = (1/length(datosConcatenados)).*frecuencia;
frecuenciaRelativaAcumulada = (1/length(datosConcatenados)).*frecuenciaAcumulada;
factorDeForma = (desviacionEstandarMensual/velocidadMediaMensual)^-1.086; % adimensional
factorDeEscala = velocidadMediaMensual/(gamma(1+1/factorDeForma));  % c = (m/s) Valor Cercano a la media
weibull = (factorDeForma/factorDeEscala)*((intervalos/factorDeEscala).^(factorDeForma-1)).*exp(-(intervalos/factorDeEscala).^factorDeForma);
weibullAcumulado = 1-exp(-(intervalos/factorDeEscala).^(factorDeForma)); 
%

%%%Weibull extrapolado a 50 y 100m
h = 10; %Altura de los datos tomados
h0 = 50; %Altura de los datos a extrapolar
h1 = 100; %Altura de los datos a extrapolar
beta = .12; %Beta seleccionada varía en función del terreno (ver página 352 centrales FV)
datosA50m = datosConcatenados*(h0/h)^beta;
datosA100m = datosConcatenados*(h1/h)^beta;
% Creacion de datos para histograma de datos extrapolados
maxMesA50m = max(datosA50m);
minMesA50m = min(datosA50m);

maxMesA100m = max(datosA100m);
minMesA100m = min(datosA100m);

%Conteo de frecuencia acumulada extrapolada
for i=1: numeroDeClases
    frecuenciaAcumuladaA50m(i) = nnz(datosA50m(:)< tamanoIntervalo*i);
    frecuenciaAcumuladaA100m(i) = nnz(datosA100m(:)< tamanoIntervalo*i);
end

%Con la frecuencia acumulada se obtiene la frecuencia por intervalo con
%este for para datos extrapolados a 50 y 100m
for i=1: numeroDeClases
    if i==1
        frecuenciaA50m(i) = frecuenciaAcumuladaA50m(i);
        frecuenciaA100m(i) = frecuenciaAcumuladaA100m(i);
    else
        frecuenciaA50m(i) = frecuenciaAcumuladaA50m(i)-frecuenciaAcumuladaA50m(i-1) ;
        frecuenciaA100m(i) = frecuenciaAcumuladaA100m(i)-frecuenciaAcumuladaA100m(i-1) ;
    end
  
end

%Se calculan frecuencias relativas y acumulada factor de forma y los datos
%necesarios para calcular distribucion de weibul con los datos extrapolados
%y se calculan velocidades promedio y desviaciones estandar necesarias para
%calcular weibull extrapolado a 50y 100m
velocidadPromedioMensualA50m = mean(datosA50m);
velocidadPromedioMensualA100m = mean(datosA100m);
desviacionEstandarMensualA50m = std(datosA50m);
desviacionEstandarMensualA100m = std(datosA100m);

frecuenciaRelativaA50m = (1/length(datosA50m)).*frecuenciaA50m;
frecuenciaRelativaA100m = (1/length(datosA100m)).*frecuenciaA100m;

frecuenciaRelativaAcumuladaA50m = (1/length(datosA50m)).*frecuenciaAcumuladaA50m;
frecuenciaRelativaAcumuladaA100m = (1/length(datosA100m)).*frecuenciaAcumuladaA100m;
factorDeFormaA50m = (desviacionEstandarMensualA50m/velocidadPromedioMensualA50m)^-1.086; % adimensional
factorDeFormaA100m = (desviacionEstandarMensualA100m/velocidadPromedioMensualA100m)^-1.086; % adimensional

factorDeEscalaA50m = velocidadPromedioMensualA50m/(gamma(1+1/factorDeFormaA50m));  % c = (m/s) Valor Cercano a la media
factorDeEscalaA100m = velocidadPromedioMensualA100m/(gamma(1+1/factorDeFormaA100m));  % c = (m/s) Valor Cercano a la media

weibullA50m = (factorDeFormaA50m/factorDeEscalaA50m)*((intervalos/factorDeEscalaA50m).^(factorDeFormaA50m-1)).*exp(-(intervalos/factorDeEscalaA50m).^factorDeFormaA50m);
weibullA100m = (factorDeFormaA100m/factorDeEscalaA100m)*((intervalos/factorDeEscalaA100m).^(factorDeFormaA100m-1)).*exp(-(intervalos/factorDeEscalaA100m).^factorDeFormaA100m);

weibullAcumuladoA50m = 1-exp(-(intervalos/factorDeEscalaA50m).^(factorDeFormaA50m)); 
weibullAcumuladoA100m = 1-exp(-(intervalos/factorDeEscalaA100m).^(factorDeFormaA100m)); 
%%%%%%


%%%% Se envian los datos necesarios a una hoja de excel
fileName = 'C:\Vientos\DatosAlan.xlsx';
%%%% con esta ruta
%Hoja 1
xlswrite(fileName, {'Datos Diarios'}, 1, 'A1');
xlswrite(fileName, {'Velocidades Medias Diarias'}, 1, 'A2');
xlswrite(fileName, {'Desviaciones Estándar Diarias'}, 1, 'B2');
xlswrite(fileName, transpose(velocidadesMediasDiaria), 1, 'A3');
xlswrite(fileName, transpose(desviacionEstandarDiaria), 1, 'B3');

%Hoja 2
xlswrite(fileName, {'Datos Mensuales'}, 2, 'A1');
xlswrite(fileName, {'Velocidad Media Mensual'}, 2, 'A2');
xlswrite(fileName, {'Desviación Estándar Mensual'}, 2, 'B2');
xlswrite(fileName, velocidadMediaMensual, 2, 'A3');
xlswrite(fileName, desviacionEstandarMensual, 2, 'B3');

%Hoja 3
xlswrite(fileName, {'Datos Por Hora'}, 3, 'A1');
xlswrite(fileName, {'Velocidad Media Por Hora'}, 3, 'A2');
xlswrite(fileName, {'Desviación Estándar Por Hora'}, 3, 'B2');
xlswrite(fileName, transpose(velocidadMediaHora), 3, 'A3');
xlswrite(fileName, transpose(desviacionEstandarHora), 3, 'B3');

%Hoja 4
xlswrite(fileName, {'Potencia Disponible Diaria'}, 4, 'A1');
xlswrite(fileName, transpose(potenciaPromedioDisponibleDiaria), 4, 'A2');
xlswrite(fileName, {'Potencia Aprovechable Diaria'}, 4, 'B1');
xlswrite(fileName, transpose(potenciaPromedioAprovechableDiaria), 4, 'B2');
xlswrite(fileName, {'Densidad de Potencia Disponible Diaria'}, 4, 'C1');
xlswrite(fileName, transpose(densidadDePotenciaPromedioDiaria), 4, 'C2');

%Hoja 5
xlswrite(fileName, {'Histograma'}, 5, 'A1');
xlswrite(fileName, {'Lectura mínima'}, 5, 'A2');
xlswrite(fileName, {'Lectura Máxima'}, 5, 'B2');
xlswrite(fileName, {'Tamaño del intervalo'}, 5, 'C2');
xlswrite(fileName, {'Intervalo'}, 5, 'A5');
xlswrite(fileName, {'Frecuencia'}, 5, 'B5');
xlswrite(fileName, {'Frecuencia acumulada'}, 5, 'C5');
xlswrite(fileName, {'Frecuencia Relativa'}, 5, 'D5');
xlswrite(fileName, {'Frecuencia Relativa Acumulada'}, 5, 'E5');
xlswrite(fileName, {'Weibull'}, 5, 'F5');
xlswrite(fileName, {'Weibull Acumulada'}, 5, 'G5');
xlswrite(fileName, {'Weibull a 50m'}, 5, 'H5');
xlswrite(fileName, {'Weibull Acumulada a 50'}, 5, 'I5');
xlswrite(fileName, {'Weibull a 100m'}, 5, 'J5');
xlswrite(fileName, {'Weibull Acumulada a 100m'}, 5, 'K5');
xlswrite(fileName, minMes, 5, 'A3');
xlswrite(fileName, maxMes, 5, 'B3');
xlswrite(fileName, tamanoIntervalo, 5, 'C3');
xlswrite(fileName, transpose(intervalos), 5, 'A6');
xlswrite(fileName, transpose(frecuencia), 5, 'B6');
xlswrite(fileName, transpose(frecuenciaAcumulada), 5, 'C6');
xlswrite(fileName, transpose(frecuenciaRelativa), 5, 'D6');
xlswrite(fileName, transpose(frecuenciaRelativaAcumulada), 5, 'E6');
xlswrite(fileName, transpose(weibull), 5, 'F6');
xlswrite(fileName, transpose(weibullAcumulado), 5, 'G6');
xlswrite(fileName, transpose(weibullA50m), 5, 'H6');
xlswrite(fileName, transpose(weibullAcumuladoA50m), 5, 'I6');
xlswrite(fileName, transpose(weibullA100m), 5, 'J6');
xlswrite(fileName, transpose(weibullAcumuladoA100m), 5, 'K6');

