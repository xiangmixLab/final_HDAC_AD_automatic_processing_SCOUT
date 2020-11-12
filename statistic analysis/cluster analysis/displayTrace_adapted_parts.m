function displayTrace_adapted_parts(neuron0,trialNum, group,idxTrail,colorClusters,conditionfolder,ik)
%% display the trace of each cluster
% trialNum = [1:10]; % the trails for displaying, e.g. the first ten trails
figure
optimalK = length(unique(group));
for i=1:optimalK
ha{i} =subplot(optimalK,1,i);
end
for i = 1:optimalK
    datai = [];
%     for j = 1:length(trialNum)
%         datai = [datai,neuron0.trace(:,idxTrail(:,trialNum(j)))];%the trace is resampled by edge crossing trials so it may has clippings.        
%     end
    datai=neuron0.C;
    axes(ha{i})
    %     subplot(optimalK,2,2*i-1);
    plot(1:size(datai,2),datai((group == i),:),'color',colorClusters(i,:));
%     plot(1:size(datai,2),mean(datai((group == i),:)),'k');
    title(['Num of neurons:',num2str(length(find(group==i)))],'FontSize',8)
    set(gca,'FontSize',8)
    axis tight
    if i ~= optimalK, set(gca,'Xtick',[]);end
end
set(0, 'DefaultFigureRenderer', 'painters');
saveas(gcf,[conditionfolder,'/','cluster C 1','_part',num2str(ik),'.fig'],'fig');
saveas(gcf,[conditionfolder,'/','cluster C 1','_part',num2str(ik),'.tif'],'tif');
saveas(gcf,[conditionfolder,'/','cluster C 1','_part',num2str(ik),'.eps'],'epsc');

figure
optimalK = length(unique(group));
ha = tight_subplot(optimalK,1,[.03 .03],[.05 .05],[.08 .01]);
for i = 1:optimalK
    datai = [];
%     for j = 1:length(trialNum)
%         datai = [datai,neuron0.trace(:,idxTrail(:,trialNum(j)))];
%     end
    datai=neuron0.C;
    axes(ha(i))
    %     subplot(optimalK,2,2*i-1);
    idx = find(group == i);
    [~,order] = sort(max(datai(idx,:),[],2),'ascend');
    idx = idx(order);
    for j = 1:nnz(group == i)
        increment = j*10;
        plot(1:size(datai,2),datai(idx(j),:)+increment,'color',colorClusters(i,:),'LineWidth',0.5);
        hold on
    end
%     plot(1:size(datai,2),mean(datai((group == i),:)),'k');
%     title(['Num of neurons:',num2str(length(find(group==i)))],'FontSize',8)
    set(gca,'FontSize',8)
%     ylabel(['C',num2str(i),'(n=',num2str(nnz(group == 1)),')']);
    axis tight
%     if i ~= optimalK, set(gca,'Xtick',[]);end
    axis off
end
% set(ha,'YTickLabel',['C1','(n=',num2str(nnz(group == 1)),')'],['C2','(n=',num2str(nnz(group == 1)),')'],['C3','(n=',num2str(nnz(group == 1)),')'],['C4','(n=',num2str(nnz(group == 1)),')'])
set(0, 'DefaultFigureRenderer', 'painters');
saveas(gcf,[conditionfolder,'/','cluster individual activity C','_part',num2str(ik),'.fig'],'fig');
saveas(gcf,[conditionfolder,'/','cluster individual activity C','_part',num2str(ik),'.tif'],'tif');
saveas(gcf,[conditionfolder,'/','cluster individual activity C','_part',num2str(ik),'.eps'],'epsc');

figure
optimalK = length(unique(group));
% groupCenter = zeros(optimalK,size(smoothCurve,2));
ha = tight_subplot(optimalK,1,[.03 .03],[.05 .05],[.08 .01]);
for i = 1:optimalK
    datai = [];
%     for j = 1:length(trialNum)
%         datai = [datai,neuron0.trace(:,idxTrail(:,trialNum(j)))];
%     end
    datai=neuron0.C;
    axes(ha(i))
    %     subplot(optimalK,2,2*i-1);
%     plot(1:size(datai,2),datai((group == i),:),'k');
        Q = quantile(datai((group == i),:),[0.25, 0.5, 0.75]);
%         groupCenter(i,:) = 0.25*Q(1,:)+0.5*Q(2,:)+0.25*Q(3,:);
%     plot(1:size(datai,2),groupCenter(i,:),'color',colorClusters(i,:),'LineWidth',1);
    plot(1:size(datai,2),mean(datai((group == i),:)),'color',colorClusters(i,:),'LineWidth',1);
%     title(['Num of neurons:',num2str(length(find(group==i)))],'FontSize',8)
    set(gca,'FontSize',8)
%     ylabel(['C',num2str(i)]);
    axis tight
    ylim([0 50])
    axis off
    if i ~= optimalK, set(gca,'Xtick',[]);end
end
set(0, 'DefaultFigureRenderer', 'painters');
saveas(gcf,[conditionfolder,'/','cluster average activity C','_part',num2str(ik),'.fig'],'fig');
saveas(gcf,[conditionfolder,'/','cluster average activity C','_part',num2str(ik),'.tif'],'tif');
saveas(gcf,[conditionfolder,'/','cluster average activity C','_part',num2str(ik),'.eps'],'epsc');
