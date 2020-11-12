fr_table={};

fr_table(1,:)={'mouse name','# of cells','min rate','max rate','mean rate','median rate'};

for i=1:length(folderName)
    slashpos=strfind(folderName{i},'\');
    fr_table{i+1,1}=[folderName{i}(slashpos(end-1)+1:slashpos(end)-1),'_',folderName{i}(slashpos(end)+1:end)];
    load([folderName{i},'\','further_processed_neuron_extraction_final_result.mat']);
    fr_table{i+1,2}=size(neuron.C,1);
    fr=sum(neuron.S>0,2)/(size(neuron.S,2)/15);
    fr_table{i+1,3}=min(fr);
    fr_table{i+1,4}=max(fr);
    fr_table{i+1,5}=mean(fr);
    fr_table{i+1,6}=median(fr);
end