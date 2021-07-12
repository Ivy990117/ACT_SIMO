% Liu Jiaoyang, GROUP (EE4/MSc), 2020, Imperial College.
% 20/12/2020

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

function [delay_estimate, DOA_estimate, beta_estimate]=fChannelEstimation(symbolsIn,goldseq)
    G=length(goldseq); %the length of gold sequence
    [X,Y]=size(symbolsIn);
    P=430080;
    N=X/G; %215041
    
    %---------------------------estimate delay-----------------------------   
%     sum=zeros(1,G);
%     symbol=symbolsIn(1+G:2*G);
%     for i=1:G
%         goldseq1=circshift(goldseq,i);
%         sum(i)=symbol'*goldseq1;
%     end
%     [~,delay_estimate]=max(sum);
    
    
    delay_max = length(symbolsIn) - G;

    % all possible correlation functions
    coorelate_set = zeros(delay_max, 1);
    
    for i = 1: delay_max
    % calculate the correlation functions for all possible delays
    coorelate_set(i) = abs(symbolsIn(i:i+G-1).' * goldseq);
    end
    
    [~, delay_index] = sort(coorelate_set, 'descend');
    % find the residues of indexes and delete the repeated values
    index = unique(mod(delay_index, G), 'stable');
    % the first unique residue can suggest the delay
    delay_estimate = index(1) - 1;
    %----------------------------------------------------------------------
    
   
    %----------------------------estimate DOA------------------------------
    DOA_estimate=[0,0;0,0;0,0];
    %----------------------------------------------------------------------
    
    
    %-----------------------------estimate beta----------------------------
     beta_estimate=1;
    %----------------------------------------------------------------------

    
  
    
end