%histogram plot
function histogram_plot_looking_at_obj(savedir,group,groupname,conditionname,foldernamet,exp)   
mkdir(savedir);

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
    [num1,txt1]=xlsread(conditionfilename,'mouselookobject_firing_count');  
    [num2,txt2]=xlsread(conditionfilename,'mouselookobject_firing_rate'); 
    [num3,txt3]=xlsread(conditionfilename,'mouselookobject_firing_amp'); 
    [num4,txt4]=xlsread(conditionfilename,'mouselookobject_firing_amp_norm'); 
    a01=[a01;num1(:,3*i+2*(i-1))];%count, obj1
    a02=[a02;num1(:,3*i+2*(i-1)+3)];%count, obj2

    
    a03=[a03;num2(:,3*i+2*(i-1))];%rate, obj1
    a04=[a04;num2(:,3*i+2*(i-1)+3)];%rate, obj2
   
    a05=[a05;num3(:,3*i+2*(i-1))];%amp, obj1
    a06=[a06;num3(:,3*i+2*(i-1)+3)];%amp, obj2
    
    a07=[a07;num4(:,3*i+2*(i-1))];%amp r, obj1
    a08=[a08;num4(:,3*i+2*(i-1)+3)];%amp r, obj2
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
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_countEvents_violin.eps'],'epsc');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_countEvents_violin.tif'],'tif');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_countEvents_violin.fig'],'fig');
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
     saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_firingRate_violin.eps'],'epsc');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_firingRate_violin.tif'],'tif');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_firingRate_violin.fig'],'fig');
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
    title(['integrated amplitude single cell ', conditionname{i}])
    ylabel('integrated Amplitude');
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
      saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_integrated Amplitude_violin.eps'],'epsc');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_integrated Amplitude_violin.tif'],'tif');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_integrated Amplitude_violin.fig'],'fig');
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
    title(['normalized integrated amplitude single cell ', conditionname{i}])
    ylabel('Normalized integrated Amplitude');
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
      saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_NormintegratedAmplitude_violin.eps'],'epsc');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_NormintegratedAmplitude_violin.tif'],'tif');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_NormintegratedAmplitude_violin.fig'],'fig');
    close
%% scatter plot
    figure;
    ylim([-100 max(max(a01),max(a02))]);
    hold on
    x1=randi([150 250],length(a01),1)*0.01;
    x2=randi([550 650],length(a02),1)*0.01;
    scatter(x1,a01,75,'r','.');
    plot([1:3],[mean(a01),mean(a01),mean(a01)],'Color','k','LineWidth',2);
    errorbar(mean(x1),mean(a01), std(a01), '-ok','lineWidth',2,'CapSize',10);
    scatter(x2,a02,75,'b','.');
    plot([5:7],[mean(a02),mean(a02),mean(a02)],'Color','k','LineWidth',2);
    errorbar(mean(x2),mean(a02), std(a02), '-ok','lineWidth',2,'CapSize',10);
    title(['calcium count single cell ', conditionname{i}])
    ylabel('Events');
    set(gcf,'renderer','painters');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_countEvents_scatter.eps'],'epsc');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_countEvents_scatter.tif'],'tif');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_countEvents_scatter.fig'],'fig');
    close;
    figure;
    ylim([-100 max(max(a03),max(a04))]);
    hold on
    x1=randi([150 250],length(a03),1)*0.01;
    x2=randi([550 650],length(a04),1)*0.01;
    scatter(x1,a03,75,'r','.');
    plot([1:3],[mean(a03),mean(a03),mean(a03)],'Color','k','LineWidth',2);
    errorbar(mean(x1),mean(a03), std(a03), '-ok','lineWidth',2,'CapSize',10);
    scatter(x2,a04,75,'b','.');
    plot([5:7],[mean(a04),mean(a04),mean(a04)],'Color','k','LineWidth',2);
    errorbar(mean(x2),mean(a04), std(a04), '-ok','lineWidth',2,'CapSize',10);
    title(['Firing rate single cell ', conditionname{i}])
    ylabel('firing rate');
    set(gcf,'renderer','painters');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_firingRate_scatter.eps'],'epsc');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_firingRate_scatter.tif'],'tif');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_firingRate_scatter.fig'],'fig');
    close;
    figure;
    ylim([-100 max(max(a05),max(a06))]);
    hold on
    x1=randi([150 250],length(a05),1)*0.01;
    x2=randi([550 650],length(a06),1)*0.01;
    scatter(x1,a05,75,'r','.');
    plot([1:3],[mean(a05),mean(a05),mean(a05)],'Color','k','LineWidth',2);
    errorbar(mean(x1),mean(a05), std(a05), '-ok','lineWidth',2,'CapSize',10);
    scatter(x2,a06,75,'b','.');
    plot([5:7],[mean(a06),mean(a06),mean(a06)],'Color','k','LineWidth',2);
    errorbar(mean(x2),mean(a06), std(a06),'-ok','lineWidth',2,'CapSize',10);
    title(['integrated Amplitude single cell ', conditionname{i}])
    ylabel('integrated Amplitude');
    set(gcf,'renderer','painters');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_integrated_Amplitude_scatter.eps'],'epsc');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_integrated_Amplitude_scatter.tif'],'tif');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_integrated_Amplitude_scatter.fig'],'fig');
    close;
    figure;
    ylim([-100 max(max(a07),max(a08))]);
    hold on
    x1=randi([150 250],length(a07),1)*0.01;
    x2=randi([550 650],length(a08),1)*0.01;
    scatter(x1,a07,75,'r','.');
    plot([1:3],[mean(a07),mean(a07),mean(a07)],'Color','k','LineWidth',2);
    errorbar(mean(x1),mean(a07), std(a07), '-ok','lineWidth',2,'CapSize',10);
    scatter(x2,a08,75,'b','.');
    plot([5:7],[mean(a08),mean(a08),mean(a08)],'Color','k','LineWidth',2);
    errorbar(mean(x2),mean(a08), std(a08), '-ok','lineWidth',2,'CapSize',10);
    title(['Normalized integrated amplitude single cell ', conditionname{i}])
    ylabel('Normalized integrated amplitude');
    set(gcf,'renderer','painters');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_Normintegrated_Amplitude_scatter.eps'],'epsc');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_Normintegrated_Amplitude_scatter.tif'],'tif');
    saveas(gcf,[savedir,'\',conditionname{i},'_',groupname{g},'_Normintegrated_Amplitude_scatter.fig'],'fig');
    close;
exname=[savedir,'\',groupname{g},' look at obj individual cell distribution.xlsx'];
        xlswrite(exname,a01,[conditionname{i},'_count_events'],'A');
        xlswrite(exname,a02,[conditionname{i},'_count_events'],'B');
        xlswrite(exname,a03,[conditionname{i},'_firing_rate'],'A');
        xlswrite(exname,a04,[conditionname{i},'_firing_rate'],'B');
        xlswrite(exname,a05,[conditionname{i},'_integrated_amplitude'],'A');
        xlswrite(exname,a06,[conditionname{i},'_integrated_amplitude'],'B');
        xlswrite(exname,a07,[conditionname{i},'_int_amplitude_norm'],'A');
        xlswrite(exname,a08,[conditionname{i},'_int_amplitude_norm'],'B');        
end
 
end
