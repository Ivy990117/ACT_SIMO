% Liu Jiaoyang, GROUP (EE4/MSc), 2020, Imperial College.
% 20/12/2020

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Takes polynomial weights and produces an M-Sequence
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% coeffs (Px1 Integers) = Polynomial coefficients. For example, if the
% polynomial is D^5+D^3+D^1+1 then the coeffs vector will be [1;0;1;0;1;1]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% MSeq (Wx1 Integers) = W bits of 1's and 0's
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [MSeq]=fMSeqGen(coeffs)
    n=length(coeffs)-1;
    N=2^n-1; %the length of m sequence
    C=coeffs(2:n+1);
    MSeq=zeros(N,1);
    register=ones(n,1); %define initial state of register
    
    for i=1:N
        MSeq(i)=register(n);
        s=mod(sum(C.*register),2);
        register=circshift(register,1);
        register(1)=s;
        MSeq(i)=register(n);
    end 
end

