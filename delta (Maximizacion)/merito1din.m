function [fit,viorest,bandera]=merito1din(pn)
%Esta función evalua la funcion de mérito del recorrido del ángulo
%teta4, además evalua las restricciones del problema y avisa si el
%individuo es Grashof.
%La entrada de la función es el individuo a evaluar, donde el vector
%individuo tiene el siguiente orden: [r1,r2,r3,r4,teta1]
%%%%%%%%%%% ESTA FUNCION SE MAXIMIZA %%%%%%%%%%%%

%Esta es la tolerancia que se utiliza en la restriccion de igualdad
eps=0.01;

%Esta es la variable donde se almacenan la violaciones de las restricciones
contx=0;

%Bandera que establece si el individuo es Grashof, el valor de 0 es que
%cumple criterio de Grashof.   
bandera=1;

%tiempo de simulacion y paro del algoritmo.
t0=0;
tf=8*pi/30;
TSPAN=[t0 tf];

%Comienza el codigo de evaluación de restricciones de desigualdad estaticas
gx1=pn(2)+pn(3)-pn(1)-pn(4);
gx2=pn(1)-pn(3);
gx3=pn(4)-pn(3);

%Código para ver la penalización de las restricciones estáticas
if (gx1>0)
    contx=contx+abs(gx1);
end
if (gx2>0)
    contx=contx+abs(gx2);
end
if (gx3>0)
    contx=contx+abs(gx3);
end

%Termina codigo de evaluacion de restricciones de desigualdad estaticas

if (contx==0)
  bandera=0;   
  %condiciones iniciales de las variables de estado del sistema    
  x10=0; %teta2
  x20=0; %teta2_punto
  x30=0; %corriente del motor
  x40=0; %integral del error
  x50=0; %integral de la velocidad deseada
  x60=0; %integral de la corriente al cuadrado

  %condiciones iniciales de las variables de estado
  x0=[x10 x20 x30 x40 x50 x60];
    
  [t,x]=ode45('mod4b_din1',TSPAN,x0,[],pn);  %Solucion del sistema dinamico

  AA=2*pn(3)*(pn(2)*cos(x(:,1))-pn(1)*cos(pn(5)));
  BB=2*pn(3)*(pn(2)*sin(x(:,1))-pn(1)*sin(pn(5)));
  CC=pn(1)^2+pn(2)^2+pn(3)^2-pn(4)^2-2*pn(1)*pn(2).*cos(x(:,1)-pn(5));
  teta3=2*atan((-BB+(AA.^2+BB.^2-CC.^2).^0.5)./(CC-AA));

  DD=2*pn(4)*(pn(1)*cos(pn(5))-pn(2)*cos(x(:,1)));
  EE=2*pn(4)*(pn(1)*sin(pn(5))-pn(2)*sin(x(:,1)));
  FF=pn(1)^2+pn(2)^2+pn(4)^2-pn(3)^2-2*pn(1)*pn(2)*cos(x(:,1)-pn(5));
  teta4=2*atan((-EE-(DD.^2+EE.^2-FF.^2).^0.5)./(FF-DD));

 %Codigo para ver la penalización en la restricción dinámica.
  angtrans=abs(teta3-teta4);
  [M,N]=size(angtrans);
  for q=1:N
     if (angtrans(q)<(pi/4))
           contx=contx+((pi/4)-angtrans(q));
     end
  end

 %Código para evaluar la restricción de igualdad.
 %De acuerdo al valor de teta1 se evalua. 
  if (pn(5)<0)
     T4max=pi-abs(pn(5))-acos((pn(1)^2+pn(4)^2-(pn(3)-pn(2))^2)/(2*pn(1)*pn(4)));
     T4min=pi-abs(pn(5))-acos((pn(1)^2+pn(4)^2-(pn(3)+pn(2))^2)/(2*pn(1)*pn(4)));
  else
    if (pn(5)==0)
       T4max=pi-acos((pn(1)^2+pn(4)^2-(pn(3)-pn(2))^2)/(2*pn(1)*pn(4)));
       T4min=pi-acos((pn(1)^2+pn(4)^2-(pn(3)+pn(2))^2)/(2*pn(1)*pn(4)));
    else
       T4max=pi+abs(pn(5))-acos((pn(1)^2+pn(4)^2-(pn(3)-pn(2))^2)/(2*pn(1)*pn(4)));
       T4min=pi+abs(pn(5))-acos((pn(1)^2+pn(4)^2-(pn(3)+pn(2))^2)/(2*pn(1)*pn(4)));
    end
  end
  igx1=abs(pi-T4max-T4min);
  hx1=igx1-eps;
  if (hx1>0)
     contx=contx+abs(hx1);
  end
end

%Codigo para evaluar la función de mérito.
%Si es un individuo factible, evalua la función,
%Si no es factible le asigna el valor 0 como valor de merito

if (contx==0)
     delta=(T4max-T4min)^2;
     if nargout==1
         fit=delta;
     else
         fit=delta;
         viorest=contx;
     end
else
     if nargout==1
         fit=0;
     else
         fit=0;
         viorest=contx;
     end
end
%Eso es todo...



