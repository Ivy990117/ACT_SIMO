function [J,Jc]=fShifting(goldseq)
    Jc=[];
    q=2;
    G=length(goldseq);
    gold_extend=[goldseq;zeros(G,1)]; %extend goldseq
    J=[zeros(1,q*G);[eye(q*G-1),zeros(q*G-1,1)]]; %shifting matrix
    for i=1:G
        Jc=[Jc J^i*gold_extend];
    end
end