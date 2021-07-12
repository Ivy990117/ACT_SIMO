clear all;
close all;
clc;
Fc=2.4*10^9; %carrier frequency
c=3*10^(8); %propagation speed m/s
lamda=c/Fc;
d=lamda/2;
r_UCA=[0.125,0.0625,-0.0625,-0.125,-0.0625,0.0625; 0,0.1083,0.1083,0,-0.1083,-0.1083;0,0,0,0,0,0];
r_UCA=r_UCA./d;
r=[0 60 100 60; 0 -88 9 92; 0 0 0 0]; %locations of four receivers
R_UCA=zeros(3,6,4);
for i=1:4
    temp=repmat(r(:,i),1,6);
    R_UCA(:,:,i)=temp+r_UCA;
end
  
r_UCA1=R_UCA(:,:,1)';
r_UCA2=R_UCA(:,:,2)';
r_UCA3=R_UCA(:,:,3)';
r_UCA4=R_UCA(:,:,4)';
%load data
load('B_Xmatrix_1_DFarray');
load('B_Xmatrix_2_DFarray');
load('B_Xmatrix_3_DFarray');
load('B_Xmatrix_4_DFarray');
[X,Y]=size(x1_DOA); %the number of samples;

%--------------------------Association stage-------------------------------
M=1;

Rxx1=x1_DOA*x1_DOA'/256;
Z1=fMusic(r_UCA1,Rxx1,M);
[~,index1]=max(Z1);
theta1=index1-1;

Rxx2=x2_DOA*x2_DOA'./256;
Z2=fMusic(r_UCA2,Rxx2,M);
[~,index2]=max(Z2);
theta2=index2-1;

Rxx3=x3_DOA*x3_DOA'./256;
Z3=fMusic(r_UCA3,Rxx3,M);
[~,index3]=sort(Z3,'descend');
theta3=index3(1)-1;

Rxx4=x4_DOA*x4_DOA'./256;
Z4=fMusic(r_UCA4,Rxx4,M);
[~,index4]=sort(Z4,'descend');
theta4=index4(1)-1;
 

theta=[theta1;theta2;theta3;theta4];
%--------------------------------------------------------------------------


%----------------------------Music spectrum--------------------------------
figure(1);
subplot(221);
plot2d3d(Z1,(0:360),0,'dB','MUSIC spectrum1');
subplot(222);
plot2d3d(Z2,(0:360),0,'dB','MUSIC spectrum2');
subplot(223);
plot2d3d(Z3,(0:360),0,'dB','MUSIC spectrum3');
subplot(224);
plot2d3d(Z4,(0:360),0,'dB','MUSIC spectrum4');
%--------------------------------------------------------------------------


%---------------------------Metric fusion stage----------------------------
I2=eye(2);
IN=ones(4,1);
H=kron(IN,I2);
%use three points to compute the location of transmitter
cos_theta=-cos(frad(theta));
sin_theta=-sin(frad(theta));
A=zeros(5,5);
B=[0,0,60,-88,100]';
A(:,1:2)=H(1:5,:);
A(1,3)=cos_theta(1);
A(3,4)=cos_theta(2);
A(5,5)=cos_theta(3);
A(2,3)=sin_theta(1);
A(4,4)=sin_theta(2);
A1=pinv(A);
X=A1*B;

rm=zeros(3,1);
rm(1:2)=X(1:2);

%the distance 
rho=zeros(4,1);
rho(1:3)=X(3:5);
%compute the distance between the transmitter and the 4th receiver
rho(4)=norm(rm-r(:,4));
%--------------------------------------------------------------------------


%---------------------------Display the image------------------------------
%compute the four slopes
k=tan(frad(theta));

figure(2);
%plot four receivers and the transmitter
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

%plot the four arrays
x_array1=r_UCA1(:,1);
y_array1=r_UCA1(:,2);
te={'array1'};
plot(x_array1,y_array1,'r*','LineWidth',2);
text(x(1)-6,y(1)-6,te);
hold on;

x_array2=r_UCA2(:,1);
y_array2=r_UCA2(:,2);
te={'array2'};
plot(x_array2,y_array2,'r*','LineWidth',2);
text(x(2)-6,y(2)-6,te);
hold on;

x_array3=r_UCA3(:,1);
y_array3=r_UCA3(:,2);
te={'array3'};
plot(x_array3,y_array3,'r*','LineWidth',2);
text(x(3)-6,y(3)-6,te);
hold on;

x_array4=r_UCA4(:,1);
y_array4=r_UCA4(:,2);
te={'array4'};
plot(x_array4,y_array4,'r*','LineWidth',2);
text(x(4)-6,y(4)-6,te);
hold on;

%through receiving points, draw lines according to the slopes
y1 = @(x) k(1)*(x-r(1,1))+r(2,1);
y2 = @(x) k(2)*(x-r(1,2))+r(2,2);
y3 = @(x) k(3)*(x-r(1,3))+r(2,3);
y4 = @(x) k(4)*(x-r(1,4))+r(2,4);
fplot(y1,[r(1,1),rm(1)],'b','Linewidth',2);
hold on;
fplot(y2,[rm(1),r(1,2)],'r','Linewidth',2);
hold on;
fplot(y3,[rm(1),r(1,3)],'g','Linewidth',2);
hold on;
fplot(y4,[rm(1),r(1,4)+20],'y','Linewidth',2);
hold on;

%plot the reference lines
x_ref1=r(1,1):r(1,1)+30;
y_ref1=r(2,1)*ones(31);
plot(x_ref1,y_ref1,'b--','Linewidth',1);
hold on;

x_ref2=r(1,2):r(1,2)+30;
y_ref2=r(2,2)*ones(31);
plot(x_ref2,y_ref2,'r--','Linewidth',1);
hold on;

x_ref3=r(1,3):r(1,3)+30;
y_ref3=r(2,3)*ones(31);
plot(x_ref3,y_ref3,'g--','Linewidth',1);
hold on;

x_ref4=r(1,4):r(1,4)+30;
y_ref4=r(2,4)*ones(31);
plot(x_ref4,y_ref4,'y--','Linewidth',1);
hold on;


xlabel('x');
ylabel('y');
title('DOA Localisation');





