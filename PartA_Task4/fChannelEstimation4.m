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

function [delay_estimate, DOA_estimate, symbol_matrix,J]=fChannelEstimation4(symbolsIn,goldseq,array,n_paths)
    
    %------------------------------Inilization-----------------------------
    G=length(goldseq); %the length of gold sequence
    [n_receivers,n_snapshots]=size(symbolsIn); % n_receivers-the number of receivers && n_snapshots-the length of symbols  
    n_delays=G;
    %----------------------------------------------------------------------
    
    
    %---------------------generate symbol_matrix---------------------------
    symbol_matrix=fVectConven(symbolsIn,goldseq);
    %----------------------------------------------------------------------

    
    %---------------------generate covariance matrix----------------------- 
    symbolsIn=symbolsIn.';
    Rxx=symbol_matrix*symbol_matrix'/size(symbol_matrix,2);
    %----------------------------------------------------------------------

    
    %--------------------generate J and delayed Jc-------------------------
    [J,Jc]=fShifting(goldseq);
    %----------------------------------------------------------------------


    %---------------------estimate DOA and delay---------------------------
    Z=fMusic2D(Rxx,G,array,Jc);
    azimuth=0:180;
    delay=1:G;
    plot2d3d(Z.', azimuth, delay, 'dB', '2-Dimensional MuSIC Spectrum');
    
    [Z_delay,doa_index]=max(Z);
    [~,delay_estimate]=maxk(Z_delay,n_paths);
    delay_estimate=sort(delay_estimate);
    DOA_estimate=doa_index(delay_estimate)-1;
    DOA_estimate=[DOA_estimate' zeros(3,1)];
    %----------------------------------------------------------------------

      
end