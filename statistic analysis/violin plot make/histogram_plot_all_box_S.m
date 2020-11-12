%histogram plot
% foldername_hdac_ad;
% % foldernamet=foldernamead3batch;
% % foldernamet=foldernamead_FN;
% % foldernamet=foldernamehdac_virus_b1;
% % foldernamet=foldernamehdac_virus_b2;
% % basicinfo_cell;
% % foldernamet=foldernamead_sc2;
% % foldernamet=foldernamead_sc;
% 
% % foldernamet=foldernamehdac;
% foldernamet=foldernamehdac_new;

if exp==10
%     group={[2 3 9 14 22 23 19],[1 4 11 12 17 18 20]};
    group={[9 14 22 23],[11 12 20]};% delete those without baseline
    groupname={'injection_RGFP_old','injection_control_old'};
    savedir='C:\Users\exx\Desktop\HDAC paper fig and method\fig2\histogram_single_cell_allbox_S';
    conditionname={'baseline','training','test'};
    rgfp_old_cevents={};
    rgfp_old_rate={};
    rgfp_old_amp={};
    control_old_cevents={};
    control_old_rate={};
    control_old_amp={};
end
if exp==4
    group={[5 6 7 8 9]};
    groupname={'virus_control_young'};
    savedir='C:\Users\exx\Desktop\HDAC paper fig and method\fig2\histogram_single_cell_allbox_S';
    conditionname={'baseline','training','test'};
end
if exp==5
    group={[6 7 8 9]};
    groupname={'virus_control_young'};
    savedir='C:\Users\exx\Desktop\HDAC paper fig and method\fig2\histogram_single_cell_allbox_S';
    conditionname={'baseline','training','test'};
end    
if exp==12
    group={[1:11]};
    groupname={'control_inject_virus_young'};
    savedir='C:\Users\exx\Desktop\HDAC paper fig and method\fig2\histogram_single_cell_allbox_S';
    conditionname={'baseline','training','test'};
    control_young_cevents={};
    control_young_rate={};
    control_young_amp={};
end
    
% minn=1;
% maxx=length(foldernamet);

mkdir(savedir);
group1=[];
group2=[];

for i=1:3
    a01={};
    a02={};
    a03={};
    a04={};
    a05={};
     if exp==10
     struct_event_10=struct('RGFP_old',[],'Control_old',[]);
     struct_rate_10=struct('RGFP_old',[],'Control_old',[]);
     struct_amp_10=struct('RGFP_old',[],'Control_old',[]);
     struct_ampn_10=struct('RGFP_old',[],'Control_old',[]);
     end
      if exp==12
     struct_event_12=struct('Control_young',[]);
     struct_rate_12=struct('Control_young',[]);
     struct_amp_12=struct('Control_young',[]);
     struct_ampn_12=struct('Control_young',[]);
      end

for g=1:length(group)
        ct=1;
for j=group{g}
    
    if j==10&&exp==10
        continue;
    end
    conditionfilename=[foldernamet{j},'\neuron_comparingFiringRate_averageinfo_placecell_data_binsize15.xlsx'];
    [num,txt]=xlsread(conditionfilename,'comparsion_cells_allBox_S');  
    
    a01{ct,g}=num(:,3+22*(i-1));%count, obj1
%     a02(ct:ct+length(num(:,7))-1,g)=num(:,7);%count, obj2
    
%     figure;
%     a01=num(:,3*i+19*(i-1)+4);
%     a02=num(:,3*i+19*(i-1)+7);
%     histogram(a01,100);
%     hold on;
%     histogram(a02,100);
%     title(['bin time single cell', num2str(i)])
%     ylabel('cell num');
    
    a03{ct,g}=num(:,11+22*(i-1));%rate, obj1
    ct=ct+1;
end
 exname=[savedir,'\',groupname{g},' individual cell distribution all box.xlsx'];
 sname1=[conditionname{i},'_count_events'];
 sname2=[conditionname{i},'_firing_rate'];
 sname3=[conditionname{i},'_amplitude'];
 sname4=[conditionname{i},'_amplitude_corm'];
 sheetcol={'A','B','C','D','E'};

     a011=cell2mat(a01(:,g));
        xlswrite(exname,a011,sname1,sheetcol{1});
%         xlswrite(exname,a02(:,llk),sname2,sheetcol{llk});
     a031=cell2mat(a03(:,g));
        xlswrite(exname,a031,sname2,sheetcol{1});
 

if exp==10&&g==1
    rgfp_old_cevents{i,1}=a011;
    rgfp_old_rate{i,1}=a031;
end
if exp==10&&g==2
    control_old_cevents{i,1}=a011;
    control_old_rate{i,1}=a031;
end
if exp==12
    control_young_cevents{i,1}=a011;
    control_young_rate{i,1}=a031;
end
end
end
%% violin plot


%  if exp==10
%  struct_event_10.RGFP_old(:,i)=cell2mat(a01(:,1));
%  struct_event_10.Control_old(:,i)=cell2mat(a01(:,2));
%  struct_rate_10.RGFP_old(:,i)=cell2mat(a03(:,1));
%  struct_rate_10.Control_old(:,i)=cell2mat(a03(:,2));
%  struct_amp_10.RGFP_old(:,i)=cell2mat(a04(:,1));
%  struct_amp_10.Control_old(:,i)=cell2mat(a04(:,2));
%  struct_ampn_10.RGFP_old(:,i)=cell2mat(a05(:,1));
%  struct_ampn_10.Control_old(:,i)=cell2mat(a05(:,2));
%  end
for i=1:3
 if exp==12
 struct_event_12.Control_young=control_young_cevents{i,1};
 struct_event_12.Control_old=control_old_cevents{i,1};
 struct_event_12.RGFP_old=rgfp_old_cevents{i,1};
 struct_rate_12.Control_young=control_young_rate{i,1};
 struct_rate_12.Control_old=control_old_rate{i,1};
 struct_rate_12.RGFP_old=rgfp_old_rate{i,1};
    
 %% violin
     colorGroup = [200 0 0;0 0 200;0 212 212]/255;

    k01=struct_event_12.Control_young;
    k02=struct_event_12.Control_old;
    k03=struct_event_12.RGFP_old;
    max_size=max([length(k01),length(k02),length(k03)]);
    if length(k01)<max_size
        k01(length(k01)+1:max_size)=nan;
    end
    if length(k02)<max_size
        k02(length(k02)+1:max_size)=nan;
    end
    if length(k03)<max_size
        k03(length(k03)+1:max_size)=nan;
    end
    t = table([1:length(k01)]',k01,k02,k03,'VariableNames',{'cells','meas1','meas2','meas3'});
    Meas = table([1 2 3]','VariableNames',{'Measurements'});
    rm = fitrm(t,'meas1-meas3~cells','WithinDesign',Meas);
    ranovatbl = ranova(rm);
    rk=ranovatbl{1,7};% Huynh-Feldt correction
    close; 
    figure;
 h = violinplot(struct_event_12);
    
    for j = 1:length(h)
        h(j).ViolinColor = colorGroup(j,:);
    end
    xlim([0.5 length(h)+0.5])
%     set(gca,'Xtick',1:length(xlabels))
%     set(gca,'Xticklabel',xlabels,'FontSize',8);
    title(['calcium count single cell ', conditionname{i}])
    ylabel('events');
    

%     rk=ranksum(a01,a02);
    if rk<0.05
        text(1.2,max([max(k01),max(k02),max(k03)])*2/3,['sig. difference across 3 groups Huynh-Feldt corrected p=',num2str(rk)]);
    else
        text(1.2,max([max(k01),max(k02),max(k03)])*2/3,['No sig. difference across 3 groups Huynh-Feldt corrected p=',num2str(rk)]);
    end
   set(gcf,'renderer','painters');
    saveas(gcf,[savedir,'\',conditionname{i},'_countEvents_violin.eps'],'epsc');
    saveas(gcf,[savedir,'\',conditionname{i},'_countEvents_violin.tif'],'tif');
    saveas(gcf,[savedir,'\',conditionname{i},'_countEvents_violin.fig'],'fig');
    close;
    
    k01=struct_rate_12.Control_young;
    k02=struct_rate_12.Control_old;
    k03=struct_rate_12.RGFP_old;
    max_size=max([length(k01),length(k02),length(k03)]);
    if length(k01)<max_size
        k01(length(k01)+1:max_size)=nan;
    end
    if length(k02)<max_size
        k02(length(k02)+1:max_size)=nan;
    end
    if length(k03)<max_size
        k03(length(k03)+1:max_size)=nan;
    end
    t = table([1:length(k01)]',k01,k02,k03,'VariableNames',{'cells','meas1','meas2','meas3'});
    Meas = table([1 2 3]','VariableNames',{'Measurements'});
    rm = fitrm(t,'meas1-meas3~cells','WithinDesign',Meas);
    ranovatbl = ranova(rm);
    rk=ranovatbl{1,7};% Huynh-Feldt correction
    close;
    figure;
     h = violinplot(struct_rate_12);
    
    for j = 1:length(h)
        h(j).ViolinColor = colorGroup(j,:);
    end
    xlim([0.5 length(h)+0.5])
%     set(gca,'Xtick',1:length(xlabels))
%     set(gca,'Xticklabel',xlabels,'FontSize',8);
    title(['firing rate single cell ', conditionname{i}])
    ylabel('firing rate');

%     rk=ranksum(a01,a02);
    if rk<0.05
        text(1.2,max([max(k01),max(k02),max(k03)])*2/3,['sig. difference across 3 groups Huynh-Feldt corrected p=',num2str(rk)]);
    else
        text(1.2,max([max(k01),max(k02),max(k03)])*2/3,['No sig. difference across 3 groups Huynh-Feldt corrected p=',num2str(rk)]);
    end
    
    set(gcf,'renderer','painters');
    saveas(gcf,[savedir,'\',conditionname{i},'_firingRate_violin.eps'],'epsc');
    saveas(gcf,[savedir,'\',conditionname{i},'_firingRate_violin.tif'],'tif');
    saveas(gcf,[savedir,'\',conditionname{i},'_firingRate_violin.fig'],'fig');
    close;
 end
 
 
end
