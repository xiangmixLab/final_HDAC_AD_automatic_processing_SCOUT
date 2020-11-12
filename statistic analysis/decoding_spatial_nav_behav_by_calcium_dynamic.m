%% decoding spatial position with calcium dynamic
% gaussian fitting neuron.S, different window length, find best window
% fitcnb
%% 1: load data
load('D:\Yanjun_nn_revision_circle_square\M3424F\neuronIndividuals_new.mat');
load('D:\Yanjun_nn_revision_circle_square\M3424F\circle_results\current_condition_behav.mat');
load('D:\Yanjun_nn_revision_circle_square\M3424F\thresh_and_ROI.mat');
cond=2; % condition circle
binsize=15;
%% special: clustering and generate cluster trace

% [group_model,CM,Z,cophList,cophList_adjusted]=cluster_determine_by_suoqin_NMF_firstPeakCoph(neuronIndividuals_new{cond},100,10,[]);
% ntime=neuronIndividuals_new{cond}.time;
% ntime1=ntime(1:2:end);
% ntime1=resample(ntime1,size(neuronIndividuals_new{cond}.S,2),length(ntime1));
% [place_cells] = permutingSpike_adapt_simple_011720(neuronIndividuals_new{cond}.S,ntime1,behavpos,behavtime,maxbehavROI,thresh,0.1,1000,binsize,'spk',10)
% gp=place_cells;
% nC=neuronIndividuals_new{cond}.C;
% u_group=unique(gp);
% nC_clust=[];
% for i=1:length(u_group)
%     nC_clust(i,:)=mean(nC(gp==u_group(i),:),1);
% end
% 
% ntemp.C=nC_clust;
% ntemp.S=C_to_peakS(nC_clust);
% ntemp.time=neuronIndividuals_new{cond}.time;
% ntemp.A=neuronIndividuals_new{cond}.A;
% thresh=3*std(ntemp.C,[],2);

ntemp=neuronIndividuals_new{cond}.copy;
thresh=3*std(ntemp.C,[],2);

%% 2: tuning curve (map) calculation to cells   
%% 3: position estimate by Bayesian method
y_max_binIdx=[];
y_max_binIdx=calcium_spatial_bayesian_decoding(ntemp,behavpos,behavtime,maxbehavROI,binsize,thresh);

%% 4 compare with real trajectory
%% 5 criticia for decodign accuracy: average distance

real_behav=binarize_behavpos(behavpos,binsize,maxbehavROI);
[real_decode_error,yup,rb1]=decoding_error_estimate(y_max_binIdx,real_behav);
y1=smoothdata(yup,'SmoothingFactor',0.1); 
r1=smoothdata(rb1,'SmoothingFactor',0.1); 
plot(r1(:,1),r1(:,2));hold on;
plot(y1(:,1),y1(:,2));

for i=1:size(r1,1)
    plot(r1(1:i,1),r1(1:i,2));hold on;
    plot(y1(1:i,1),y1(1:i,2));hold on;
    drawnow;
    clf
end
%% 6 virtual place cells
cond=2;
binsize=10;
load('D:\Yanjun_nn_revision_circle_square\M3424F\circle_results\current_condition_behav.mat');
load('D:\Yanjun_nn_revision_circle_square\M3424F\thresh_and_ROI.mat');

load('C:\Users\exx\Desktop\HDAC paper fig and method\SFN2019\SFN2019 fig\virtual_pc_exp.mat')
thresh=zeros(size(ntemp.C,1),1);

y_max_binIdx_all=calcium_spatial_bayesian_decoding(ntemp,behavpos,behavtime,maxbehavROI,binsize,thresh);

real_behav=binarize_behavpos(behavpos,binsize,maxbehavROI);
real_decode_error={};
y_max_binIdx_up_res={};
real_behav1={};

[real_decode_error{1},y_max_binIdx_up_res{1},real_behav1{1}]=decoding_error_estimate(y_max_binIdx_all,real_behav);


y1=smoothdata(y_max_binIdx_up_res{1},'SmoothingFactor',0.05); 
r1=smoothdata(real_behav1{1},'SmoothingFactor',0.05); 
plot(r1(:,1),r1(:,2));hold on;
plot(y1(:,1),y1(:,2));

%% 7: virtual place cells