function Z=fMusic(array,Rxx_theoretical,M)
[E,D]=eig(Rxx_theoretical);
D1=diag(D)';
[D1,I]=sort(D1);
EV=fliplr(E(:,I));
N=length(D);
ES=EV(:,1:M);
%En=EV(:,M+1:N);
Pn=fpoc(ES);
d=[(0:360)' zeros(361,1)];
a=spv(array,d);

for i=1:361
    SP(i)=abs(1/(a(:,i)'*Pn*a(:,i)));
end

%Z=SP;
Z=10*log10(SP);
end
