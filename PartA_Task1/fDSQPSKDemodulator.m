% Liu Jiaoyang, GROUP (EE4/MSc), 2020, Imperial College.
% 20/12/2020

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

function [bitsOut]=fDSQPSKDemodulator2(symbolsIn,goldseq,delay_estimate,phi,beta)

    G=length(goldseq); %the length of gold sequence
    [X,Y]=size(symbolsIn);
    P=430080;
    L=P/2;
    N=X/G;
    
%----------------------------------DSS-------------------------------------
    paths=[1,1,1];
    symbol_despread=[];
    sigs=zeros(L*G,paths(1));
    %symbol_despread=zeros(L,paths(1));
    %symbol_despread1=zeros(L*G,paths(1));
    for i=1:paths(1)
        sigs(:,i)=symbolsIn(1+delay_estimate(i):L*G+delay_estimate(i));
        symbol_reshape=reshape(sigs(:,i),G,[]);
        symbol_despread=[symbol_despread symbol_reshape.'*goldseq];          
    end   
%--------------------------------------------------------------------------
 

%--------------------------------diversity---------------------------------
    weight=real(beta); %1*3
    %weight=[0.8,0.4,0.2];
    %for i=1:paths(1)
    %    weight(i)=norm(beta(i));
    %end
    symbol_despread=symbol_despread*weight';
    symbol_despread=symbol_despread'; %1*215040
 
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