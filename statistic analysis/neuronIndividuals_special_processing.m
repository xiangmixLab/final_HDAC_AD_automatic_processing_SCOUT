%neuronIndividuals{i} individual secial special processing
function neuronIndividuals=neuronIndividuals_special_processing(neuronIndividuals,thresh)

for i=1:length(neuronIndividuals)
    % a special processing to neuronIndividuals{i}.S (make it: corresponding to each peak; its value is the peak value)
    for nscg=1:size(neuronIndividuals{i}.S,1)
        nC=neuronIndividuals{i}.C(nscg,:);
        [pks,loc]=findpeaks(nC);% for neuronIndividuals{i}.S, its thresholding will be performed later 
        neuronIndividuals{i}.S(nscg,:)=neuronIndividuals{i}.S(nscg,:)*0;
        neuronIndividuals{i}.S(nscg,loc)=pks;
    end
    % another special variable (first crossing of sig. peak)
    for nscg=1:size(neuronIndividuals{i}.S,1)
        nC=neuronIndividuals{i}.C(nscg,:);
        nC(nC<thresh(nscg))=0;% better thresholding now. later thresholding makes no difference
        idx=diff(nC>0);
        neuronIndividuals{i}.trace(nscg,:)=[idx==1,0];
    end
end