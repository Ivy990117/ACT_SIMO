clear all;
close all;
clc;

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
[receive_symbols1,noise_power1]=fChannel3(paths,trans_symbols,delay,beta,DOA,SNR1,array); %1*6451215
[receive_symbols2,noise_power2]=fChannel3(paths,trans_symbols,delay,beta,DOA,SNR2,array);
%--------------------------------------------------------------------------


%--------------------------channel estimation------------------------------
[delay_estimate1, DOA_estimate1, beta_estimate1,symbol_matrix1,J1]=fChannelEstimation3_STAR(receive_symbols1,GoldSeq1,array,noise_power1);
[delay_estimate2, DOA_estimate2, beta_estimate2,symbol_matrix2,J2]=fChannelEstimation3_STAR(receive_symbols2,GoldSeq1,array,noise_power2);
%--------------------------------------------------------------------------


%---------------------spatiotemporal rake beamformer-----------------------
[w_star1]=fStarRake(array, DOA_estimate1, delay_estimate1, GoldSeq1, paths(1), beta_estimate1,J1);
[w_star2]=fStarRake(array, DOA_estimate2, delay_estimate2, GoldSeq1, paths(1), beta_estimate2,J2);
%--------------------------------------------------------------------------


%---------------------------DSQPSK Demodulate------------------------------
[received_image1]=fDSQPSKDemodulator3_STAR(symbol_matrix1,w_star1,frad(Phi));
[received_image2]=fDSQPSKDemodulator3_STAR(symbol_matrix2,w_star2,frad(Phi));
%--------------------------------------------------------------------------


%------------------------------compute BER---------------------------------
BER1=ber(received_image1,ori_signal1); %SNR=0
BER2=ber(received_image2,ori_signal1); %SNR=40
%--------------------------------------------------------------------------

%----------------------------display image---------------------------------
figure(4);
subplot(131);
imshow('Photo1.jpg');
title('Original Image 1');
%imshow('autumn.jpg');
subplot(132);
fImageSink(received_image1,Q,x,y);
title('SNR=0 dB, BER=0');
subplot(133);
fImageSink(received_image2,Q,x,y);
title('SNR=40 dB, BER=0');
%--------------------------------------------------------------------------
