function w_sr=supres(array,jammal_dir,desired_dir)
%based on DOA
    a_j=spv(array,jammal_dir);
    a_d=spv(array,desired_dir);
    M=fpoc(a_j);
    w_sr=M*a_d;
end