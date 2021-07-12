function [w_star] = fStarRake(array, DOA_estimate, delay_estimate, goldseq, n_paths, fading_coeffs,J)
   G=length(goldseq); 
   n_receivers=length(array);
   gold_extend = [goldseq; zeros(size(goldseq))];
   star_manifold=zeros(2*n_receivers*G,n_paths);
   for i=1:n_paths
       S=spv(array,DOA_estimate(i,:));
       star_manifold(:,i)=kron(S,J^delay_estimate(i)*gold_extend);
   end
   w_star=star_manifold*fading_coeffs;
end
   