function Z=fMusic2D(Rxx,G,array,Jc)
    [E,D]=eig(Rxx); %eigen-decomposition
    D_Diag=abs(diag(D));
    threshold=0.01;
    M=sum(D_Diag>threshold);
    E_Signal=E(:,D_Diag>threshold); %eigen_vector_signal
    Pn=fpoc(E_Signal);
    azimuth=0:180;
    elevation=0;
    n_delay=G;
    
    for i=azimuth
        S=spv(array,[i elevation]);
        for j=1:n_delay
            h=kron(S,Jc(:,j));
            Z(i+1,j)=1./abs(h'*Pn*h);
        end
    end
end