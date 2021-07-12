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

function [delay_estimate, DOA_estimate, symbol_matrix,J]=fChannelEstimation4_smoothed(symbolsIn,goldseq,array,n_paths,symbol_matrix)
    G=length(goldseq); %the length of gold sequence
    [n_receivers,n_snapshots]=size(symbolsIn); % n_receivers-the number of receivers && n_snapshots-the length of symbols  
    n_delays=G;

    % Fourier transformation vector
    ft_vect = zeros(2 * G, 1);
    % Fourier transformation matrix
    ft_matrix = zeros(2 * G);
    % Fourier transformation constant
    ft_const = exp(-1i * pi / G);
    
    n_samples=size(symbol_matrix,2);
    gold_extend=[goldseq; zeros(size(goldseq))];
    
    % construct Fourier transformation vector with ft constant
    for i = 1: 2 * G
        ft_vect(i) = ft_const ^ (i - 1);
    end
    
    % construct Fourier transformation matrix with ft vector
    for i = 1: 2 * G
        ft_matrix(:, i) = ft_vect .^ (i - 1);
    end
    
    tf_matrix = kron(eye(n_receivers), diag(ft_matrix * gold_extend)\ft_matrix);
    % transformed signal
    tf_signal = tf_matrix * symbol_matrix;
    % covariance matrix of transformed signal
    Rxx = tf_signal * tf_signal' / size(tf_signal, 2);
    % number of space-time subvectors
    n_subVects = n_paths;
    % length of space-time subvectors (d + Q - 1 <= 2 * Nc)
    l_subVects = 2 * G - 1 - n_subVects;
    % obtain Fourier transformation subvector
    ft_subVect = ft_vect(1: l_subVects);
    % perform temporal smoothing for signal
    [tf_signalSmooth] = fTemporal_smoothing(n_subVects, l_subVects, G, Rxx);
    % perform temporal smoothing for transformation
    L=diag(diag(tf_matrix * tf_matrix'));
    [tf_matrixSmooth] = fTemporal_smoothing(n_subVects, l_subVects, G, L);
    % MDL estimation
    n_source = fMdl(n_samples, tf_signalSmooth);
    % doa and delay estimation
    [delay_estimate, DOA_estimate] = fMusic2D_smoothing(array, tf_signalSmooth, tf_matrixSmooth, n_source, ft_subVect, n_delays, n_paths);
    
    DOA_estimate=[DOA_estimate', zeros(3,1)];
    
      
end