function [delay_estimate, DOA_estimate] = fMusic2D_smoothing(array, tf_signalSmooth, tf_matrixSmooth, n_source, ft_subVect, n_delays, n_paths)
azimuth = 0: 180;
elevation = 0; 
delay = 1: n_delays;
% cost function
array_gain = zeros(length(azimuth), n_delays);
% obtain generalised noise eigenvectors
[eigVectNoise] = fNoiseDetect(tf_signalSmooth, tf_matrixSmooth);
for i = azimuth
    % the corresponding manifold vector
    S = spv(array, [i elevation]);
    for j = 1: n_delays
        % spatio-temporal array manifold
        starManifold = kron(S, ft_subVect .^ j);
        % cost function
        array_gain(i + 1, j) = 1 ./ (starManifold' * (eigVectNoise) * starManifold);
    end
end
% plot the 2-d MuSIC spectrum
plot2d3d(abs(array_gain.'), azimuth, delay, 'dB', '2-Dimensional MuSIC Spectrum');
% find max value of cost function for all directions
[Delay, doa_index] = max(abs(array_gain));
% then obtain positions of several max values that suggest delays
[~, delay_estimate] = maxk(Delay, n_paths);
% sort by delay
delay_estimate = sort(delay_estimate(1: n_paths));
% and find corresponding doas
DOA_estimate = doa_index(delay_estimate) - 1;
end