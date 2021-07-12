clc;
clear all;

%% compute manifold vector from array
% in half-wavelength
% array=[-0.5 0 0; 0.5 0 0]; %in the form of [r1, r2, r3]'
% dir=[60,0];
% S=spv(array,dir);

% % in meters
% array=[-0.0938, -0.0313, 0.0313, 0.0938; 0 0 0 0; 0 0 0 0]';
% lamda=0.125;
% array=array/(lamda/2);
% dir=[30,0];
% S=spv(array,dir);
%% Compute array from manifold vector
% S=[-0.1125+0.9936i, 0.6661+0.7458i, 1, 0.6661-0.7458i, -0.1125-0.9936i];
% dir=frad([30,0]);
% f=2.4*10^9;
% lamda=3*(10^8)/f;
% KI=fki(dir(1),dir(2));
% 
% array1=log(S(1))/((-1i)*KI);
% array2=log(S(2))/((-1i)*KI);


%% Wiener-Hopf weight vector
% array=[-2 -1 0 1 2; 0 0 0 0 0; 0 0 0 0 0]';
% dir=[30, 0];
% S=spv(array,dir);
% Rxx=[7.8000 - 0.0000i, -0.7327 + 2.1623i, 5.5846 - 3.7594i, 2.9266 + 4.3835i, 1.3609 - 3.8965i;
% -0.7327 - 2.1623i, 7.8000 + 0.0000i, -0.7327 + 2.1623i, 5.5846 - 3.7594i, 2.9266 + 4.3835i;
% 5.5846 + 3.7594i, -0.7327 - 2.1623i, 7.8000 + 0.0000i, -0.7327 + 2.1623i, 5.5846 - 3.7594i;
% 2.9266 - 4.3835i, 5.5846 + 3.7594i, -0.7327 - 2.1623i, 7.8000 - 0.0000i, -0.7327 + 2.1623i;
% 1.3609 + 3.8965i, 2.9266 - 4.3835i, 5.5846 + 3.7594i, -0.7327 - 2.1623i, 7.8000 + 0.0000i;];
% Weight=inv(Rxx)*S/(norm(inv(Rxx)*S));

%% Supress co-channel interference
% array=[-2 -1 0 1 2; 0 0 0 0 0; 0 0 0 0 0]';
% desired_dir1=[30, 0];
% jammal_dir1=[50, 0; 120 0];
% w_sr1=supres(array,jammal_dir1,desired_dir1);
% w_sr1=w_sr1/norm(w_sr1);

%% original signal Rmm computation
% array=[-2 -1 0 1 2; 0 0 0 0 0; 0 0 0 0 0]';
% Rxx=[ 10.2040 - 0.0000i -0.5788 + 4.1396i 6.7444 - 4.5482i 4.5234+6.4366i 1.2585 - 4.0588i;
%  -0.5788 - 4.1396i 7.2210 + 0.0000i -1.7454 + 0.1726i 5.9678 - 4.3653i 1.4498 + 3.4004i;
%  6.7444 + 4.5482i -1.7454 - 0.1726i 8.0986 + 0.0000i -0.6623 + 4.4220i 4.8585 - 3.4939i;
%  4.5234 - 6.4366i 5.9678 + 4.3653i -0.6623 - 4.4220i 9.5774 + 0.0000i -1.5253 + 1.1245i;
%  1.2585 + 4.0588i 1.4498 - 3.4004i 4.8585 + 3.4939i -1.5253 - 1.1245i 6.5210 + 0.0000i];
% Rnn=diag([0.1, 0.1, 0.1, 0.1 0.1]);
% 
% dir=[30, 0; 35, 0; 90, 0];
% S=spv(array,dir);
% a=pinv(S);
% Rmm= pinv(S)*(Rxx-Rnn)*pinv(S).';

%% channel capacity
N=10;
N0=0.01;
Nj=0.01;
P=0.1;
C=1.44*N*(P/(N0+Nj));

%% beamwidth
% c=3*10^8;
% Fc=30*10^9;
% N=100;
% d=c/Fc/2;
% beamwidth=2*asin(c/(Fc*N*d))*180/pi;

%% m-sequence
% coeff=[1 1 1]';
% m_seq=fMSeqGen(coeff);

%% Pdout, Pn and SNR
% S=[-0.1125+0.9936i, 0.6661+0.7458i, 1, 0.6661-0.7458i, -0.1125-0.9936i];
% w=[-0.1125+0.9936i, 0.6661+0.7458i, 1, 0.6661-0.7458i, -0.1125-0.9936i];
% Ps=1;
% Pn=0.1;
% w=S;
% Pdout=Ps*(w'*w)^2;
% Pnout=Pn*(w'*w);
% SNR=Pdout/Pnout;



