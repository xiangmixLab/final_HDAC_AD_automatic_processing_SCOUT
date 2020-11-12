function maxPosRegion=maxposregioncal(behavcell,neuron,neuronIndividuals)

neuronc = concatenateMUltiConditionNeuronData_adapted(neuron,[],[],neuronIndividuals,[],[],[]);
% 
bvcempty=~cellfun(@isempty,behavcell);
bvcnotempty_id1=min(find(bvcempty==1));

behavposc=[behavcell{1,bvcnotempty_id1}.position(1,:)];
behavtimec=[0];
behavroi=[];
for j=1:length(behavcell)
    if ~isempty(behavcell{1,j})
        behavposc=[behavposc;behavcell{1,j}.position(2:end,:)];
        behavtimec=[behavtimec;behavcell{1,j}.time(2:end)+max(behavtimec)];
        behavroi(j,:)=[behavcell{1,j}.ROI(3),behavcell{1,j}.ROI(4)];
    end
end
downsampling = length(neuronc.time)/size(neuronc.trace,2);
if downsampling ~= 1
%     downsampling == 2
neuront = double(neuronc.time);
neuront = neuronc.time(1:downsampling:end);
end
t = find(diff(behavtimec)<=0);
behavtimec(t+1) = behavtimec(t)+1;
pos = interp1(behavtimec,behavposc,neuront); %%
maxroix=max(behavroi(:,1));
maxroiy=max(behavroi(:,2));

maxPosRegion=[0,0,max(max(max(pos(:,1))),maxroix),max(max(max(pos(:,2))),maxroiy)];