function full_neuron=graph_search_overlap(direc,batch_dir,shift_val,height,width)
direc=dir(direc);
files={direc.name};
vid_files={};
for i=1:length(files)
    [path,name,ext]=fileparts(files{i});
    if isequal(ext,'.mat');
        vid_files{end+1}=files{i};
    end
end

load(batch_dir);

[G,final_letter]=build_overlap_graph(vid_files,batches,shift_val,10,height,width);
Path_Storage={};
Distance={};
load(vid_files{1});
neuron_beg=neuron;
load(vid_files{end})
neuron_end=neuron;
for i=1:size(neuron_beg.C,1)
    paths=[];
    distances=[];
    for j=1:size(neuron_end.C,1)
        [path,distance]=shortestpath(G,horzcat('A',num2str(i)),horzcat(final_letter,num2str(j)));
        if ~isempty(path)
            paths=vertcat(paths,cellfun(@(x)extract_numeric(x),path));
            distances=[distances,distance];
        end
    end
    Path_Storage{end+1}=paths;
    Distance{end+1}=distances;
end
Path_Storage=vertcat(Path_Storage{:});
Distance=horzcat(Distance{:})/(length(vid_files));

%Greedy Selection
min_dist=3;
Final_Paths=[];
Final_Dist=[];
while min(Distance)<min_dist
    [M,I]=min(Distance);
    Final_Paths=vertcat(Final_Paths,Path_Storage(I,:));
    Final_Dist=[Final_Dist,M];
    for i=1:size(Path_Storage,2)
        indices=find(Path_Storage(:,i)==Final_Paths(end,i));
        Distance(indices)=[];
        Path_Storage(indices,:)=[];
    end
end
    
Path_Storage=Final_Paths;
Distance=Final_Dist;


%This was tacked on after the fact. Fix this if you get a chance as it just
%repeats calculations made while constructing the graph.
beg_overlap=shift_val+1;
index=2;
Correlations={};
KL={};
while index<=length(vid_files);
    overlap=sum(batches(beg_overlap:beg_overlap+1));

    load(vid_files{index-1});
    neuron1=neuron;
    load(vid_files{index});
    neuron2=neuron;
    Correlations{end+1}=correlations_positive(neuron1.C(:,end-overlap+1:end),neuron2.C(:,1:overlap));
    d1=size(neuron1.A,2);
    d2=size(neuron2.A,2);
    A1=neuron1.A;
    A2=neuron2.A;
    kl=zeros(d1,d2);
    parfor i=1:d1*d2
        [a,b]=ind2sub([d1,d2],i);
        kl(i)=spatial_overlap_via_bivariate_gaussian(A1(:,a),A2(:,b),height,width);
        
    end
    KL{end+1}=kl;
    beg_overlap=beg_overlap+shift_val;
    index=index+1;
end

corr_scores=zeros(length(Distance),length(vid_files)-1);
KL_scores=zeros(length(Distance),length(vid_files)-1);
for i=1:size(corr_scores,1)
    for j=1:size(corr_scores,2)
        corr_scores(i,j)=Correlations{j}(Path_Storage(i,j),Path_Storage(i,j+1));
        KL_scores(i,j)=KL{j}(Path_Storage(i,j),Path_Storage(i,j+1));
    end
end


corr_thresh=.4;
KL_thresh=3;
for i=length(Distance):-1:1
    if max(KL_scores(i,:))>KL_thresh||min(corr_scores(i,:))<corr_thresh
        Distance(i)=[];
        KL_scores(i,:)=[];
        corr_scores(i,:)=[];
        Path_Storage(i,:)=[];
    end
end


load(vid_files{1});
full_neuron=neuron.copy();
full_neuron.imageSize=[height,width];
full_neuron.C=full_neuron.C(Path_Storage(:,1),:);
full_neuron.S=full_neuron.S(Path_Storage(:,1),:);
full_neuron.C_raw=full_neuron.C_raw(Path_Storage(:,1),:);
full_neuron.A=full_neuron.A(:,Path_Storage(:,1));
full_neuron.scores=full_neuron.scores(Path_Storage(:,1));
full_neuron.combined=full_neuron.combined(Path_Storage(:,1));
full_neuron.overlap_corr=corr_scores;
full_neuron.overlap_KL=KL_scores;


beg_overlap=shift_val+1;
index=2;
while index<=length(vid_files)
    overlap=sum(batches(beg_overlap:beg_overlap+1));
    load(vid_files{index});
    full_neuron.C=horzcat(full_neuron.C(:,1:end-overlap),neuron.C(Path_Storage(:,index),:));
    full_neuron.C_raw=horzcat(full_neuron.C_raw(:,1:end-overlap),neuron.C_raw(Path_Storage(:,index),:));
    full_neuron.S=horzcat(full_neuron.S(:,1:end-overlap),neuron.S(Path_Storage(:,index),:));
    full_neuron.scores=[full_neuron.scores,neuron.scores(Path_Storage(:,index))];
    full_neuron.combined=[full_neuron.combined,neuron.combined(Path_Storage(:,index))];
    full_neuron.A=full_neuron.A+neuron.A(:,Path_Storage(:,index));
    beg_overlap=beg_overlap+shift_val;
    index=index+1;

end
full_neuron.A=full_neuron.A/length(vid_files);
full_neuron.centroid=[];
full_neuron=thresholdNeuron(full_neuron,.35);
for i=1:size(full_neuron.A,2);
    centroid=calculateCentroid(full_neuron.A(:,i),height,width);
    full_neuron.centroid=[full_neuron.centroid;centroid];
end
end