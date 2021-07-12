clear all;
clc;
close all;
%% Transmitter
%-----------------initialize three photos to binary streams----------------
x=160;
y=112;
Q=8;
P=x*y*3*Q;

[ori_signal1,x1,y1]=fImageSource('Photo1.jpg',P);
[ori_signal2,x2,y2]=fImageSource('Photo2.jpg',P);
[ori_signal3,x3,y3]=fImageSource('Photo3.jpg',P);
%--------------------------------------------------------------------------


%----------------------------Initialize Phi--------------------------------
X=12; %The first letter of my surname is L
Y=10; %The first letter of my formalname is J
Phi=X+2*Y;
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
%--------------------------------------------------------------------------

%% Channel
%----------------------------------channel---------------------------------
delay=[5;7;12];
beta=[0.4,0.7,0.2];
DOA=[30,0;90,0;150,0];
paths=[1;1;1];
trans_symbols=[trans_symbols1;trans_symbols2;trans_symbols3]; %3*6451200

%array
init_phase = 30 / 180 * pi;
array=zeros(5,3);
for i=1:5
    array(i,:)=[cos(init_phase+(i-1)*2*pi/5),sin(init_phase+(i-1)*2*pi/5),0];
end

SNR1=0;
SNR2=40;
receive_symbols1=fChannel3(paths,trans_symbols,delay,beta,DOA,SNR1,array); %1*6451215
receive_symbols2=fChannel3(paths,trans_symbols,delay,beta,DOA,SNR2,array);
%--------------------------------------------------------------------------

%% Receiver

%--------------------------channel estimation------------------------------
[delay_estimate1, DOA_estimate1, beta_estimate1]=fChannelEstimation3(receive_symbols1',GoldSeq1,array);
[delay_estimate2, DOA_estimate2, beta_estimate2]=fChannelEstimation3(receive_symbols2',GoldSeq1,array);
%--------------------------------------------------------------------------


%-----------------------Superresolution beamformer-------------------------
desired_dir1=DOA_estimate1(1,:);
jammal_dir1=DOA_estimate1(2:3,:);
w_sr1=supres(array,jammal_dir1,desired_dir1);
Z1=fPattern(array,w_sr1);
receive_symbols1=w_sr1'*receive_symbols1;


desired_dir2=DOA_estimate2(1,:);
jammal_dir2=DOA_estimate2(2:3,:);
w_sr2=supres(array,jammal_dir2,desired_dir2);
Z2=fPattern(array,w_sr2);
receive_symbols2=w_sr2'*receive_symbols2;


% figure(1);
% subplot(121);
% plot2d3d(Z1,(0:180),0,'gain in dB','Supres array pattern with SNR=0 dB');
% subplot(122);
% plot2d3d(Z2,(0:180),0,'gain in dB','Supres array pattern with SNR=40 dB');
%--------------------------------------------------------------------------


%---------------------------DSQPSK Demodulate------------------------------
received_image1=fDSQPSKDemodulator3(receive_symbols1',GoldSeq1,delay_estimate1,Phi);
received_image2=fDSQPSKDemodulator3(receive_symbols2',GoldSeq1,delay_estimate2,Phi);
%--------------------------------------------------------------------------


%------------------------------compute BER---------------------------------
BER1=ber(received_image1,ori_signal1); %SNR=0
BER2=ber(received_image2,ori_signal1); %SNR=40
%--------------------------------------------------------------------------


%----------------------------display image---------------------------------
figure(2);
subplot(131);
imshow('Photo1.jpg');
title('Original Image 1');
subplot(132);
imshow('Photo2.jpg');
title('Original Image 2');
subplot(133);
imshow('Photo3.jpg');
title('Original Image 3');

figure(3);
subplot(131);
imshow('Photo1.jpg');
title('Original Image 1');
%imshow('autumn.jpg');
subplot(132);
fImageSink(received_image1,Q,x,y);
title('SNR=0 dB, BER=0.0090');
subplot(133);
fImageSink(received_image2,Q,x,y);
title('SNR=40 dB, BER=0');
%--------------------------------------------------------------------------
