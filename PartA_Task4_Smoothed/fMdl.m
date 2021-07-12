function n_source = fMdl(n_samples, tf_signalSmooth)
[~, eig_value] = eig(tf_signalSmooth);
eig_value = sort(abs(diag(eig_value)));
n_receivers = length(eig_value);
MDL = (-n_samples) * (log(flip(cumprod(eig_value))) + (n_receivers: -1: 1)' .* (log((n_receivers: -1: 1)') - log(flip(cumsum(eig_value))))) + 1/2 * log(n_receivers) * (0: n_receivers - 1)' .* (2 * n_receivers: -1: n_receivers + 1)'; 
[~, index] = min(MDL);
n_source = index - 1;
end