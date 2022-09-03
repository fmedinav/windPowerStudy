% Funcion principal del programa de obtencion de datos por mes
% Funciones auxiliares 
% El modelo de aerogenerador AW 82/1500 tiene un radio de captación de 41m y
% una altura de 80m
% El modelo de aerogenerador AW 125/3000 tiene un radio de captación de
% 62.5m y una altura de 87.5 o 120 se elige la de 120 (ver especificaciones
% técnicas en las hojas de acciona Windpower

radioDeCaptacionAW1500 = 41;
radioDeCaptacionAW3000 = 62.5;

% Esta función se usa para leer datos de todos los archivos de excel de la
% carpeta mencionada y que cumplan con el formato de la estación
% meteorológica (que es un acomodo en una fila y columnas específicas del
% archivo de excel y que el día esté completo de lecturas). En caso de
% haber un día incompleto la simulación falla. Usarla cada que haya nuevos
% archivos de excel con datos nuevos. Cada archivo de excel corresponde a
% un día.
% datos = obtenerDatos('C:\Vientos\Global');    

% Se guardan para en caso de tener que volver a usarlos no haya que leerlos
% de los archivos de excel nuevamente, pues esto es muy tardado.
% save('datosGlobales.mat', 'datos');

% Carga los datos en el workspace 
load('datosGlobales.mat');

% extrapolarDatos(datos, altura)
% Usa la ley potencial o de escalamiento de velocidad
datosA80 = extrapolarDatos(datos, 80);
datosA120 = extrapolarDatos(datos, 120);

% Estadística descriptiva
mediasDiarias = mean(datos);
mediasDiarias = [mediasDiarias; mean(datosA80)];
mediasDiarias = [mediasDiarias; mean(datosA120)];
desviacionEstandarDiaria = std(datos);

% potenciaEolica(datos, coeficienteDePotencia, radioDeCaptacion)
% Esta función obtiene la potencia disponible con la ecuacion P = pAV^3Cp
potenciaDisponibleA80  = potenciaEolica(datosA80, 1, radioDeCaptacionAW1500);
potenciaDisponibleA120 = potenciaEolica(datosA120, 1, radioDeCaptacionAW3000);
densidadMediaDePotencia = potenciaDisponibleA80./(pi*radioDeCaptacionAW1500^2);

potenciasDisponiblesDiarias = mean(potenciaDisponibleA80);
potenciasDisponiblesDiarias = [potenciasDisponiblesDiarias; mean(potenciaDisponibleA120)];

potenciaMaxCapturableA80 = potenciaEolica(datosA80, 15/27, radioDeCaptacionAW1500);
potenciaMaxCapturableA120 = potenciaEolica(datosA120, 15/27, radioDeCaptacionAW3000);

% datosMayorA(datos, valorUmbral)
% Esta función cuenta en el grupo de datos cuántos son mayores al valor
% umbral dado.
datosMayorA4 = datosMayorA(datos,4);
datosA80MayorA4 = datosMayorA(datosA80, 3);
datosA120MayorA4 = datosMayorA(datosA120, 3);


potenciaDisponibleA80MayorA4  = potenciaEolica(datosA80MayorA4, 1, radioDeCaptacionAW1500);
potenciaDisponibleA120MayorA4 = potenciaEolica(datosA120MayorA4, 1, radioDeCaptacionAW3000);

datosDiezminutales = promedioPeriodico(datos,10);
datosDiezminutalesA80 = promedioPeriodico(datosA80,10);
datosDiezminutalesA120 = promedioPeriodico(datosA120,10);

% Figura 1 articulo ciermi
figure
a = histograma(datos, 10, 1);
a(end+1,1:10) = histograma(datosA80, 10, 1);
a(end+1,1:10) = histograma(datosA120, 10, 1);
a = a*100/(1440*134);
a=transpose(a);
bar3(a);
ylabel('Velocidad del viento (m/s)');
zlabel('Frecuencia relativa(%)');
legend('h=10m','h=80m', 'h=120m');
% saveas(gca, 'Histogramas de frecuencias 3d.png')

% Figura 2
figure
b = histograma(datos, 10, 1)*100/(1440*134);
bar(b)
xlabel('Velocidad del viento (m/s)');
ylabel('Frecuencia relativa (%)');
legend('h=10m' );
% saveas(gca, 'Histogramas de frecuencias h=10.png')

% Figura 3
figure
bar(histograma(datosDiezminutales, 10,1)*1000/(1440*134));
xlabel('Velocidad del viento (m/s)');
ylabel('Frecuencia relativa (%)');
legend('h=10m' );
% saveas(gca, 'Histogramas de frecuencias diezminutales h=10.png')

% Figura 4
figure
c= weibull(datos, 10, 1);
c(end+1, 1:201)= weibull(datosA80, 10, 1);
c(end+1, 1:201)= weibull(datosA120, 10, 1);
plot(0:0.05:10, c);
xlabel('Velocidad del viento (m/s)');
ylabel('Probabilidad (%)');
legend('h=10m','h=80m', 'h=120m' );
% saveas(gca, 'Distribucion de Weibull.png')

% Figura 5
figure
d = mean(potenciaDisponibleA80);
d(end+1, 1:134) = mean(potenciaDisponibleA120);
plot(transpose(d));
xlabel('Día de año');
ylabel('Potencia disponible promedio (W)');
legend('AW82/1500','AW125/3000' );
% saveas(gca, 'Potencia disponible promedio.png')

% Figura 6
figure
bar(promedioHora(datos));
xlabel('Hora del día');
ylabel('Velocidad del viento promedio (m/s)');
legend('h=10m');
% saveas(gca, 'Velocidad del viento promedio h=10.png')

% Figura 7
figure
bar(promedioHora(datosA80));
xlabel('Hora del día');
ylabel('Velocidad del viento promedio (m/s)');
legend('h=80m');
% saveas(gca, 'Velocidad del viento promedio h=80.png')

% Figura 8
figure
bar(promedioHora(datosA120));
xlabel('Hora del día');
ylabel('Velocidad del viento promedio (m/s)');
legend('h=120m');
% saveas(gca, 'Velocidad del viento promedio h=120.png')

% histograma(datos, 18, 1);
% figure
% histograma(datosDiezminutales, 20,1);


