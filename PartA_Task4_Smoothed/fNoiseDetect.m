function [eigVectNoise] = fNoiseDetect(tf_signalSmooth, tf_matrixSmooth)
[E, D] = eig(tf_signalSmooth, diag(diag(tf_matrixSmooth)));
D = abs(diag(D));
% signal and noise eigenvalue threshold
threshold = 0.01;
% signal eigenvector
eigVectSignal = E(:, D > threshold);
% generalised noise eigenvector
eigVectNoise = fpoc(eigVectSignal);
end