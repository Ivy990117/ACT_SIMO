% Liu Jiaoyang, GROUP (EE4/MSc), 2020, Imperial College.
% 20/12/2020

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

function [symbolsOut]=fChannel(paths,symbolsIn,delay,beta,DOA,SNR,array)

    M=length(paths);
    R=length(symbolsIn(1,:));
    
    extend=max(delay);
    
    for i=1:100
        g=15*i;
        if extend<g
            extend=g;
            break;
        end
    end
 
    channel_symbols=zeros(3,R+extend);
    symbolsIn=[symbolsIn zeros(3,extend)];
    symbolsOut=zeros(1,R+extend);
    
    for i=1:M
        temp=symbolsIn(i,:);
        channel_symbols(i,:)=beta(i)*circshift(temp,delay(i));
        %symbolsOut=symbolsOut+channel_symbols(i,:);
    end
    
    S=spv(array,DOA);
    
    sig_power=sum(abs(channel_symbols(1,:)).^2)/length(channel_symbols(1,:));
    noise_power=sig_power/(10^(SNR/10));
    noise=sqrt(noise_power/2)*(randn(1,length(symbolsOut))+1i*randn(1,length(symbolsOut)));
    
    [symbolsOut]=S*channel_symbols+noise; %1*3225615
    %[symbolsOut]=S*channel_symbols;

end