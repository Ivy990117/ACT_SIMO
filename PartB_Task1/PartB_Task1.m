clear all;
clc;

Fc=2.4*10^9; %carrier frequency
Tcs=5*10^(-9); %symbol duration
N=4; %the number of Rx
noise_sigma2=5; %noise power/dB
c=3*10^(8); %propagation speed m/s
alpha=2; %path loss exponent
SNR=20; %dB
Ts=5*10^(-9); %sampling period /ns
r=[0 60 100 60; 0 -88 9 92; 0 0 0 0]; %locations of four receivers


%--------------------Time of arrival localisation--------------------------
%load time data
load('B_1_Rx1.mat');
load('B_1_Rx2.mat');
load('B_1_Rx3.mat');
load('B_1_Rx4.mat');
L=length(x1_Time); %the number of samples;

%transmission time instant
t0=20*Ts;

%association stage
for i=1:L
    x1_Time(i)=(norm(x1_Time(i)))^2;
    x2_Time(i)=(norm(x2_Time(i)))^2;
    x3_Time(i)=(norm(x3_Time(i)))^2;
    x4_Time(i)=(norm(x4_Time(i)))^2;
end

%find the receive time instant
for i=1:L
    if x1_Time(i)>20
        t1=i*Ts;
        break;
    end
end

for i=1:L
    if x2_Time(i)>20
        t2=i*Ts;
        break;
    end
end

for i=1:L
    if x3_Time(i)>20
        t3=i*Ts;
        break;
    end
end

for i=1:L
    if x4_Time(i)>20
        t4=i*Ts;
        break;
    end
end
        
d1=(t1-t0)*c;
d2=(t2-t0)*c;
d3=(t3-t0)*c;
d4=(t4-t0)*c;
d=[d2;d3;d4];

%metric fusion stage
b=zeros(N-1,1);
H=r(:,2:N)';
for i=1:N-1
    n(i)=(norm(H(i,:)))^2;
    b(i)=1/2*(n(i)-d(i)^2+d1^2);
end

rm=pinv(H)*b;

figure(1);

viscircles(r(1:2,1)',d1,'Color','b');
hold on;
viscircles(r(1:2,2)',d2,'Color','r');
hold on;
viscircles(r(1:2,3)',d3,'Color','g');
hold on;
viscircles(r(1:2,4)',d4,'Color','y');
hold on;
x=r(1,:);
y=r(2,:);
te={'Rx1','Rx2','Rx3','Rx4'};
plot(x,y,'ro');
text(x+3,y+3,te);
hold on;
xlabel('x');
ylabel('y');
title('TOA Localisation');

%--------------------------------------------------------------------------


%---------------Time difference of arrival localisation--------------------
%association stage
%mesure t1 t2 t3 t4 as above
t=[t1;t2;t3;t4];
D=zeros(N-1,1);
for i=1:N-1
    D(i)=abs((t(i+1)-t(1))*c);
end

%metric fusion stage

n=zeros(3,1);
D2=zeros(3,1);
H=H(:,1:2);
for i=1:N-1
    n(i)=(norm(H(i,:)))^2;  
    D2(i)=D(i)^2;
end

%estimate d1 firstly
HH=H*(inv(H'*H))^2*H';
syms d1
eqn=(transpose(1/2.*(n-D2-2.*d1.*D)))*HH*(1/2.*(n-D2-2.*d1.*D))==d1^2;
d=solve(eqn,d1);
d1=double(d(2));
%obtain the location of transmitter
b=1/2.*(n-D2-2.*d1.*D);
RM=pinv(H)*b;
for i=1:4
    D(i)=norm(RM-r(1:2,i));
end

figure(2);
h=fimplicit(@(x,y)hyperbola_fun(x,y,r(1:2,1),r(1:2,1+1),D(1)),[-200 200 -200 200]); 
set(h,'Color','r','LineWidth',2)
hold on;
h=fimplicit(@(x,y)hyperbola_fun(x,y,r(1:2,1),r(1:2,2+1),D(2)),[-200 200 -200 200]); 
set(h,'Color','y','LineWidth',2)
hold on;
h=fimplicit(@(x,y)hyperbola_fun(x,y,r(1:2,1),r(1:2,3+1),D(3)),[-200 200 -200 200]); 
set(h,'Color','g','LineWidth',2)
hold on;

x=r(1,:);
y=r(2,:);
te={'Rx1','Rx2','Rx3','Rx4'};
plot(x,y,'ro');
text(x+3,y+3,te);
hold on;
viscircles(r(1:2,1)',d1,'Color','b');
hold on;
xlabel('x');
ylabel('y');
title('TDOA Localisation');
%--------------------------------------------------------------------------




