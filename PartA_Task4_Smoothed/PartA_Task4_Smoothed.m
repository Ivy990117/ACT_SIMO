clear all;
clc;
%load data
load('jl1620.mat');
phi_mod=phi_mod * pi / 180;
n_paths=length(Beta_1);
%initialize coefficients of two m-sequences
coeffs1=[1;0;0;1;0;1];
coeffs2=[1;0;1;1;1;1];
%chip length
n_chip=2^(length(coeffs1)-1)-1;
%number of characters of the text
n_chars = 60;
%signal samples
receive_symbols=Xmatrix;
%the number of snapshots and receivers
[n_receivers,n_snapshots]=size(receive_symbols);
%initial phase of antenna positions
init_phase = 30 / 180 * pi;

%---------------------------generate gold-sequence-------------------------
%generate two m-sequences
MSeq1=fMSeqGen(coeffs1);
MSeq2=fMSeqGen(coeffs2);

%generate gold-sequence 
goldseq=fGoldSeq(MSeq1,MSeq2,phase_shift);
goldseq=1-2*goldseq;
G=length(goldseq);
%--------------------------------------------------------------------------


%--------------------------channel estimation------------------------------
%antenna array positions
array=zeros(n_receivers,3);
for i=1:n_receivers
    array(i,:)=[cos(init_phase+(i-1)*2*pi/5),sin(init_phase+(i-1)*2*pi/5),0];
end
symbol_matrix=fVect(receive_symbols,goldseq);
[delay_estimate, DOA_estimate]=fChannelEstimation4_smoothed(receive_symbols,goldseq,array,n_paths,symbol_matrix);
%--------------------------------------------------------------------------


%---------------------spatiotemporal rake beamformer-----------------------
J = [zeros(1, 2 * G); eye(2 * G - 1) zeros(2 * G - 1, 1)];
[w_star]=fStarRake(array, DOA_estimate, delay_estimate, goldseq, n_paths, Beta_1,J);
%--------------------------------------------------------------------------


%---------------------------DSQPSK Demodulate------------------------------
text_bits=fDSQPSKDemodulator4(symbol_matrix,w_star,phi_mod);
%--------------------------------------------------------------------------


%-----------------------------Display text---------------------------------
fDisplayText(text_bits,n_chars);
%--------------------------------------------------------------------------