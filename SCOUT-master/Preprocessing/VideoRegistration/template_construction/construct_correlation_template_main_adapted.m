function templates=construct_correlation_template_main_adapted(data_type,vid_files)
if ~exist('data_type','var')||isempty(data_type)
    data_type='1p';
end
mkdir templates

vids=vid_files;
vids_lower=lower(vid_files);

[~,ind]=sort_nat(vids_lower);
vids=vids(ind);

for i=1:length(vids)
    
    templates{i}=construct_correlation_template(['./',vids{i}],[],20,12,'prc',18,data_type);
    
end

cd templates
for i=1:length(templates)
    template=templates{i};
    save(['templates',num2str(i)],'template')
end


cd ..
    