function xp=mod4b_din2(t,x,flag,L)
%Modulo para resolver el sistema de ecuaciones del modelo
%dinamico del mecanismo de cuatro barras.
%3 de abril de 2013

%Parametros del material (aluminio) de las barras y del ancho de la misma.

rho=2700;  %[kg/m^3]
aa=0.01;    %[m]
bb=0.02;    %[m]

%Parametros de la ecuacion diferencial del mecanismo de cuatro barras
% L1=0.5593;
% L2=0.102;
% L3=0.610;
% L4=0.406;
% r2=0.051;
% r3=0.305;
% r4=0.203;
r2=L(2)/2;
r3=L(3)/2;
r4=L(4)/2;
m2=rho*aa*bb*L(2);
m3=rho*aa*bb*L(3);
m4=rho*aa*bb*L(4);
J2=(m2*(L(2)^2+bb^2))/12;
J3=(m3*(L(3)^2+bb^2))/12;
J4=(m4*(L(4)^2+bb^2))/12;
% m2=1.362;
% m3=1.362;
% m4=0.2041;
% J2=0.00071;
% J3=0.0173;
% J4=0.00509;
fhi2=0;
fhi3=0;
fhi4=0;
%teta1=0;
teta1=L(5);
%Constantes del resorte y amortiguador
C=0;
k=0;
teta40=0;
%Parametros de la ecuacion diferencial del motor de C.D.
R=1.4;        %0.4;
Lm=0.098;     %0.05;
Kf=0.0342;    %0.678;
Kb=0.0342;    %0.678;
J=3.0825E-07; %0.056;
TL=0;
B=0.226;
%Parametros de la caja de engranes del motor de C.D.
N1=1;
N2=1;
n=N2/N1;

%Ecuaciones del modelo cinematico del mecanismo de cuatro barras

AA=2*L(3)*(L(2)*cos(x(1))-L(1)*cos(teta1));
BB=2*L(3)*(L(2)*sin(x(1))-L(1)*sin(teta1));
CC=L(1)^2+L(2)^2+L(3)^2-L(4)^2-2*L(1)*L(2)*cos(teta1-x(1));
teta3=2*atan((-BB+(AA^2+BB^2-CC^2)^0.5)/(CC-AA));

DD=2*L(4)*(L(1)*cos(teta1)-L(2)*cos(x(1)));
EE=2*L(4)*(L(1)*sin(teta1)-L(2)*sin(x(1)));
FF=L(1)^2+L(2)^2+L(4)^2-L(3)^2-2*L(1)*L(2)*cos(teta1-x(1));
teta4=2*atan((-EE-(DD^2+EE^2-FF^2)^0.5)/(FF-DD));

gamma3=(L(2)*sin(teta4-x(1)))/(L(3)*sin(teta3-teta4));
gamma4=(L(2)*sin(teta3-x(1)))/(L(4)*sin(teta3-teta4));
alfa2=-r2*sin(x(1)-fhi2);
alfa3=-L(2)*sin(x(1))-r3*gamma3*sin(teta3-fhi3);
alfa4=-r4*gamma4*sin(teta4-fhi4);
beta2=r2*cos(x(1)+fhi2);
beta3=L(2)*cos(x(1))+r3*gamma3*cos(teta3+fhi3);
beta4=r4*gamma4*cos(teta4+fhi4);

%Ecuaciones auxiliares del modelo dinámico

C0=J2+m2*r2^2+m3*L(2)^2;
C1=J3+m3*r3^2;
C2=J4+m4*r4^2;
C3=2*m3*L(2)*r3;
Ax1=C0+C1*gamma3^2+C2*gamma4^2+C3*gamma3*cos(x(1)-teta3-fhi3);

D1=(gamma4-1)*sin(teta3-teta4)*cos(teta4-x(1));
D2=(gamma4-gamma3)*sin(teta4-x(1))*cos(teta3-teta4);
D3=(gamma3-1)*sin(teta3-teta4)*cos(teta3-x(1));
D4=(gamma4-gamma3)*sin(teta3-x(1))*cos(teta3-teta4);
dg3=(L(2)*(D1+D2))/(L(3)*(sin(teta3-teta4))^2);
dg4=(L(2)*(D3+D4))/(L(4)*(sin(teta3-teta4))^2);
dAx1=2*C1*gamma3*dg3+2*C2*gamma4*dg4+C3*(dg3*cos(x(1)-teta3-fhi3)-gamma3*(1-gamma3)*sin(x(1)-teta3-fhi3));


A0=1/(Ax1+n^2*J);
A1=-(1/2)*dAx1;

A2=-(C*gamma4^2+n^2*B);
A3=-(n*TL)-k*gamma4*(teta4-teta40);

%Ley de control PID

xref=30;
error=xref-x(2);
x2_p=A0*(A1*x(2)^2+A2*x(2)+n*Kf*x(3)+A3);
u=30;
%u=K(1)*error*x(5)+K(2)*x(4)+K(3)*(-x2_p);
x3_p=(1/Lm)*(u-n*Kb*x(2)-R*x(3));
x6_p=((1/n*Kf)*((1/2)*dAx1*x2_p^2+n^2*B*x2_p^2+n*TL))^2;

%Ecuaciones de estado
%Las primeras 3 son las ecuaciones de estado, la siguiente  1 es la
%integral del error,la siguiente 1 es la integral de la velocidad deseada,
%la siguiente 1 es la integral de la corriente funcion objetivo.
xp=[x(2);
    x2_p;
    x3_p;
    error;
    xref;
    x6_p];


