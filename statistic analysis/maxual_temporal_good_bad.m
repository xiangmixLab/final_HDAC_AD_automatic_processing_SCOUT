function del_idx=maxual_temporal_good_bad(foldername)

midx=[1:length(foldername)];
figure;
good_trace={};
bad_trace={};
del_idx={};
ctt1=1;
ctt2=1;
for i=midx
    load([foldername{i},'\','further_processed_neuron_extraction_final_result.mat']);
    del_idx{i}=zeros(size(neuron.C,1),1);
    for j=1:size(neuron.C,1)
        
        plot(neuron.C(j,:));
%         ylim([0 max(neuron.C(:))])
        title([num2str(j),'/',num2str(size(neuron.C,1))])
        drawnow;
        strr=input('good or bad (g/b)','s')
        if isequal(strr,'g')
            good_trace{ctt1}=neuron.C(j,:);
            ctt1=ctt1+1;
        end
        if isequal(strr,'b')
            bad_trace{ctt2}=neuron.C(j,:);
            del_idx{i}(j)=1;
            ctt2=ctt2+1;
        end
        clf;
    end
end