function CM = consensusKmeans_adapted_multigroupCM(neuron0,threshCluster,K,N,time1,Fs)
%% performing clustering using kmeans+consensus clustering method
% using neuron.trace
% K = 5; % initial guess of the number of clusters
% N = 1000; 
% n = size(idxLRi,2)+size(idxRLi,2);
rng default  % For reproducibility
% idxTrail = [idxLRi,idxRLi];
% idxTrail = logical(idxTrail);
% idxTrail=ones(size(neuron0.trace,2),size(neuron0.trace,1));
% n=size(idxTrail,2);
CM = zeros(size(neuron0.C,1)); 
options = statset('UseParallel',1);
for i = 1:N
%     trialNum = randperm(n,1);
    oriLeng=size(neuron0.C,2);
    datai = neuron0.C(:,logical(randi([0,1],1,size(neuron0.C,2))));
    datai = resample(datai',oriLeng,size(datai,2))';
%     datai = neuron0.C;
%     if time1(3)==0
%         time_lag=Fs*randi([time1(1) time1(2)],size(neuron0.C,2),1);% sample rate: 15Hz, 10s: 150 points, interval:1/15s
%     else
%         tlag=randi([time1(1) time1(2)]);
%         time_lag=Fs*randi([tlag tlag],size(neuron0.C,2),1);% sample rate: 15Hz, 10s: 150 points, interval:1/15s
%     end
% 
%     datai=time_lag_rotation(datai,time_lag);
%     datai = time_lag_rotation(datai,Fs*randi(time1,size(neuron0.C,2),1));
    idxD = find(max(datai,[],2) < threshCluster);
%     idxD = [];
    idxC = setdiff(1:size(datai,1),idxD);
    datai(idxD,:) = [];groupD = [idxD,(K+1)*ones(length(idxD),1)];
    try
    group = kmeans(datai,K,'Distance','correlation','rep',10,'disp','final','Options',options);
    groupC = [idxC(:),group];
    group = [groupC; groupD];
    [~,idx] = sort(group(:,1)); group = group(idx,2);
    for k = 1:length(unique(group))
        comb = nchoosek(find(group == k),2);
        if length(comb) == 1
            continue;
        end
        linearInd = sub2ind(size(CM), comb(:,1),comb(:,2));
        CM(linearInd) = CM(linearInd) + 1;% if these cells are in same group, similarity +1
    end
    catch
        continue;
    end
end
CM = max(CM,CM')/N;

% cgo = clustergram(CM,'Standardize',3,'Linkage','complete');
% set(cgo,'Colormap',redbluecmap);