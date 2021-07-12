% Liu Jiaoyang, GROUP (EE4/MSc), 2020, Imperial College.
% 22/12/2020

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Perform DS-QPSK Modulation on a vector of bits using a gold sequence
% with channel symbols set by a phase phi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% bitsIn (Px1 Integers) = P bits of 1's and 0's to be modulated
% goldseq (Wx1 Integers) = W bits of 1's and 0's representing the gold
% sequence to be used in the modulation process
% phi (Integer) = Angle index in degrees of the QPSK constellation points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% symbolsOut (Rx1 Complex) = R channel symbol chips after DS-QPSK Modulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [symbolsOut]=fDSQPSKModulator(bitsIn,goldseq,phi)
    
%-----------------------------------QPSK-----------------------------------
    phi1=frad(phi);
    phi2=phi1+pi/2;
    phi3=phi2+pi/2;
    phi4=phi3+pi/2;
    L=length(bitsIn);
    constellation=[cos(phi1)+1i*sin(phi1),cos(phi2)+1i*sin(phi2),cos(phi3)+1i*sin(phi3),cos(phi4)+1i*sin(phi4)];
    for i=1:L/2
        if bitsIn(2*i-1)==0 && bitsIn(2*i)==0
            symbolsOut(i)=constellation(1);
        elseif bitsIn(2*i-1)==0 && bitsIn(2*i)==1
            symbolsOut(i)=constellation(2);
        elseif bitsIn(2*i-1)==1 && bitsIn(2*i)==0
            symbolsOut(i)=constellation(3);
        elseif bitsIn(2*i-1)==1 && bitsIn(2*i)==1
            symbolsOut(i)=constellation(4); %1*215040
        end
    end
%--------------------------------------------------------------------------


%------------------------------------DS------------------------------------
    symbolsOut = symbolsOut' * goldseq';
    symbolsOut = reshape(symbolsOut.', numel(symbolsOut), 1)';
%--------------------------------------------------------------------------
    
end