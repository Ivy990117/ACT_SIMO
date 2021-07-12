clear all;
clc;
% RSS Localisation

Fc=2.4*10^9; %carrier frequency
Tcs=5*10^(-9); %symbol duration
N=4; %the number of Rx
noise_sigma2=5; %noise power/dB
c=3*10^(8); %propagation speed m/s
alpha=2; %path loss exponent
SNR=20; %dB
Ts=5*10^(-9); %sampling period /ns
r=[0 60 100 60; 0 -88 9 92; 0 0 0 0]; %locations of four receivers

P_Tx=150; %dBm
G_Rx=1; %dBi
G_Tx=1;
lamda=c/Fc;

%load data
load('B_2_Rx1.mat');
load('B_2_Rx2.mat');
load('B_2_Rx3.mat');
load('B_2_Rx4.mat');
L=length(x1_RSS); %the number of samples;

%calculate receive power
P_Rx=zeros(N,1);
P_Rx(1)=(norm(x1_RSS))^2/L;
P_Rx(2)=(norm(x2_RSS))^2/L;
P_Rx(3)=(norm(x3_RSS))^2/L;
P_Rx(4)=(norm(x4_RSS))^2/L;
P_Rx=P_Rx-10^(1/10*noise_sigma2);
P_Tx=10^(1/10*P_Tx-3);


%---------------------------Association stage------------------------------
d=zeros(N,1);
for i=1:N
    d(i)=sqrt((P_Tx/P_Rx(i))*G_Tx*G_Rx)*lamda/(4*pi);
    %d(i)=(sqrt((P_Tx/(P_Rx(i)-noise_sigma2))*G_Tx*G_Rx)*lamda)/(4*pi);
end
%--------------------------------------------------------------------------


%--------------------------Metric fusion stage----------------------------- 
b=zeros(N-1,1);
H=r(:,2:N)';
for i=1:N-1
    n(i)=(norm(H(i,:)))^2;
    b(i)=1/2*(n(i)-d(i+1)^2+d(1)^2);
end
rm=pinv(H)*b;
%--------------------------------------------------------------------------


%---------------------------Display the image------------------------------
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
viscircles(rm(1:2)',d(1),'Color','b');
hold on;
viscircles(rm(1:2)',d(2),'Color','r');
hold on;
viscircles(rm(1:2)',d(3),'Color','g');
hold on;
viscircles(rm(1:2)',d(4),'Color','y');
hold on;
xlabel('x');
ylabel('y');
title('RSSI Localisation');
%--------------------------------------------------------------------------



