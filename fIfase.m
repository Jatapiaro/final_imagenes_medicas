function [Ifase,Iamp]=fIfase(VRIEf,N);
%%function [Ifase,Iamp]=fIfase(VRIE);
%%CALCULA LA IMAGEN DE FASE Y DE AMPLITUD DE LA SECUENCIA DE IMAGENES DE
%%UNA VRIE filtrada CON UN UMBRAL DE 0.16 PARA LOS 15 PRIMEROS FRAMES
X=VRIEf;
N=N;
n=0:N-1;
W=exp(j*2*pi*n(:)/N);
[r,c,p]=size(X);
for a=1:r
    for b=1:c
        Y(a,b)=[(squeeze(X(a,b,1:N))'*W)];
    end;
end;

AY=abs(Y);
FY=angle(Y);
Iamp=AY;
Ifase=FY;
