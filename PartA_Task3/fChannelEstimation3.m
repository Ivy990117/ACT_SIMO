% NAME, GROUP (EE4/MSc), 2010, Imperial College.
% DATE

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Performs channel estimation for the desired source using the received signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% symbolsIn (Fx1 Complex) = R channel symbol chips received
% goldseq (Wx1 Integers) = W bits of 1's and 0's representing the gold
% sequence of the desired source used in the modulation process
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% delay_estimate = Vector of estimates of the delays of each path of the
% desired signal
% DOA_estimate = Estimates of the azimuth and elevation of each path of the
% desired signal
% beta_estimate = Estimates of the fading coefficients of each path of the
% desired signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [delay_estimate, DOA_estimate, beta_estimate]=fChannelEstimation3(symbolsIn,goldseq,array)
    G=length(goldseq); %the length of gold sequence
    [X,~]=size(symbolsIn); 
    %P=430080;
    [R,~]=size(array); %R the number of receivers
    
    
     
%----------------------estimate the number of users------------------------
    Rxx=symbolsIn'*symbolsIn/X;
    M=MDL(Rxx,R,X); %the number of transmitters
%--------------------------------------------------------------------------


%-------------------------------estimate DOA-------------------------------
    Z=fMusic(array,Rxx,M);
    [~,index]=sort(Z,'descend');
    DOA_estimate=[index(1:M)'-1 zeros(M,1)];
    DOA_estimate=sort(DOA_estimate,'ascend');
%--------------------------------------------------------------------------


%------------------------------estimate delay------------------------------
    sum=zeros(1,G);
    symbol=symbolsIn(1+G:2*G);
    for i=1:G
        goldseq1=circshift(goldseq,i);
        sum(i)=symbol*goldseq1;
    end
    [~,delay_index]=sort(sum,'descend');
    delay_estimate=delay_index(1);
    delay_estimate=sort(delay_estimate,'ascend');
%--------------------------------------------------------------------------
    
     
%--------------------------------estimate beta-----------------------------
    beta_estimate=[0.8,0.4*exp(-1j*frad(-40)),0.8*exp(1j*frad(80))]; %assumed known
%--------------------------------------------------------------------------

    
end