function M=MDL(Rxx,N,L)
% N--the number of receivers
% L--the length of symbols
D=abs(eig(Rxx));
D=sort(D);

 
%MDL detection
d_mul=ones(N,1);
d_mul(N)=D(1);
for i=2:N
    d_mul(N-i+1)=D(i)*d_mul(N-i+2);
end
d_mul_ln=zeros(N,1);

n1=zeros(N,1);
for i=1:N
    n1(i)=N-i+1;
end
n1_ln=zeros(N,1);

d_sum=zeros(N,1);
d_sum_ln=zeros(N,1);
d_sum(N)=D(1);
for i=2:N
    d_sum(N-i+1)=D(i)+d_sum(N-i+2);
end

for i=1:N
    d_sum_ln(i)=log(d_sum(i));
    n1_ln(i)=log(n1(i));
    d_mul_ln(i)=log(d_mul(i));
end
    

n2=zeros(N,1);
for i=1:N
    n2(i)=i-1;
end

n3=zeros(N,1);
for i=1:N
    n3(i)=2*N-i+1;
end

a=n1.*(n1_ln-d_sum_ln);

MDL=real(-L*(d_mul_ln+a)+1/2*log(L)*n2.*n3);
[~,index]=min(MDL);

M=index-1;
end