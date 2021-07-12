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

function [bitsOut]=fDSQPSKDemodulator3(symbolsIn,goldseq,delay_estimate,phi)

    G=length(goldseq); %the length of gold sequence
    [X,Y]=size(symbolsIn);
    P=430080;
    L=P/2;

    
%----------------------------------DSS-------------------------------------
    goldseq=circshift(goldseq,delay_estimate);
    symbol_reshape=reshape(symbolsIn,G,[]);
    symbol_despread=symbol_reshape.'*goldseq;
    symbol_despread=symbol_despread(1:L)';%1*215040 
%--------------------------------------------------------------------------


%------------------------------QPSK Demodulate-----------------------------
    phi1=frad(phi);
    phi2=phi1+pi/2;
    phi3=phi2+pi/2;
    phi4=phi3+pi/2;
    constellation=[cos(phi1)+1i*sin(phi1),cos(phi2)+1i*sin(phi2),cos(phi3)+1i*sin(phi3),cos(phi4)+1i*sin(phi4)];
    

    demol=zeros(L,4);
    demol_index=zeros(L,1);
    bitsOut=zeros(P,1);
    for i=1:L
        for j=1:4
            demol(i,j)=(norm(symbol_despread(i)-constellation(j)))^2;
        end
        [~,demol_index(i)]=min(demol(i,:));
    end
    
    for i=1:L
        if demol_index(i)==1
            bitsOut(2*i-1)=0;
            bitsOut(2*i)=0;
        elseif demol_index(i)==2
            bitsOut(2*i-1)=0;
            bitsOut(2*i)=1;
        elseif demol_index(i)==3
            bitsOut(2*i-1)=1;
            bitsOut(2*i)=0;
        elseif demol_index(i)==4
            bitsOut(2*i-1)=1;
            bitsOut(2*i)=1;
        end
    end  %430080*1   
%--------------------------------------------------------------------------

end