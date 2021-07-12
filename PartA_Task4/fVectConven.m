function symbol_matrix=fVectConven(symbolsIn,goldseq)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Performs symbol vectorisation for symbol stream
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% symbolsIn (5X7471 Complex) = 5 antennas symbol chips received
% goldseq (31x1 Integers) = 31 bits of 1's and -1's representing the gold
% sequence of the desired source used in the modulation process
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% TappedDelayLine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    G=length(goldseq); %the length of gold sequence
    [n_receivers,n_snapshots]=size(symbolsIn); % n_receivers-the number of receivers && n_snapshots-the length of symbols    
    q=2;
  
   
    %-------------------------generate symbol matrix-----------------------
    %symbol_matrix = zeros(n_receivers*q*G, (n_snapshots-G)/G);
    N_ext=q*G;
  
    for i=1:n_receivers
        symbols=reshape(symbolsIn(i,:),[G,n_snapshots/G]);
        symbols_ext=kron(symbols,ones(1,2));
        symbol_matrix((i-1)*N_ext+1:i*N_ext,:)=reshape(symbols_ext(:,2:end-1),[N_ext,(n_snapshots-G)/G]);
    end

    %----------------------------------------------------------------------

end
