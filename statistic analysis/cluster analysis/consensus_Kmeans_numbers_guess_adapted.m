function optimalK = consensus_Kmeans_numbers_guess_adapted(neuron0,threshCluster,N,Klist,time1,Fs)
%% Calinski-Harabasz and bootstrap method to determine best cluster numbers for kmean
% using neuron.trace
% K = 5; % initial guess of the number of clusters
% N = 1000; 
% n = size(idxLRi,2)+size(idxRLi,2);
rng default  % For reproducibility
% idxTrail = [idxLRi,idxRLi];
% idxTrail = logical(idxTrail);
% idxTrail=ones(size(neuron0.trace,2),size(neuron0.trace,1));
% n=size(idxTrail,2);
% optimalK_m=zeros(N,1);
% for i = 1:N
% %     trialNum = randperm(n,1);
% %       datai = neuron0.C(:,logical(randi([0,1],1,size(neuron0.C,2))));
% 
%     datai = neuron0.C;
%     if time1(3)==0
%         time_lag=Fs*randi([time1(1) time1(2)],size(neuron0.C,2),1);% sample rate: 15Hz, 10s: 150 points, interval:1/15s
%     else
%         tlag=randi([time1(1) time1(2)]);
%         time_lag=Fs*randi([tlag tlag],size(neuron0.C,2),1);% sample rate: 15Hz, 10s: 150 points, interval:1/15s
%     end
% 
%     datai=time_lag_rotation(datai,time_lag);
%     idxD = find(max(datai,[],2) < threshCluster);
% %     idxD = [];
%     datai(idxD,:) = [];
%     try
%     eva = evalclusters(datai,'kmeans','CalinskiHarabasz','KList',Klist);
%     optimalK_m(i)=eva.OptimalK;
% % [ratio,maxIndex]=within_across_cluster_ratio_cal(datai,[1:size(datai,1)]);        
% %         optimalK_m(i)=Klist(maxIndex);
%     catch
%         continue;
%     end
% end
% optimalK=ceil(mean(optimalK_m));
% datai = neuron0.C;
% [ratio,maxIndex]=within_across_cluster_ratio_cal(datai,[1:size(datai,1)-1]);
% eva = evalclusters(datai,'kmeans','CalinskiHarabasz','KList',[1:size(datai,1)-1]);
% cv=eva.CriterionValues;
% 
% yyaxis left; plot(ratio);ylabel('ratio');hold on; yyaxis right;plot(cv);ylabel('CH score');title('within-across cluster ratio');xlabel('cluster number');
% 
%% test: which method is valid
% o1=[];
% o2=[];
% tic
% for i=2:size(datai,1)-1
% [~,maxIndex]=within_across_cluster_ratio_cal(datai,[2:i]);
% o1(i)=Klist(maxIndex);
% eva = evalclusters(datai,'kmeans','CalinskiHarabasz','KList',[2:i]);
% o2(i)=eva.OptimalK;
% end
% toc
% plot(o1);hold on;plot(o2);title('compare cluster number determination');legend;
% save(gcf,[pwd,'\','compare cluster number determination.tif']);
% close;

%% 03282019 restart determine cluster num with gap statistic
tic;
i=1;
% for i = 1:1
    datai = neuron0.C(:,logical(randi([0,1],1,size(neuron0.C,2))));
    if N==1
        datai=neuron0.C;
    end
    eva = evalclusters(datai','kmeans','gap','KList',Klist,'Distance','correlation');
    optimalK_m(i)=eva.OptimalK;
% end
disp('cluster number determine finished');
toc;
optimalK=ceil(mean(optimalK_m));