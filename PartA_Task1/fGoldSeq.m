% Liu Jiaoyang, GROUP (EE4/MSc), 2020, Imperial College.
% 20/12/2020


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Takes two M-Sequences of the same length and produces a gold sequence by
% adding a delay and performing modulo 2 addition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% mseq1 (Wx1 Integer) = First M-Sequence
% mseq2 (Wx1 Integer) = Second M-Sequence
% shift (Integer) = Number of chips to shift second M-Sequence to the right
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% GoldSeq (Wx1 Integer) = W bits of 1's and 0's
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [GoldSeq]=fGoldSeq(mseq1,mseq2,shift)
    %N=2^length(mseq1)-1;
    mseq2=circshift(mseq2,shift);
    GoldSeq=mod(mseq1+mseq2,2);
    
end