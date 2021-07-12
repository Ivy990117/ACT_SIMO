% NAME, GROUP (EE4/MSc), 2010, Imperial College.
% DATE

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Models the channel effects in the system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% paths (Mx1 Integers) = Number of paths for each source in the system.
% For example, if 3 sources with 1, 3 and 2 paths respectively then
% paths=[1;3;2]
% symbolsIn (MxR Complex) = Signals being transmitted in the channel
% delay (Cx1 Integers) = Delay for each path in the system starting with
% source 1
% beta (Cx1 Integers) = Fading Coefficient for each path in the system
% starting with source 1 
% DOA = Direction of Arrival for each source in the system in the form
% [Azimuth, Elevation]
% SNR = Signal to Noise Ratio in dB
% array = Array locations in half unit wavelength. If no array then should
% be [0,0,0]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% symbolsOut (FxN Complex) = F channel symbol chips received from each antenna
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [symbolsOut,noise_power]=fChannel3(paths,symbolsIn,delay,beta,DOA,SNR,array)

    M=length(paths);
    N=length(beta);
    O=length(symbolsIn(1,:));
    
    %generate the practical number of extension
    extend=max(delay);
    
    for i=1:100
        g=15*i;
        if extend<g
            extend=g;
            break;
        end
    end
    
    %extend the symbols 
    channel_symbols=zeros(N,O+extend);
    symbolsIn=[symbolsIn zeros(M,extend)];
    symbolsOut=zeros(M,O+extend);
    
    %generate channel symbols
    t=0;
    for i=1:M
        for j=1:paths(i)
            t=t+1;
            channel_symbols(t,:)=beta(t)*circshift(symbolsIn(i,:),delay(t));
        end
    end
    
    %the pattern of the array
    S=spv(array,DOA); 
    
    [R,C]=size(array);
    
    %power
    sig_power=sum(abs(channel_symbols(1,:)).^2)/length(channel_symbols(1,:));
    noise_power=sig_power/(10^(SNR/10));
    
    noise=sqrt(noise_power/2)*(randn(R,length(symbolsOut))+1i*randn(R,length(symbolsOut)));
    
    [symbolsOut]=S*channel_symbols+noise; %R*3225615
    %[symbolsOut]=S*channel_symbols;


end