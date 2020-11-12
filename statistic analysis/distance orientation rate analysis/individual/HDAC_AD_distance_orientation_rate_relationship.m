function HDAC_AD_distance_orientation_rate_relationship(neuron,headorientationcell,behavpos,behavtime,in_use_objects,exp,conditionfolder,i,ikk)

ifMouseHeadToObj=headorientationcell.if_mouse_head_toward_object;
nC=[];
nS=[];
% unique_obj_current=unique_obj_name_map(:,i);
for idor0=1:size(neuron.C,1)
    nC(idor0,:) = interp1(neuron.time,neuron.C(idor0,:),behavtime); %%
    nS(idor0,:) = interp1(neuron.time,neuron.S(idor0,:),behavtime); %%
    nC(idor0,:) = nC(idor0,:).*double(nC(idor0,:)>max(nC(idor0,:))*0.1);
    nS(idor0,:) = nS(idor0,:).*double(nS(idor0,:)>max(nS(idor0,:))*0.1);
end

distance_to_obj=[];
for idor=1:length(in_use_objects)
    posObjects=in_use_objects{idor};
    posObjects(:,2)=max(max(behavpos(:,2)))-posObjects(:,2);
    distance_to_obj(:,idor)=sum((repmat(posObjects,length(ifMouseHeadToObj),1)-behavpos).^2,2).^0.5;
end

distance_orientation_rate_relationship_obj={};

leng_all_obj=[];
max_all_obj=[];

for idor2=1:length(in_use_objects)
    d_o_result=[];
    distance_to_obj_c=distance_to_obj(:,idor2);
    ifMouseHeadToObj_c=ifMouseHeadToObj(:,idor2);
    hh=histogram(distance_to_obj_c,100);
    binEdge=hh.BinEdges;
    close;
    
    nCa_c=[];% C amp
    nCc_c=[];% C count
    nS_c=[];
    nCa_cn=[];% C amp
    nCc_cn=[];% C count
    nS_cn=[];    
    for idor4=1:size(nC,1)
%         nCa_c(idor4,:)=nC(idor4,:)'.*ifMouseHeadToObj_c;
%         nCc_c(idor4,:)=double(nC(idor4,:)>0)'.*ifMouseHeadToObj_c;
%         nS_c(idor4,:)=double((nS(idor4,:)'.*ifMouseHeadToObj_c)>0);
        nCa_c(idor4,:)=nC(idor4,:)';% now we don't care about whether look/not look at obj
        nCc_c(idor4,:)=double(nC(idor4,:)>0)';
        nS_c(idor4,:)=double((nS(idor4,:)')>0);
        nCa_cn(idor4,:)=nC(idor4,:)'.*(~ifMouseHeadToObj_c);
        nCc_cn(idor4,:)=double(nC(idor4,:)>0)'.*(~ifMouseHeadToObj_c);
        nS_cn(idor4,:)=double((nS(idor4,:)'.*(~ifMouseHeadToObj_c))>0);        
    end
    
    for idor3=1:length(binEdge)-1      
        idxx=double(distance_to_obj_c>binEdge(idor3)).*double(distance_to_obj_c<=binEdge(idor3+1));
        nCa_c_bin_mean=mean(sum(nCa_c(:,logical(idxx)),2));
        nCa_c_bin_max=max(sum(nCa_c(:,logical(idxx)),2));
        nCa_c_bin_min=min(sum(nCa_c(:,logical(idxx)),2));
        nCc_c_bin_mean=mean(sum(nCc_c(:,logical(idxx)),2)/sum(logical(idxx)>0));% change count to rate
        nCc_c_bin_max=max(sum(nCc_c(:,logical(idxx)),2)/sum(logical(idxx)>0));
        nCc_c_bin_min=min(sum(nCc_c(:,logical(idxx)),2)/sum(logical(idxx)>0));       
        nCc_ce_bin_mean=mean(sum(nCc_c(:,logical(idxx)),2));% pure count
        nCc_ce_bin_max=max(sum(nCc_c(:,logical(idxx)),2));
        nCc_ce_bin_min=min(sum(nCc_c(:,logical(idxx)),2));
        nS_c_bin_mean=mean(sum(nS_c(:,logical(idxx)),2)/sum(logical(idxx)>0));% change count to rate
        nS_c_bin_max=max(sum(nS_c(:,logical(idxx)),2)/sum(logical(idxx)>0));
        nS_c_bin_min=min(sum(nS_c(:,logical(idxx)),2)/sum(logical(idxx)>0));
        nS_ce_bin_mean=mean(sum(nS_c(:,logical(idxx)),2));% pure count
        nS_ce_bin_max=max(sum(nS_c(:,logical(idxx)),2));
        nS_ce_bin_min=min(sum(nS_c(:,logical(idxx)),2));
        nCa_cn_bin_mean=mean(mean(nCa_cn(:,logical(idxx)),2));
        nCa_cn_bin_max=max(mean(nCa_cn(:,logical(idxx)),2));
        nCa_cn_bin_min=min(mean(nCa_cn(:,logical(idxx)),2));
        nCc_cn_bin_mean=mean(sum(nCc_cn(:,logical(idxx)),2)/sum(logical(idxx)>0));% change count to rate
        nCc_cn_bin_max=max(sum(nCc_cn(:,logical(idxx)),2)/sum(logical(idxx)>0));
        nCc_cn_bin_min=min(sum(nCc_cn(:,logical(idxx)),2)/sum(logical(idxx)>0));
        nCc_cen_bin_mean=mean(sum(nCc_cn(:,logical(idxx)),2));% pure count
        nCc_cen_bin_max=max(sum(nCc_cn(:,logical(idxx)),2));
        nCc_cen_bin_min=min(sum(nCc_cn(:,logical(idxx)),2));
        nS_cn_bin_mean=mean(sum(nS_cn(:,logical(idxx)),2)/sum(logical(idxx)>0));% change count to rate
        nS_cn_bin_max=max(sum(nS_cn(:,logical(idxx)),2)/sum(logical(idxx)>0));
        nS_cn_bin_min=min(sum(nS_cn(:,logical(idxx)),2)/sum(logical(idxx)>0));
        nS_cen_bin_mean=mean(sum(nS_cn(:,logical(idxx)),2));% pure count
        nS_cen_bin_max=max(sum(nS_cn(:,logical(idxx)),2));
        nS_cen_bin_min=min(sum(nS_cn(:,logical(idxx)),2));
        d_o_result(idor3,1)=mean([binEdge(idor3) binEdge(idor3+1)]);
        d_o_result(idor3,2)=nCa_c_bin_mean;
        d_o_result(idor3,3)=nCa_c_bin_max;
        d_o_result(idor3,4)=nCa_c_bin_min;
        d_o_result(idor3,5)=nCc_c_bin_mean;
        d_o_result(idor3,6)=nCc_c_bin_max;
        d_o_result(idor3,7)=nCc_c_bin_min;
        d_o_result(idor3,8)=nS_c_bin_mean;
        d_o_result(idor3,9)=nS_c_bin_max;
        d_o_result(idor3,10)=nS_c_bin_min;
        d_o_result(idor3,11)=nCa_cn_bin_mean;
        d_o_result(idor3,12)=nCa_cn_bin_max;
        d_o_result(idor3,13)=nCa_cn_bin_min;
        d_o_result(idor3,14)=nCc_cn_bin_mean;
        d_o_result(idor3,15)=nCc_cn_bin_max;
        d_o_result(idor3,16)=nCc_cn_bin_min;
        d_o_result(idor3,17)=nS_cn_bin_mean;
        d_o_result(idor3,18)=nS_cn_bin_max;
        d_o_result(idor3,19)=nS_cn_bin_min;
        d_o_result(idor3,20)=nCc_ce_bin_mean;
        d_o_result(idor3,21)=nCc_ce_bin_max;
        d_o_result(idor3,22)=nCc_ce_bin_min;
        d_o_result(idor3,23)=nS_ce_bin_mean;
        d_o_result(idor3,24)=nS_ce_bin_max;
        d_o_result(idor3,25)=nS_ce_bin_min;
        d_o_result(idor3,26)=nCc_cen_bin_mean;
        d_o_result(idor3,27)=nCc_cen_bin_max;
        d_o_result(idor3,28)=nCc_cen_bin_min;
        d_o_result(idor3,29)=nS_cen_bin_mean;
        d_o_result(idor3,30)=nS_cen_bin_max;
        d_o_result(idor3,31)=nS_cen_bin_max;
        leng_all_obj(idor2)=max(d_o_result(:,1));
%         max_all_obj(idor2,1)=max(d_o_result(:,2));
%         max_all_obj(idor2,2)=max(d_o_result(:,3));
%         max_all_obj(idor2,3)=max(d_o_result(:,4));
%         max_all_obj(idor2,4)=max(d_o_result(:,5));
%         max_all_obj(idor2,5)=max(d_o_result(:,6));
%         max_all_obj(idor2,6)=max(d_o_result(:,7));
%         max_all_obj(idor2,7)=max(d_o_result(:,8));
%         max_all_obj(idor2,8)=max(d_o_result(:,9));
%         max_all_obj(idor2,9)=max(d_o_result(:,10));
%         max_all_obj(idor2,10)=max(d_o_result(:,11));
%         max_all_obj(idor2,11)=max(d_o_result(:,12));
%         max_all_obj(idor2,12)=max(d_o_result(:,13));    
%         max_all_obj(idor2,13)=max(d_o_result(:,14));
%         max_all_obj(idor2,14)=max(d_o_result(:,15));
%         max_all_obj(idor2,15)=max(d_o_result(:,16));
%         max_all_obj(idor2,16)=max(d_o_result(:,17));
%         max_all_obj(idor2,17)=max(d_o_result(:,18));
%         max_all_obj(idor2,18)=max(d_o_result(:,19));
%         max_all_obj(idor2,19)=max(d_o_result(:,20)); 
%         max_all_obj(idor2,20)=max(d_o_result(:,21)); 
    end
    d_o_result(isnan(d_o_result))=0;
    dis_ori_rate_obj{1,idor2}=d_o_result;
end

%% draw maps
figure;hold on
namedocell={};
if (exp==10||exp==12)&&i==1
    t=dis_ori_rate_obj{1,2};
    dis_ori_rate_obj{1,2}=dis_ori_rate_obj{1,1};% ori is assigned as 2, change obj name may get better
    dis_ori_rate_obj{1,1}=t;
    namedocell={'ori(fake),look','ori(fake),not look','nov tr(fake),look','nov tr(fake),not look','nov ts(fake),look','nov ts(fake),not look'};
    if ikk==8&&exp==10
        namedocell={'ori(fake),look','ori(fake),not look','nov ts(fake),look','nov ts(fake),not look'};
    end
end
if (exp==10||exp==12)&&i==2
    namedocell={'ori,look','ori,not look','nov tr,look','nov tr,not look','nov ts(fake),look','nov ts(fake),not look'};
    if ikk==8&&exp==10
        namedocell={'ori(fake),look','ori(fake),not look','nov ts(fake),look','nov ts(fake),not look'};
    end
end
if (exp==10||exp==12)&&i==3
    namedocell={'ori,look','ori,not look','nov ts,look','nov ts,not look','nov tr(fake),look','nov tr(fake),not look'};
end

colorm={[1 0 0];[0 1 0];[0 0 1]};
if (exp==10||exp==12)&&i==3
    colorm={[1 0 0];[0 0 1];[0 1 0]};
end
%% amplitude look at obj
for idor2=1:length(in_use_objects)   
    poss=dis_ori_rate_obj{1,idor2}(:,1);
    la=dis_ori_rate_obj{1,idor2}(:,4);
    ha=dis_ori_rate_obj{1,idor2}(:,3);
%     lan=dis_ori_rate_obj{1,idor2}(:,8)-dis_ori_rate_obj{1,idor2}(:,9);
%     han=dis_ori_rate_obj{1,idor2}(:,8)+dis_ori_rate_obj{1,idor2}(:,9);

    hhp(idor2,1)=patch([poss;poss(end:-1:1,1);poss(1,1)],[la;ha(end:-1:1);la(1,1)],colorm{idor2,1});hold on;
    set(hhp(idor2,1), 'FaceAlpha', 0.1, 'edgecolor', 'none');
%     hhp(idor2,2)=patch([poss;poss(end:-1:1,1);poss(1,1)],[lan;han(end:-1:1);lan(1,1)],colorm{idor2,1});
%     set(hhp(idor2,2), 'FaceAlpha', 0.05, 'edgecolor', 'none');
    hhh(idor2,1)=plot(poss,dis_ori_rate_obj{1,idor2}(:,2),'color',colorm{idor2,1});
%     hhh(idor2,2)=plot(poss,dis_ori_rate_obj{1,idor2}(:,8),'--','color',colorm{idor2,1});
%     text(max(leng_all_obj)-50,max(max_all_obj(:,1))-(idor2-1)*0.1,[namedocell{idor2},'(-lk,--nlk)'],'color',colorm{idor2,1});
end
hold off
% namedocell={'1','2','3'};
legend(namedocell);
ylabel('amplitude')
xlabel('distance(mm)')
title('distance-amplitude relationship')
set(gcf,'renderer','painters');
saveas(gcf,[conditionfolder{i},'/','distanceAmplitudeRelationship.fig'],'fig');
saveas(gcf,[conditionfolder{i},'/','distanceAmplitudeRelationship.tif'],'tif');
saveas(gcf,[conditionfolder{i},'/','distanceAmplitudeRelationship.eps'],'epsc');
close;

%% firing rate look at obj
for idor2=1:length(in_use_objects)   
    poss=dis_ori_rate_obj{1,idor2}(:,1);
    lc=dis_ori_rate_obj{1,idor2}(:,7);
    hc=dis_ori_rate_obj{1,idor2}(:,6);
%     lcn=dis_ori_rate_obj{1,idor2}(:,10)-dis_ori_rate_obj{1,idor2}(:,11);
%     hcn=dis_ori_rate_obj{1,idor2}(:,10)+dis_ori_rate_obj{1,idor2}(:,11);

    hhp(idor2,1)=patch([poss;poss(end:-1:1,1);poss(1,1)],[lc;hc(end:-1:1);lc(1,1)],colorm{idor2,1});hold on;
    set(hhp(idor2,1), 'FaceAlpha', 0.1, 'edgecolor', 'none');
%     hhp(idor2,2)=patch([poss;poss(end:-1:1,1);poss(1,1)],[lcn;hcn(end:-1:1);lcn(1,1)],colorm{idor2,1});
%     set(hhp(idor2,2), 'FaceAlpha', 0.05, 'edgecolor', 'none');
    hhh(idor2,1)=plot(poss,dis_ori_rate_obj{1,idor2}(:,5),'color',colorm{idor2,1});
%     hhh(idor2,2)=plot(poss,dis_ori_rate_obj{1,idor2}(:,10),'--','color',colorm{idor2,1});
%     text(max(leng_all_obj)-50,max(max_all_obj(:,3))-(idor2-1)*0.1,[namedocell{idor2},'(-lk,--nlk)'],'color',colorm{idor2,1});
end
hold off
% namedocell={'1','2','3'};
legend(namedocell);
ylabel('firing rate')
xlabel('distance(mm)')
title('distance-firing relationship')
set(gcf,'renderer','painters');
saveas(gcf,[conditionfolder{i},'/','distancefiringRateRelationship.fig'],'fig');
saveas(gcf,[conditionfolder{i},'/','distancefiringRateRelationship.tif'],'tif');
saveas(gcf,[conditionfolder{i},'/','distancefiringRateRelationship.eps'],'epsc');
close;

%% S firing rate look at obj
for idor2=1:length(in_use_objects)   
    poss=dis_ori_rate_obj{1,idor2}(:,1);
    ls=dis_ori_rate_obj{1,idor2}(:,10);
    hs=dis_ori_rate_obj{1,idor2}(:,9);
%     lsn=dis_ori_rate_obj{1,idor2}(:,12)-dis_ori_rate_obj{1,idor2}(:,13);
%     hsn=dis_ori_rate_obj{1,idor2}(:,12)+dis_ori_rate_obj{1,idor2}(:,13);

    hhp(idor2,1)=patch([poss;poss(end:-1:1,1);poss(1,1)],[ls;hs(end:-1:1);ls(1,1)],colorm{idor2,1});hold on;
    set(hhp(idor2,1), 'FaceAlpha', 0.1, 'edgecolor', 'none');
%     hhp(idor2,2)=patch([poss;poss(end:-1:1,1);poss(1,1)],[lsn;hsn(end:-1:1);lsn(1,1)],colorm{idor2,1});
%     set(hhp(idor2,2), 'FaceAlpha', 0.05, 'edgecolor', 'none');
    hhh(idor2,1)=plot(poss,dis_ori_rate_obj{1,idor2}(:,8),'color',colorm{idor2,1});
%     hhh(idor2,2)=plot(poss,dis_ori_rate_obj{1,idor2}(:,12),'--','color',colorm{idor2,1});
%     text(max(leng_all_obj)-50,max(max_all_obj(:,5))-(idor2-1)*0.1,[namedocell{idor2},'(-lk,--nlk)'],'color',colorm{idor2,1});
end
hold off
% namedocell={'1','2','3'};
legend(namedocell);
ylabel('neuron S')
xlabel('distance(mm)')
title('distance-firing relationship')
set(gcf,'renderer','painters');
saveas(gcf,[conditionfolder{i},'/','distanceNeuronSRelationship.fig'],'fig');
saveas(gcf,[conditionfolder{i},'/','distanceNeuronSRateRelationship.tif'],'tif');
saveas(gcf,[conditionfolder{i},'/','distanceNeuronSRateRelationship.eps'],'epsc');
save([conditionfolder{i},'/','distanceActivityRelationship_data.mat'],'dis_ori_rate_obj','in_use_objects');
close;

%% C count look at obj
for idor2=1:length(in_use_objects)   
    poss=dis_ori_rate_obj{1,idor2}(:,1);
    ls=dis_ori_rate_obj{1,idor2}(:,22);
    hs=dis_ori_rate_obj{1,idor2}(:,21);

    hhp(idor2,1)=patch([poss;poss(end:-1:1,1);poss(1,1)],[ls;hs(end:-1:1);ls(1,1)],colorm{idor2,1});hold on;
    set(hhp(idor2,1), 'FaceAlpha', 0.1, 'edgecolor', 'none');
    hhh(idor2,1)=plot(poss,dis_ori_rate_obj{1,idor2}(:,20),'color',colorm{idor2,1});
%     text(max(leng_all_obj)-50,max(max_all_obj(:,5))-(idor2-1)*0.1,[namedocell{idor2},'(-lk,--nlk)'],'color',colorm{idor2,1});
end
hold off
% namedocell={'1','2','3'};
legend(namedocell);
ylabel('neuron C count')
xlabel('distance(mm)')
title('distance-firing relationship')
set(gcf,'renderer','painters');
saveas(gcf,[conditionfolder{i},'/','distanceNeuronCountRelationship.fig'],'fig');
saveas(gcf,[conditionfolder{i},'/','distanceNeuronCountRateRelationship.tif'],'tif');
saveas(gcf,[conditionfolder{i},'/','distanceNeuronCountRateRelationship.eps'],'epsc');
save([conditionfolder{i},'/','distanceActivityRelationship_data.mat'],'dis_ori_rate_obj','in_use_objects');
close;

%% S count look at obj
for idor2=1:length(in_use_objects)   
    poss=dis_ori_rate_obj{1,idor2}(:,1);
    ls=dis_ori_rate_obj{1,idor2}(:,25);
    hs=dis_ori_rate_obj{1,idor2}(:,24);

    hhp(idor2,1)=patch([poss;poss(end:-1:1,1);poss(1,1)],[ls;hs(end:-1:1);ls(1,1)],colorm{idor2,1});hold on;
    set(hhp(idor2,1), 'FaceAlpha', 0.1, 'edgecolor', 'none');
    hhh(idor2,1)=plot(poss,dis_ori_rate_obj{1,idor2}(:,23),'color',colorm{idor2,1});
%     text(max(leng_all_obj)-50,max(max_all_obj(:,5))-(idor2-1)*0.1,[namedocell{idor2},'(-lk,--nlk)'],'color',colorm{idor2,1});
end
hold off
% namedocell={'1','2','3'};
legend(namedocell);
ylabel('neuron S count')
xlabel('distance(mm)')
title('distance-firing relationship')
set(gcf,'renderer','painters');
saveas(gcf,[conditionfolder{i},'/','distanceNeuronCount_S_Relationship.fig'],'fig');
saveas(gcf,[conditionfolder{i},'/','distanceNeuronCount_S_RateRelationship.tif'],'tif');
saveas(gcf,[conditionfolder{i},'/','distanceNeuronCount_S_RateRelationship.eps'],'epsc');
save([conditionfolder{i},'/','distanceActivityRelationship_data.mat'],'dis_ori_rate_obj','in_use_objects');
close;

%% amplitude histogram
nCa_c(isnan(nCa_c))=0;
nCa_c_all_cell_sum=sum(nCa_c,1);
nCa_c_all_cell_std=std(nCa_c,1);
distance_nCa={};
for idor=1:length(in_use_objects)
    for ih=1:length(nCa_c_all_cell_sum)
        distance_nCa{ih,idor}=ones(round(nCa_c_all_cell_sum(ih)),1)*distance_to_obj(ih,idor);
    end
end
distance_nCa=cell2mat(distance_nCa);
for idor=1:length(in_use_objects)
histogram(distance_nCa(:,idor),100);hold on;
end

ylabel('Integrate amplitude')
xlabel('distance(mm)')
title('distance-amplitude relationship')
set(gcf,'renderer','painters');
saveas(gcf,[conditionfolder{i},'/','distanceNeuronAmplitudeRelationship_histogram.fig'],'fig');
saveas(gcf,[conditionfolder{i},'/','distanceNeuronAmplitudeRelationship_histogram.tif'],'tif');
saveas(gcf,[conditionfolder{i},'/','distanceNeuronAmplitudeRelationship_histogram.eps'],'epsc');
save([conditionfolder{i},'/','distanceActivityRelationship_data.mat'],'dis_ori_rate_obj','in_use_objects','distance_nCa');
close;

%% count C histogram
nCc_c(isnan(nCc_c))=0;
nCc_c_all_cell_sum=sum(nCc_c,1);
nCc_c_all_cell_std=std(nCc_c,1);
distance_nCc={};
for idor=1:length(in_use_objects)
    for ih=1:length(nCc_c_all_cell_sum)
        distance_nCc{ih,idor}=ones(round(nCc_c_all_cell_sum(ih)),1)*distance_to_obj(ih,idor);
    end
end
distance_nCc=cell2mat(distance_nCc);
for idor=1:length(in_use_objects)
histogram(distance_nCc(:,idor),100);hold on;
end

ylabel('Count C')
xlabel('distance(mm)')
title('distance-event relationship')
set(gcf,'renderer','painters');
saveas(gcf,[conditionfolder{i},'/','distanceNeuronCountRelationship_histogram.fig'],'fig');
saveas(gcf,[conditionfolder{i},'/','distanceNeuronCountRelationship_histogram.tif'],'tif');
saveas(gcf,[conditionfolder{i},'/','distanceNeuronCountRelationship_histogram.eps'],'epsc');
save([conditionfolder{i},'/','distanceActivityRelationship_data.mat'],'dis_ori_rate_obj','in_use_objects','distance_nCa','distance_nCc');
close;

%% count S histogram
nS_c(isnan(nS_c))=0;
nS_c_all_cell_sum=sum(nS_c,1);
nS_c_all_cell_std=std(nS_c,1);
distance_nS={};
for idor=1:length(in_use_objects)
    for ih=1:length(nS_c_all_cell_sum)
        distance_nS{ih,idor}=ones(round(nS_c_all_cell_sum(ih)),1)*distance_to_obj(ih,idor);
    end
end
distance_nS=cell2mat(distance_nS);
for idor=1:length(in_use_objects)
histogram(distance_nS(:,idor),100);hold on;
end

ylabel('Count S')
xlabel('distance(mm)')
title('distance-eventS relationship')
set(gcf,'renderer','painters');
saveas(gcf,[conditionfolder{i},'/','distanceNeuronCount_S_Relationship_histogram.fig'],'fig');
saveas(gcf,[conditionfolder{i},'/','distanceNeuronCount_S_Relationship_histogram.tif'],'tif');
saveas(gcf,[conditionfolder{i},'/','distanceNeuronCount_S_Relationship_histogram.eps'],'epsc');
save([conditionfolder{i},'/','distanceActivityRelationship_data.mat'],'dis_ori_rate_obj','in_use_objects','distance_nCa','distance_nCc','distance_nS');
close;

%% amplitude cdf
dis_amp_cdf(:,1)=poss;
for idor2=1:length(in_use_objects)    
    dis_amp_cdf(:,idor2+1)=cumsum(dis_ori_rate_obj{1,idor2}(:,2))/sum(dis_ori_rate_obj{1,idor2}(:,2));
end
save([conditionfolder{i},'/','distanceActivityRelationship_data.mat'],'dis_ori_rate_obj','in_use_objects','distance_nCa','distance_nCc','distance_nS','dis_amp_cdf');

%% firing rate cdf
dis_fr_cdf(:,1)=poss;
for idor2=1:length(in_use_objects)    
    dis_fr_cdf(:,idor2+1)=cumsum(dis_ori_rate_obj{1,idor2}(:,5))/sum(dis_ori_rate_obj{1,idor2}(:,5));
end
save([conditionfolder{i},'/','distanceActivityRelationship_data.mat'],'dis_ori_rate_obj','in_use_objects','distance_nCa','distance_nCc','distance_nS','dis_amp_cdf','dis_fr_cdf');
%% event cdf
dis_event_cdf(:,1)=poss;
for idor2=1:length(in_use_objects)    
    dis_event_cdf(:,idor2+1)=cumsum(dis_ori_rate_obj{1,idor2}(:,20))/sum(dis_ori_rate_obj{1,idor2}(:,20));
end
save([conditionfolder{i},'/','distanceActivityRelationship_data.mat'],'dis_ori_rate_obj','in_use_objects','distance_nCa','distance_nCc','distance_nS','dis_amp_cdf','dis_fr_cdf','dis_event_cdf');