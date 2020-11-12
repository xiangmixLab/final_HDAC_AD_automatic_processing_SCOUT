function BatchEndoscopeWrapper()

%f= dir('/pub/kgjohnst/higherdirectory'); 
f=dir('./');
total_files={f.name};
vid_files={};
for i=1:length(total_files)
    [filepath,name,ext]= fileparts(total_files{i});
    if isequal(ext,'.tif')||isequal(ext,'.mat')
        vid_files{end+1}=horzcat(filepath,name,ext);
    end
end

vid_files=sort(vid_files);
%load('/pub/kgjohnst/batches');
%load('./batches')
batches=[2000,2000];
batch_sizes={};
j=1;
i=1;
while j<length(batches)
    batch_sizes{i}=batches(j:min(j+6,length(batches)));
    j=j+5;
    i=i+1;
end
for i=1:6:length(batch_sizes)
    parfor j=i:min(i+5,length(batch_sizes))
    
    BatchEndoscopeAutoHPC_adjustedgraphsearch(horzcat('./',vid_files{j}),batch_sizes{j});
    end
end