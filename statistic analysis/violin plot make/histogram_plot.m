%histogram plot
function histogram_plot(savedir,group,groupname,conditionname,foldernamet,exp,temp)    
% minn=1;
% maxx=length(foldernamet);

mkdir(savedir);
group1=[];
group2=[];

for i=2:3
    a01=[];
    a02=[];
    a03=[];
    a04=[];
    a05=[];
    a06=[];
    a07=[];
    a08=[];
for g=1:length(group)
for j=group{g}
    
    if j==10&&exp==10
        continue;
    end
    
    conditionfilename=[foldernamet{j},'\neuron_comparingFiringRate_averageinfo_placecell_data_binsize15.xlsx'];
    if isequal(temp,'C')
    [num,txt]=xlsread(conditionfilename,'comparsion_objects_cells');  
    end
    if isequal(temp,'S')
    [num,txt]=xlsread(conditionfilename,'comparsion_objects_cells_spike');  
    end
    
    
    a01=[a01;num(:,3*i+19*(i-1))];%count, obj1
    a02=[a02;num(:,3*i+19*(i-1)+3)];%count, obj2
    
%     figure;
%     a01=num(:,3*i+19*(i-1)+4);
%     a02=num(:,3*i+19*(i-1)+7);
%     histogram(a01,100);
%     hold on;
%     histogram(a02,100);
%     title(['bin time single cell', num2str(i)])
%     ylabel('cell num');
    
    a03=[a03;num(:,3*i+19*(i-1)+8)];%rate, obj1
    a04=[a04;num(:,3*i+19*(i-1)+11)];%rate, obj2
   
    a05=[a05;num(:,3*i+19*(i-1)+12)];%amp, obj1
    a06=[a06;num(:,3*i+19*(i-1)+15)];%amp, obj2
    
    a07=[a07;num(:,3*i+19*(i-1)+16)];%amp r, obj1
    a08=[a08;num(:,3*i+19*(i-1)+19)];%amp r, obj2
end
%% violin plot
    colorGroup = [200 0 0;0 0 200;212 212 212]/255;
    xlabels={'obj1','obj2'};
    figure;
%     violin([a01,a02],'xlabel',{'obj1','obj2'},'facecolor',[1 0 0;0 0 1],'edgecolor','k','medc',[]);
    h = violinplot([a01,a02]);
    
        for j = 1:length(h)
            h(j).ViolinColor = colorGroup(j,:);
        end
    xlim([0.5 length(h)+0.5])
    set(gca,'Xtick',1:length(xlabels))
    set(gca,'Xticklabel',xlabels,'FontSize',8);
    title(['calcium count single cell ', conditionname{i}])
    ylabel('events');
    t = table([1:length(a01)]',a01,a02,'VariableNames',{'objs','meas1','meas2'});
    Meas = table([1 2]','VariableNames',{'Measurements'});
    rm = fitrm(t,'meas1-meas2~objs','WithinDesign',Meas);
    ranovatbl = ranova(rm);
    rk=ranovatbl{1,7};% Huynh-Feldt correction

    if rk<0.05
        text(1.2,max(max(a01),max(a02))*2/3,['sig. Huynh-Feldt corrected p=',num2str(rk)]);
    else
        text(1.2,max(max(a01),max(a02))*2/3,['No sig. Huynh-Feldt corrected p=',num2str(rk)]);
    end
    set(gcf,'renderer','painters');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_',temp,'_countEvents_violin.eps'],'epsc');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_',temp,'_countEvents_violin.tif'],'tif');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_',temp,'_countEvents_violin.fig'],'fig');
    close;
    figure;
%     violin([a03,a04],'xlabel',{'obj1','obj2'},'facecolor',[1 0 0;0 0 1],'edgecolor','k','medc',[]);
    h = violinplot([a03,a04]);
        for j = 1:length(h)
            h(j).ViolinColor = colorGroup(j,:);
        end
    xlim([0.5 length(h)+0.5])
    set(gca,'Xtick',1:length(xlabels))
    set(gca,'Xticklabel',xlabels,'FontSize',8);
    title(['firing rate single cell ', conditionname{i}])
    ylabel('firing rate');
    t = table([1:length(a03)]',a03,a04,'VariableNames',{'objs','meas1','meas2'});
    Meas = table([1 2]','VariableNames',{'Measurements'});
    rm = fitrm(t,'meas1-meas2~objs','WithinDesign',Meas);
    ranovatbl = ranova(rm);
    rk=ranovatbl{1,7};% Huynh-Feldt correction

    if rk<0.05
        text(1.2,max(max(a03),max(a04))*2/3,['sig. Huynh-Feldt corrected p=',num2str(rk)]);
    else
        text(1.2,max(max(a03),max(a04))*2/3,['No sig. Huynh-Feldt corrected p=',num2str(rk)]);
    end
    set(gcf,'renderer','painters');
     saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_',temp,'_firingRate_violin.eps'],'epsc');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_',temp,'_firingRate_violin.tif'],'tif');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_',temp,'_firingRate_violin.fig'],'fig');
    close
    figure;
%     violin([a05,a06],'xlabel',{'obj1','obj2'},'facecolor',[1 0 0;0 0 1],'edgecolor','k','medc',[]);
    h = violinplot([a05,a06]);
        for j = 1:length(h)
            h(j).ViolinColor = colorGroup(j,:);
        end
    xlim([0.5 length(h)+0.5])
    set(gca,'Xtick',1:length(xlabels))
    set(gca,'Xticklabel',xlabels,'FontSize',8);
    title(['amplitude single cell ', conditionname{i}])
    ylabel('Amplitude');
     t = table([1:length(a05)]',a05,a06,'VariableNames',{'objs','meas1','meas2'});
    Meas = table([1 2]','VariableNames',{'Measurements'});
    rm = fitrm(t,'meas1-meas2~objs','WithinDesign',Meas);
    ranovatbl = ranova(rm);
    rk=ranovatbl{1,7};% Huynh-Feldt correction

    if rk<0.05
        text(1.2,max(max(a05),max(a06))*2/3,['sig. Huynh-Feldt corrected p=',num2str(rk)]);
    else
        text(1.2,max(max(a05),max(a06))*2/3,['No sig. Huynh-Feldt corrected p=',num2str(rk)]);
    end

    set(gcf,'renderer','painters');
      saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_',temp,'_Amplitude_violin.eps'],'epsc');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_',temp,'_Amplitude_violin.tif'],'tif');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_',temp,'_Amplitude_violin.fig'],'fig');
    close
    figure;
%     violin([a07,a08],'xlabel',{'obj1','obj2'},'facecolor',[1 0 0;0 0 1],'edgecolor','k','medc',[]);
    h = violinplot([a07,a08]);
        for j = 1:length(h)
            h(j).ViolinColor = colorGroup(j,:);
        end
    xlim([0.5 length(h)+0.5])
    set(gca,'Xtick',1:length(xlabels))
    set(gca,'Xticklabel',xlabels,'FontSize',8);
    title(['normalized amplitude single cell ', conditionname{i}])
    ylabel('Normalized Amplitude');
    t = table([1:length(a07)]',a07,a08,'VariableNames',{'objs','meas1','meas2'});
    Meas = table([1 2]','VariableNames',{'Measurements'});
    rm = fitrm(t,'meas1-meas2~objs','WithinDesign',Meas);
    ranovatbl = ranova(rm);
    rk=ranovatbl{1,7};% Huynh-Feldt correction

    if rk<0.05
        text(1.2,max(max(a07),max(a08))*2/3,['sig. Huynh-Feldt corrected p=',num2str(rk)]);
    else
        text(1.2,max(max(a07),max(a08))*2/3,['No sig. Huynh-Feldt corrected p=',num2str(rk)]);
    end
    set(gcf,'renderer','painters');
      saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_',temp,'_NormAmplitude_violin.eps'],'epsc');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_',temp,'_NormAmplitude_violin.tif'],'tif');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_',temp,'_NormAmplitude_violin.fig'],'fig');
    close
%% scatter plot
    figure;
    ylim([-100 max(max(a01),max(a02))]);
    hold on
    x1=randi([150 250],length(a01),1)*0.01;
    x2=randi([550 650],length(a02),1)*0.01;
    scatter(x1,a01,75,'r','.');
    plot([1:3],[mean(a01),mean(a01),mean(a01)],'Color','k','LineWidth',2);
    errorbar(mean(x1),mean(a01), std(a01)/length(a01)^0.5, '-ok','lineWidth',2,'CapSize',10);
    scatter(x2,a02,75,'b','.');
    plot([5:7],[mean(a02),mean(a02),mean(a02)],'Color','k','LineWidth',2);
    errorbar(mean(x2),mean(a02), std(a02)/length(a02)^0.5, '-ok','lineWidth',2,'CapSize',10);
    title(['calcium count single cell ', conditionname{i}])
    ylabel('Events');
    set(gcf,'renderer','painters');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_',temp,'_countEvents_scatter.eps'],'epsc');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_',temp,'_countEvents_scatter.tif'],'tif');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_',temp,'_countEvents_scatter.fig'],'fig');
    close;
    figure;
    ylim([-100 max(max(a03),max(a04))]);
    hold on
    x1=randi([150 250],length(a03),1)*0.01;
    x2=randi([550 650],length(a04),1)*0.01;
    scatter(x1,a03,75,'r','.');
    plot([1:3],[mean(a03),mean(a03),mean(a03)],'Color','k','LineWidth',2);
    errorbar(mean(x1),mean(a03), std(a03)/length(a03)^0.5, '-ok','lineWidth',2,'CapSize',10);
    scatter(x2,a04,75,'b','.');
    plot([5:7],[mean(a04),mean(a04),mean(a04)],'Color','k','LineWidth',2);
    errorbar(mean(x2),mean(a04), std(a04)/length(a04)^0.5, '-ok','lineWidth',2,'CapSize',10);
    title(['Firing rate single cell ', conditionname{i}])
    ylabel('firing rate');
    set(gcf,'renderer','painters');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_',temp,'_firingRate_scatter.eps'],'epsc');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_',temp,'_firingRate_scatter.tif'],'tif');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_',temp,'_firingRate_scatter.fig'],'fig');
    close;
    figure;
    ylim([-100 max(max(a05),max(a06))]);
    hold on
    x1=randi([150 250],length(a05),1)*0.01;
    x2=randi([550 650],length(a06),1)*0.01;
    scatter(x1,a05,75,'r','.');
    plot([1:3],[mean(a05),mean(a05),mean(a05)],'Color','k','LineWidth',2);
    errorbar(mean(x1),mean(a05), std(a05)/length(a05)^0.5, '-ok','lineWidth',2,'CapSize',10);
    scatter(x2,a06,75,'b','.');
    plot([5:7],[mean(a06),mean(a06),mean(a06)],'Color','k','LineWidth',2);
    errorbar(mean(x2),mean(a06), std(a06)/length(a06)^0.5,'-ok','lineWidth',2,'CapSize',10);
    title(['Amplitude single cell ', conditionname{i}])
    ylabel('Amplitude');
    set(gcf,'renderer','painters');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_',temp,'_Amplitude_scatter.eps'],'epsc');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_',temp,'_Amplitude_scatter.tif'],'tif');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_',temp,'_Amplitude_scatter.fig'],'fig');
    close;
    figure;
    ylim([-100 max(max(a07),max(a08))]);
    hold on
    x1=randi([150 250],length(a07),1)*0.01;
    x2=randi([550 650],length(a08),1)*0.01;
    scatter(x1,a07,75,'r','.');
    plot([1:3],[mean(a07),mean(a07),mean(a07)],'Color','k','LineWidth',2);
    errorbar(mean(x1),mean(a07), std(a07)/length(a07)^0.5, '-ok','lineWidth',2,'CapSize',10);
    scatter(x2,a08,75,'b','.');
    plot([5:7],[mean(a08),mean(a08),mean(a08)],'Color','k','LineWidth',2);
    errorbar(mean(x2),mean(a08), std(a08)/length(a08)^0.5, '-ok','lineWidth',2,'CapSize',10);
    title(['Normalized amplitude single cell ', conditionname{i}])
    ylabel('Normalized amplitude');
    set(gcf,'renderer','painters');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_',temp,'_NormAmplitude_scatter.eps'],'epsc');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_',temp,'_NormAmplitude_scatter.tif'],'tif');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_',temp,'_NormAmplitude_scatter.fig'],'fig');
    close;
    %% scatter plot normalization
%     a01=a01*1/max(a01(:));
%     a02=a02*1/max(a02(:));
%     a03=a03*1/max(a03(:));
%     a04=a04*1/max(a04(:));
%     a05=a05*1/max(a05(:));
%     a06=a06*1/max(a06(:));
%     a07=a07*1/max(a07(:));
%     a08=a08*1/max(a08(:));
%     
%     figure;
%     ylim([-1 max(max(a01),max(a02))]);
%     hold on
%     x1=randi([150 250],length(a01),1)*0.01;
%     x2=randi([550 650],length(a02),1)*0.01;
%     scatter(x1,a01,75,'r','.');
%     plot([1:3],[mean(a01),mean(a01),mean(a01)],'Color','k','LineWidth',2);
%     errorbar(mean(x1),mean(a01), std(a01), '-ok','lineWidth',2,'CapSize',10);
%     scatter(x2,a02,75,'b','.');
%     plot([5:7],[mean(a02),mean(a02),mean(a02)],'Color','k','LineWidth',2);
%     errorbar(mean(x2),mean(a02), std(a02), '-ok','lineWidth',2,'CapSize',10);
%     title(['calcium count single cell ', conditionname{i}])
%     ylabel('Event');
%     set(gcf,'renderer','painters');
%     saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_countEvents_scatter_normalized.eps'],'epsc');
%     saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_countEvents_scatter_normalized.tif'],'tif');
%     saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_countEvents_scatter_normalized.fig'],'fig');
%     close;
%     figure;
%     ylim([-1 max(max(a03),max(a04))]);
%     hold on
%     x1=randi([150 250],length(a03),1)*0.01;
%     x2=randi([550 650],length(a04),1)*0.01;    scatter(x1,a03,75,'r','.');
%     plot([1:3],[mean(a03),mean(a03),mean(a03)],'Color','k','LineWidth',2);
%     errorbar(mean(x1),mean(a03), std(a03), '-ok','lineWidth',2,'CapSize',10);
%     scatter(x2,a04,75,'b','.');
%     plot([5:7],[mean(a04),mean(a04),mean(a04)],'Color','k','LineWidth',2);
%     errorbar(mean(x2),mean(a04), std(a04), '-ok','lineWidth',2,'CapSize',10);
%     title(['Firing rate single cell ', conditionname{i}])
%     ylabel('Firing rate');
%     set(gcf,'renderer','painters');
%     saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_firingRate_scatter_normalized.eps'],'epsc');
%     saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_firingRate_scatter_normalized.tif'],'tif');
%     saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_firingRate_scatter_normalized.fig'],'fig');
%     close;
%     figure;
%     ylim([-1 max(max(a05),max(a06))]);
%     hold on
%     x1=randi([150 250],length(a05),1)*0.01;
%     x2=randi([550 650],length(a06),1)*0.01;
%     scatter(x1,a05,75,'r','.');
%     plot([1:3],[mean(a05),mean(a05),mean(a05)],'Color','k','LineWidth',2);
%     errorbar(mean(x1),mean(a05), std(a05), '-ok','lineWidth',2,'CapSize',10);
%     scatter(x2,a06,75,'b','.');
%     plot([5:7],[mean(a06),mean(a06),mean(a06)],'Color','k','LineWidth',2);
%     errorbar(mean(x2),mean(a06), std(a06),'-ok','lineWidth',2,'CapSize',10);
%     title(['Amplitude single cell ', conditionname{i}])
%     ylabel('Amplitude');
%     set(gcf,'renderer','painters');
%     saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_Amplitude_scatter_normalized.eps'],'epsc');
%     saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_Amplitude_scatter_normalized.tif'],'tif');
%     saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_Amplitude_scatter_normalized.fig'],'fig');
%     close;
%     figure;
%     ylim([-1 max(max(a07),max(a08))]);
%     hold on
%     x1=randi([150 250],length(a07),1)*0.01;
%     x2=randi([550 650],length(a08),1)*0.01;
%     scatter(x1,a07,75,'r','.');
%     plot([1:3],[mean(a07),mean(a07),mean(a07)],'Color','k','LineWidth',2);
%     errorbar(mean(x1),mean(a07), std(a07), '-ok','lineWidth',2,'CapSize',10);
%     scatter(x2,a08,75,'b','.');
%     plot([5:7],[mean(a08),mean(a08),mean(a08)],'Color','k','LineWidth',2);
%     errorbar(mean(x2),mean(a08), std(a08), '-ok','lineWidth',2,'CapSize',10);
%     title(['Normalized amplitude single cell ', conditionname{i}])
%     ylabel('Normalized amplitude');
%     set(gcf,'renderer','painters');
%     saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_NormAmplitude_scatter_normalized.eps'],'epsc');
%     saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_NormAmplitude_scatter_normalized.tif'],'tif');
%     saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_NormAmplitude_scatter_normalized.fig'],'fig');
%     close;
 exname=[savedir,'\',groupname{g},'_',temp,' individual cell distribution.xlsx'];
 sname1=[conditionname{i},'_count_events'];
 sname2=[conditionname{i},'_firing_rate'];
 sname3=[conditionname{i},'_amplitude'];
 sname4=[conditionname{i},'_amplitude_corm'];
        xlswrite(exname,a01,sname1,'A');
        xlswrite(exname,a02,sname1,'B');
        xlswrite(exname,a03,sname2,'A');
        xlswrite(exname,a04,sname2,'B');
        xlswrite(exname,a05,sname3,'A');
        xlswrite(exname,a06,sname3,'B');
        xlswrite(exname,a07,sname4,'A');
        xlswrite(exname,a08,sname4,'B');  
end
      
end
