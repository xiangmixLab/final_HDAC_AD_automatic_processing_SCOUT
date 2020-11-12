nA=neuronIndividuals_new{1}.A;

nC_ori=[];
for i=1:size(nA,2)
    At=reshape(nA(:,i),240,376);
    At=At>max(At(:))*0.5;
    for jk=1:size(concatenatedvideo_res,3)
        ft=squeeze(concatenatedvideo_res(:,:,jk));
        ft=double(ft).*double(At);
        nC_ori(i,jk)=sum(ft(:))/sum(sum(ft>0));
    end
end
        
    
    