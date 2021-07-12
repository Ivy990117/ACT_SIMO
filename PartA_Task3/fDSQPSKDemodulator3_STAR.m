function [bitsOut]=fDSQPSKDemodulator3_STAR(symbol_matrix,w_star,phi1)

    symbol_matrix=(w_star'*symbol_matrix).';
    n_symbols=length(symbol_matrix);
    bitsOut = zeros(2 * n_symbols, 1);
    phi2=phi1+pi/2;
    phi3=phi2+pi/2;
    phi4=phi3+pi/2;
    constellation=[cos(phi1)+1i*sin(phi1),cos(phi2)+1i*sin(phi2),cos(phi3)+1i*sin(phi3),cos(phi4)+1i*sin(phi4)];
    

    demol=zeros(n_symbols,4);
    demol_index=zeros(n_symbols,1);
 
    for i=1:n_symbols
        for j=1:4
            demol(i,j)=(norm(symbol_matrix(i)-constellation(j)))^2;
        end
        [~,demol_index(i)]=min(demol(i,:));
    end
    
    for i=1:n_symbols
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
            
end