% Liu Jiaoyang, GROUP (EE4/MSc), 2021, Imperial College.
% 4/1/2021

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Performs channel estimation for the desired source using the received signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% symbolsIn (Fx1 Complex) = R channel symbol chips received
% goldseq (Wx1 Integers) = W bits of 1's and -1's representing the gold
% sequence of the desired source used in the modulation process
% array (5*3 double) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% delay_estimate = Vector of estimates of the delays of each path of the
% desired signal
% DOA_estimate = Estimates of the azimuth and elevation of each path of the
% desired signal
% beta_estimate = Estimates of the fading coefficients of each path of the
% desired signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [delay_estimate, DOA_estimate, beta_estimate, symbol_matrix,J]=fChannelEstimation3_STAR(symbolsIn,goldseq,array,noise_power)
    
    %------------------------------Inilization-----------------------------
    G=length(goldseq); %the length of gold sequence
    % n_receivers-the number of receivers && l_symbols-the length of symbols 
 
    delay=1:G;
    % possible azimuth and elevation angles of arrival
    azimuth = 0: 180; 
    %----------------------------------------------------------------------
    
    
    %---------------------generate symbol_matrix---------------------------
    symbol_matrix=fVect(symbolsIn,goldseq);
    %----------------------------------------------------------------------
    
    
    %--------------------generate covariance matrix------------------------
    Rxx=symbol_matrix*symbol_matrix'/size(symbol_matrix,2);
    %----------------------------------------------------------------------
    
    
    %--------------------generate J and delayed Jc-------------------------
    [J,Jc]=fShifting(goldseq);
    %----------------------------------------------------------------------


    %---------------------estimate DOA and delay---------------------------
    Z=fMusic2D_Part3(Rxx,G,array,Jc,noise_power);
    plot2d3d(Z.', azimuth, delay, 'dB', '2-Dimensional MuSIC Spectrum');
    
    [Z_delay,doa_index]=max(Z);
    [~,delay_estimate]=max(Z_delay);
    
    DOA_estimate=doa_index(delay_estimate)-1;
    DOA_estimate=[DOA_estimate' 0];
    %----------------------------------------------------------------------

     
    %----------------------------estimate beta-----------------------------
    beta_estimate=1;
    %----------------------------------------------------------------------   
end