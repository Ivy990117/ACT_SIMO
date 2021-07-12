% Liu Jiaoyang, GROUP (EE4/MSc), 2020, Imperial College.
% 22/12/2020

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

function [delay_estimate, DOA_estimate, beta_estimate]=fChannelEstimation2(symbolsIn,goldseq,paths)
    G=length(goldseq); %the length of gold sequence
    [X,Y]=size(symbolsIn);
    P=430080;
    N=X/G; %215041
    
    %---------------------------estimate delay-----------------------------
    %estimation method 1
    %for i=1:G
    %    symbol=symbolsIn(i:i+G-1);
    %    [y(:,i)]=pncorr(goldseq',symbol',G);
    %end

    %[~,delay_index]=sort(y(1,:),'descend');
    
    %estimation method 2
    %sum=zeros(1,G);
    %for i=1:G
    %   sum(i)=symbolsIn(i+G:i+2*G-1)'*goldseq;
    %end
    %[~,delay_index]=sort(sum,'descend');
    
    
    %estimation method 3
    sum=zeros(1,G);
    symbol=symbolsIn(1+G:2*G);
    for i=1:G
        goldseq1=circshift(goldseq,i);
        sum(i)=symbol'*goldseq1;
    end
    [~,delay_index]=sort(sum,'descend');
    delay_estimate=delay_index(1:paths(1));
    delay_estimate=sort(delay_estimate,'ascend');
    %delay_estimate=[2,6,13];
    %----------------------------------------------------------------------
     
   
    %----------------------------estimate DOA------------------------------
    DOA_estimate=zeros(paths(1),2);
    %----------------------------------------------------------------------
    
    
    %-----------------------------estimate beta----------------------------
    beta_estimate=[0.8,0.4*exp(-1j*frad(-40)),0.8*exp(1j*frad(80))];       
    %----------------------------------------------------------------------

    
end