function symbol_matrix=fVect(symbolsIn,goldseq)
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
    symbolsIn=symbolsIn.';
   
    %-------------------------generate symbol matrix-----------------------
    symbol_matrix = zeros(n_receivers*q*G, (n_snapshots-G)/G);
    for i=1:n_receivers
        symbol=symbolsIn(:,i);
        % odd columns of symbol matrix
        symbol_matrix((i-1)*q*G+1 : i*q*G, 1:2:end-1) = reshape(symbol(1:length(symbol)-G), q*G,(length(symbol)-G)/(q*G));
        % even columns of symbol matrix
        symbol_matrix((i-1)*q*G+1 : i*q*G, 2:2:end) = reshape(symbol(G+1:length(symbol)), q*G, (length(symbol)-G)/(q*G));     
    end
    %----------------------------------------------------------------------

end
