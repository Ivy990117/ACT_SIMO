clear all;
clc;

%-----------------initialize three photos to binary streams----------------
P=160*112*3*8;
[ori_signal1,x1,y1]=fImageSource('Photo1.jpg',P);
[ori_signal2,x2,y2]=fImageSource('Photo2.jpg',P);
[ori_signal3,x3,y3]=fImageSource('Photo3.jpg',P);
%--------------------------------------------------------------------------


%-------------------------Initialize Parameters----------------------------
X=12; %The first letter of my surname is L
Y=10; %The first letter of my formalname is J
Phi=X+2*Y; %Phi

delay11=mod(X+Y,4);
delay12=mod(X+Y,5)+4;
delay13=mod(X+Y,6)+9;
delay=[delay11,delay12,delay13,8,13]; %relative delay

beta=[0.8,0.4*exp(-1j*frad(-40)),0.8*exp(1j*frad(80)),0.5,0.2]; %fading coefficient
%beta=[0.8,0.4,0.8,0.5,0.2]; %fading coefficient
DOA=[30,0;45,0;20,0;80,0;150,0]; %dierctions of received signals
paths=[3,1,1];
array=[0,0,0]; %the location of receiver

Q=8;
x=160;
y=112;
%--------------------------------------------------------------------------


%---------------------------generate gold-sequence-------------------------
%initialize coefficients of two m-sequences
coeffs1=[1;0;0;1;1];
coeffs2=[1;1;0;0;1];
n_gold=3;

Gold=gold(coeffs1,coeffs2,n_gold); 
GoldSeq1=Gold(:,1);
GoldSeq2=Gold(:,2);
GoldSeq3=Gold(:,3);
%--------------------------------------------------------------------------


%---------------------------------DS-QPSK----------------------------------
trans_symbols1=fDSQPSKModulator(ori_signal1,GoldSeq1,Phi);
trans_symbols2=fDSQPSKModulator(ori_signal2,GoldSeq2,Phi);
trans_symbols3=fDSQPSKModulator(ori_signal3,GoldSeq3,Phi);
trans_symbols=[trans_symbols1;trans_symbols2;trans_symbols3]; %3*6451200
%--------------------------------------------------------------------------


%----------------------------------channel---------------------------------
SNR1=0;
SNR2=40;
receive_symbols1=fChannel2(paths,trans_symbols,delay,beta,DOA,SNR1,array); %1*3225600
receive_symbols2=fChannel2(paths,trans_symbols,delay,beta,DOA,SNR2,array);
%--------------------------------------------------------------------------


%--------------------------channel estimation------------------------------
[delay_estimate1, DOA_estimate1, beta_estimate1]=fChannelEstimation2(receive_symbols1',GoldSeq1,paths);
[delay_estimate2, DOA_estimate2, beta_estimate2]=fChannelEstimation2(receive_symbols2',GoldSeq1,paths);
%--------------------------------------------------------------------------


%---------------------------DSQPSK Demodulate------------------------------
received_image1=fDSQPSKDemodulator2(receive_symbols1',GoldSeq1,delay_estimate1,Phi,beta(1:3));
received_image2=fDSQPSKDemodulator2(receive_symbols2',GoldSeq1,delay_estimate2,Phi,beta(1:3));
%--------------------------------------------------------------------------


%------------------------------compute BER---------------------------------
BER1=ber(received_image1,ori_signal1); %SNR=0
BER2=ber(received_image2,ori_signal1); %SNR=40
%--------------------------------------------------------------------------


%----------------------------display image---------------------------------
figure(1);
subplot(131);
imshow('Photo1.jpg');
title('Original Image 1');
%imshow('autumn.jpg');
subplot(132);
fImageSink(received_image1,Q,x,y);
title('SNR=0 dB, BER=0.0018');
subplot(133);
fImageSink(received_image2,Q,x,y);
title('SNR=40 dB, BER=0');
%--------------------------------------------------------------------------


