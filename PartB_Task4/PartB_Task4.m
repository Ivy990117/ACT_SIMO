clear all;
clc;
% Large Aperture Array Localisation

N=4; %the number of Rx
% noise_sigma2=5; %noise power/dB
alpha=2; %path loss exponent

r=[0 60 100 60; 0 -88 9 92; 0 0 0 0]; %locations of four receivers


%load data
load('B_Xmatrix_LAA.mat'); %reference point at [0,0,0]
L=length(x0_LAA);

x1_LAA=x0_LAA./(ones(4,1)*x0_LAA(1,:));
x2_LAA=x0_LAA./(ones(4,1)*x0_LAA(2,:));
x3_LAA=x0_LAA./(ones(4,1)*x0_LAA(3,:));
x4_LAA=x0_LAA./(ones(4,1)*x0_LAA(4,:));


%--------------------------Association stage-------------------------------
R1=(x1_LAA*x1_LAA')/L;
R2=(x2_LAA*x2_LAA')/L;
R3=(x3_LAA*x3_LAA')/L;
R4=(x4_LAA*x4_LAA')/L;

D1=eig(R1);
sigma1=sum(D1(1:N-1))/(N-1);

D2=eig(R2);
sigma2=sum(D2(1:N-1))/(N-1);

D3=eig(R3);
sigma3=sum(D3(1:N-1))/(N-1);

D4=eig(R4);
sigma4=sum(D4(1:N-1))/(N-1);


gamma1=max(D1);
gamma2=max(D2);
gamma3=max(D3);
gamma4=max(D4);

lamda1=gamma1-sigma1;
lamda2=gamma2-sigma2;
lamda3=gamma3-sigma3;
lamda4=gamma4-sigma4;


k1=sqrt(lamda2/lamda1);
k2=sqrt(lamda3/lamda1);
k3=sqrt(lamda4/lamda1);

K=[k1;k2;k3];

%--------------------------------------------------------------------------


%---------------------------Metric fusion stage----------------------------


H=[2*(ones(3,1)*r(:,1)'-r(:,2:4)'), ones(3,1)-K];
b=[-(r(1,2:4)').^2-(r(2,2:4)').^2-(r(3,2:4)').^2];
X=pinv(H)*b;
rm=X(1:3);
rho=zeros(4,1);
rho(1)=sqrt(X(4));
for i=2:4
    rho(i)=norm(r(:,i)-rm);
end
%--------------------------------------------------------------------------


figure(1);
x=r(1,:);
y=r(2,:);
te={'Rx1','Rx2','Rx3','Rx4'};
plot(x,y,'ko','LineWidth',2);
text(x+3,y+3,te);
hold on;
plot(rm(1),rm(2),'ko');
te1={'Tx'};
text(rm(1)+3,rm(2)+3,te1);
hold on;
viscircles(rm(1:2)',rho(1),'Color','b');
hold on;
viscircles(rm(1:2)',rho(2),'Color','r');
hold on;
viscircles(rm(1:2)',rho(3),'Color','g');
hold on;
viscircles(rm(1:2)',rho(4),'Color','y');
hold on;
xlabel('x');
ylabel('y');
title('LAA Localisation');


