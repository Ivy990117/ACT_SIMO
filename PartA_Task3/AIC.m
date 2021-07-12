function M=AIC(Rxx,N,L)
    [E,D]=eig(Rxx);
    D_Diag=abs(diag(D))';
    d=sort(D_Diag,'descend');
    for k=0:N-1
        coef=1/(N-k);
        product=prod(d(k+1:N)).^coef;
        d_sum=coef*sum(d(k+1:N));
        AIC(k+1)=-2*L*log((product/d_sum)^(N-k))+2*k*(2*N-k);
    end
    [~,index]=min(AIC);
    M=index-1;
end