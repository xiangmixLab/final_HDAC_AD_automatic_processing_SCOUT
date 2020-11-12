load('D:\AD_square_circle_results_092320\exp_info_etgAD_092320.mat');
load('D:\AD_square_circle_results_092320\manual_temporal_check.mat');

foldername=unique(destination);

%% get all neuronC
for i=1:length(foldername)
    load([foldername{i},'\','further_processed_neuron_extraction_final_result.mat']);
    neuronC_all{i}=neuron.C;
end

%% bad trace select with pervious manual deletion
bad_trace=[];
for i=1:length(foldername)
    btrace=neuronC_all{i}(del_idx{i},:);
    btrace1=[];
    for j=1:size(btrace,1)
        btrace1(j,:)=resample(btrace(j,:),5000,length(btrace(j,:)));
    end
    bad_trace=[bad_trace;btrace1];
end

%% further modify pervious deletion, keep the worst
real_del_idx=[];
ctt2=1;
for j=600:size(bad_trace,1)
        
    plot(bad_trace(j,:));
%         ylim([0 max(neuron.C(:))])
    title([num2str(j),'/',num2str(size(bad_trace,1))])
    drawnow;
    strr=input('good or bad (g/b)','s')

    if isequal(strr,'b')
        real_del_idx(ctt2)=[j];
        ctt2=ctt2+1;
    end
    clf;
end

bad_trace_inuse=bad_trace(real_del_idx,:);
% bad_trace_inuse=bad_trace;
plot(bad_trace_inuse')

%% good trace selection
good_trace_inuse=[];
for i=1:length(foldername)
    nC_good=neuronC_all{i};
    nC_good(del_idx{i},:)=[];
    gtrace1=[];
    for j=1:4
        gtrace1(j,:)=resample(nC_good(j,:),5000,length(nC_good(j,:)));
    end
    good_trace_inuse=[good_trace_inuse;gtrace1];
end

%% zscore, good and bad
% good_trace_inuse=zscore(good_trace_inuse,[],2);
% bad_trace_inuse=zscore(bad_trace_inuse,[],2);

%% feature extraction
% avg peak amp, integ amp(>0.5 max)
% good_trace_inuse=good_trace_inuse-min(good_trace_inuse(:));
% bad_trace_inuse=bad_trace_inuse-min(bad_trace_inuse(:));

% goodS=C_to_peakS(good_trace_inuse);
% goodS1=threshold_data(goodS,0.5*max(goodS,[],2));
% good_feature=[sum(goodS1,2)./sum(goodS1>0,2),sum(good_trace_inuse,2)./sum(good_trace_inuse>0,2)];
% 
% badS=C_to_peakS(bad_trace_inuse);
% badS1=threshold_data(badS,0.5*max(badS,[],2));
% bad_feature=[sum(badS1,2)./sum(badS1>0,2),sum(bad_trace_inuse,2)./sum(bad_trace_inuse>0,2)];\
good_feature=[];
bad_feature=[];
for i=1:size(good_trace_inuse,1)
    autoenc = trainAutoencoder(good_trace_inuse(i,:),'ShowProgressWindow',false,'UseGPU',true);
    good_feature(i,:)=[autoenc.EncoderWeights'];
    autoenc = trainAutoencoder(bad_trace_inuse(i,:),'ShowProgressWindow',false,'UseGPU',true);
    bad_feature(i,:)=[autoenc.EncoderWeights'];
end

%% training dat formulate
ctt=1;
XTrain={};
YTrain=[];
% for i=1:70
%     XTrain{ctt,1}=good_trace_inuse(i,:);
%     YTrain(ctt)=1;
%     ctt=ctt+1;
%     XTrain{ctt,1}=bad_trace_inuse(i,:);
%     YTrain(ctt)=2;    
%     ctt=ctt+1;
% end
for i=1:70
    XTrain{ctt,1}=good_feature(i,:);
    YTrain(ctt)=1;
    ctt=ctt+1;
    XTrain{ctt,1}=bad_feature(i,:);
    YTrain(ctt)=2;    
    ctt=ctt+1;
end
YTrain=categorical(YTrain');


%% network: LSTM
inputSize = 1;
numHiddenUnits = 1000;
numClasses = 2;

layers = [
    sequenceInputLayer(inputSize)
    bilstmLayer(numHiddenUnits,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer
    ]

maxEpochs = 1000;

options = trainingOptions('adam', ...
    'ExecutionEnvironment','cpu', ...
    'GradientThreshold',1, ...
    'MaxEpochs',maxEpochs, ...
    'SequenceLength','longest', ...
    'Shuffle','never', ...
    'Verbose',0, ...
    'Plots','training-progress');

net = trainNetwork(XTrain,YTrain,layers,options);

XTest=[good_feature(71:90,:);bad_feature(71:90,:)];
XTest=XTest(randperm(size(XTest,1)),:);
YPred=[];
score_out=[];
for i=1:size(XTest,1)
    [YPred(i)] = classify(net,XTest(i,:), 'SequenceLength','longest');
end

%% for real: load data and classify
load('D:\AD_FNB_result_101920\data_info_102920.mat');
load('D:\final_HDAC_AD_automatic_processing_SCOUT\Auto_Neuron_Removal\temporal_classification_LSTM.mat');
del_idx={};
for i=1:length(folderName)
    load([folderName{i},'\','further_processed_neuron_extraction_final_result.mat']);
    
    [YPred,score]=auto_neuron_trim_temporal(neuron.C,net);
    
    del_idx{i,1}=find(YPred==2);
end