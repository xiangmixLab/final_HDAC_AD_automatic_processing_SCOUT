function violin_plot_with_sig(datasett,groupname,savedir,conditionname,testname,idd,ylimrange)    

colorGroup = distinguishable_colors(500);
VNames={'cells'};
varTypes = {};
max_size_all=[];
for i=1:length(datasett)
    max_size_all(i)=length(datasett{i});
    VNames{i+1}=groupname{i};
    varTypes{i} = 'double';
end
max_size=max(max_size_all);

sz=[length(datasett{1}) length(datasett)];
% t = table('Size',sz,'VariableTypes',varTypes,'VariableNames',VNames);
t={};
max_v_all=0;
for i=1:length(datasett)
    max_v_all(i)=max(datasett{i});
    if length(datasett{i})<max_size
        datasett{i}(length(datasett{i})+1:max_size)=nan;        
    end
    for kl=1:length(datasett{i})
        t{kl,1}=kl;
        t{kl,i+1}=datasett{i}(kl);
    end
end
t=cell2table(t);
t.Properties.VariableNames=VNames;

Meas = table([1:length(datasett)]','VariableNames',{'Measurements'});
rm = fitrm(t,[groupname{1},'-',groupname{length(groupname)},'~','cells'],'WithinDesign',Meas);
ranovatbl = ranova(rm);
rk=ranovatbl{1,7};% Huynh-Feldt correction
close; 

figure;
set(gcf,'position',[0 0 1900 1000])
h = violinplot(t(:,2:end));

for j = 1:length(h)
    h(j).ViolinColor = colorGroup(j,:);
end
xlim([0.5 length(h)+0.5])
%     set(gca,'Xtick',1:length(xlabels))
%     set(gca,'Xticklabel',xlabels,'FontSize',8);
title([testname,' count single cell ', conditionname{idd}])
ylabel('events');
ylim([ylimrange])

%     rk=ranksum(a01,a02);
if rk<0.05
    text(1.2,max(max_v_all)*2/3,['sig. difference across 3 groups Huynh-Feldt corrected p=',num2str(rk)]);
else
    text(1.2,max(max_v_all)*2/3,['No sig. difference across 3 groups Huynh-Feldt corrected p=',num2str(rk)]);
end
set(gcf,'renderer','painters');
saveas(gcf,[savedir,'\',conditionname{idd},'_',testname,'_violin.eps'],'epsc');
saveas(gcf,[savedir,'\',conditionname{idd},'_',testname,'_violin.tif'],'tif');
saveas(gcf,[savedir,'\',conditionname{idd},'_',testname,'_violin.fig'],'fig');
close;