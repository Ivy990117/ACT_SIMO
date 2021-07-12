function [tf_signalSmooth] = fTemporal_smoothing(n_subVects, l_subVects, G, Rxx)
n_segments = length(Rxx) / (2 * G);
for i = 1: n_segments
    for j = 1: n_segments
        % data on each antenna
        Rxx_segment = Rxx((i - 1) * 2 * G + 1: i* 2 * G, (j - 1) * 2 *G + 1: j * 2 * G);
        Rxx_sub = 0;
        for m = 1: n_subVects
            % divide into subvectors and sum them
            Rxx_sub = Rxx_sub + Rxx_segment(m: m + l_subVects - 1, m: m + l_subVects - 1);
        end
        % take average of subvectors
        Rxx_sub = Rxx_sub / n_subVects;
        % the submatrix is part of smoothed result
        tf_signalSmooth((i - 1) * l_subVects + 1: i * l_subVects, (j - 1) * l_subVects + 1: j * l_subVects) = Rxx_sub;
    end
end
end