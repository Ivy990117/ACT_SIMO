% NAME, GROUP (EE4/MSc), 2010, Imperial College.
% DATE

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Perform demodulation of the received data using <INSERT TYPE OF RECEIVER>
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% symbolsIn (Fx1 Integers) = R channel symbol chips received
% goldseq (Wx1 Integers) = W bits of 1's and 0's representing the gold
% sequence of the desired signal to be used in the demodulation process
% phi (Integer) = Angle index in degrees of the QPSK constellation points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% bitsOut (Px1 Integers) = P demodulated bits of 1's and 0's
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [bitsOut]=fDSQPSKDemodulator4(symbol_matrix,w_star,phi)

    symbol_matrix=(w_star'*symbol_matrix).';
    n_symbols=length(symbol_matrix);
    bitsOut = zeros(2 * n_symbols, 1);
    angle_qpsk = [phi, phi + pi / 2, phi - pi, phi - pi / 2];
    for i=1:n_symbols
        [~,temp]=min(abs(angle(symbol_matrix(i))-angle_qpsk));
        if temp==1
            bitsOut(2*i-1:2*i)=[0,0];
        elseif temp==2
            bitsOut(2*i-1:2*i)=[0,1];
        elseif temp==3
            bitsOut(2*i-1:2*i)=[1,1];
        else
            bitsOut(2*i-1:2*i)=[1,0];
        end
    end
            
end