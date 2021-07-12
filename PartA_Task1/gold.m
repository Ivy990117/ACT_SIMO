function [goldseq]=gold(coeffs1,coeffs2,n_gold)
X=12; %The first letter of my surname is L
Y=10; %The first letter of my formalname is J

%generate two m-sequences
MSeq1=fMSeqGen(coeffs1);
MSeq2=fMSeqGen(coeffs2);

%generate gold-sequence sets
len=length(MSeq1);
gold_seq_sets=zeros(len,len);
for k=1:len
    gold_seq_sets(:,k)=fGoldSeq(MSeq1,MSeq2,k);
end

%search balanced gold-sequence
sum_gold=zeros(1,len);
bal_gold=[];
bal_gold_index=[];

for i=1:len
    sum_gold(i)=sum(gold_seq_sets(:,i));
    if(sum_gold(i)==8)
        bal_gold_index=[bal_gold_index,i];
    end
end

%search proper delay
d_min=1+mod((X+Y),12);
shift=zeros(1,n_gold);
goldseq=zeros(len,n_gold);

for i=1:length(bal_gold_index)
    if bal_gold_index(i)>d_min
        shift(1)=bal_gold_index(i);
        break
    end
end

%generate three gold-sequences
goldseq(:,1)=fGoldSeq(MSeq1,MSeq2,shift(1));

for i=2:n_gold
   shift(i)=shift(i-1)+1;
   goldseq(:,i)=fGoldSeq(MSeq1,MSeq2,shift(i));
end

goldseq=1-2*goldseq;


end