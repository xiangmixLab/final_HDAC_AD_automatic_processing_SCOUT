function [distance_time_relationship_obj,time_close_to_obj]=HDAC_AD_distance_time_relationship(headtimecell,behavpos,in_use_objects,exp,conditionfolder,i,ikk)

ifMouseHeadToObj=headtimecell.if_mouse_head_toward_object;
Fs=15;%current Fs
% unique_obj_current=unique_obj_name_map(:,i);

distance_to_obj=[];
unique_distance_for_obj={};
for idor=1:length(in_use_objects)
    posObjects=in_use_objects{idor};
    posObjects(:,2)=max(max(behavpos(:,2)))-posObjects(:,2);
    distance_to_obj(:,idor)=sum((repmat(posObjects,length(ifMouseHeadToObj),1)-behavpos).^2,2).^0.5;
% unique_distance_for_obj{1,idor}=unique(distance_to_obj(:,idor));
end


distance_time_relationship_obj={};

leng_all_obj=[];
max_all_obj=[];

for idor2=1:length(in_use_objects)
    d_o_result=[];
    distance_to_obj_c=distance_to_obj(:,idor2);
    ifMouseHeadToObj_c=ifMouseHeadToObj(:,idor2);
    hh=histogram(distance_to_obj_c,50);% try to make the distance bin similar to box bin... or make it really small
    binEdge=hh.BinEdges;
    close;
    for idor3=1:length(binEdge)-1      
        idxx=double(distance_to_obj_c>binEdge(idor3)).*double(distance_to_obj_c<=binEdge(idor3+1));
        ifMouseHeadToObj_c_fraction=sum(ifMouseHeadToObj_c(logical(idxx)))/Fs;% length of time in current pos bin facing obj
        bin_time=sum(idxx)/Fs;% length of time in current pos bin
        d_o_result(idor3,1)=mean([binEdge(idor3) binEdge(idor3+1)]);
        d_o_result(idor3,2)=ifMouseHeadToObj_c_fraction;
        d_o_result(idor3,3)=bin_time;
        leng_all_obj(idor2)=max(d_o_result(:,1));
        max_all_obj(idor2)=max(d_o_result(:,2));
    end
    distance_time_relationship_obj{1,idor2}=d_o_result;
end

figure;hold on
namedocell={};
if (exp==10||exp==12||exp==13)&&i==1
    t=distance_time_relationship_obj{1,2};
    distance_time_relationship_obj{1,2}=distance_time_relationship_obj{1,1};% ori is assigned as 2, change obj name may get better
    distance_time_relationship_obj{1,1}=t;
    namedocell={'ori*','nov tr*','nov ts*'};
    if ikk==8&&exp==10
        namedocell={'ori*','nov ts*'};
    end
end
if (exp==10||exp==12||exp==13)&&i==2
    namedocell={'ori','nov tr','nov ts*'};
    if ikk==8&&exp==10
        namedocell={'ori*','nov ts*'};
    end
end
if (exp==10||exp==12||exp==13)&&i==3
    namedocell={'ori','nov ts','nov tr*'};
end

colorm={'r','b','m','g'};
if (exp==10||exp==12||exp==13)&&i==3
    colorm={'r','m','b','g'};
end
%% plot time facing obj
for idor2=1:length(in_use_objects)    
    plot(distance_time_relationship_obj{1,idor2}(:,1),distance_time_relationship_obj{1,idor2}(:,2),'color',colorm{idor2});
%     text(max(leng_all_obj)-10,max(max_all_obj)-(idor2-1)*0.1,namedocell{idor2},'color',colorm{idor2});
end
% namedocell={'1','2','3'};
% legend(namedocell);
ylabel('Time that facing to obj')
xlabel('distance(mm)')
title('distance-facing time relationship')

saveas(gcf,[conditionfolder{i},'/','distancetimeRelationship.fig'],'fig');
saveas(gcf,[conditionfolder{i},'/','distancetimeRelationship.tif'],'tif');
saveas(gcf,[conditionfolder{i},'/','distancetimeRelationship.eps'],'epsc');
save([conditionfolder{i},'/','distancetimeRelationship_data.mat'],'distance_time_relationship_obj','distance_to_obj','ifMouseHeadToObj','in_use_objects');
% close;

%% plot time in position bins
for idor2=1:length(in_use_objects)    
    plot(distance_time_relationship_obj{1,idor2}(:,1),distance_time_relationship_obj{1,idor2}(:,3),'color',colorm{idor2});
%     text(max(leng_all_obj)-10,max(max_all_obj)-(idor2-1)*0.1,namedocell{idor2},'color',colorm{idor2});
end
% namedocell={'1','2','3'};
% legend(namedocell);
ylabel('Time in current position bin')
xlabel('distance(mm)')
title('distance-time relationship')

saveas(gcf,[conditionfolder{i},'/','distance_totalTime_Relationship.fig'],'fig');
saveas(gcf,[conditionfolder{i},'/','distance_totalTime_Relationship.tif'],'tif');
saveas(gcf,[conditionfolder{i},'/','distance_totalTime_Relationship.eps'],'epsc');
save([conditionfolder{i},'/','distance_totalTime_Relationship_data.mat'],'distance_time_relationship_obj','distance_to_obj','ifMouseHeadToObj','in_use_objects');
% close;

%% histogram

distance_nS=distance_to_obj;
for idor=1:length(in_use_objects)
histogram(distance_nS(:,idor),50);hold on;
end

ylabel('Time in current position bin')
xlabel('distance(mm)')
title('distance-time relationship')
set(gcf,'renderer','painters');
saveas(gcf,[conditionfolder{i},'/','distance_totalTime_Relationship_histogram.fig'],'fig');
saveas(gcf,[conditionfolder{i},'/','distance_totalTime_Relationship_histogram.tif'],'tif');
saveas(gcf,[conditionfolder{i},'/','distance_totalTime_Relationship_histogram.eps'],'epsc');
close;

%% Normalized cdf
dis_time_cdf(:,1)=distance_time_relationship_obj{1,1}(:,1);
for idor2=1:length(in_use_objects)    
    dis_time_cdf(:,idor2+1)=cumsum(distance_time_relationship_obj{1,idor2}(:,3));
end
idx_close_to_obj=max(find(dis_time_cdf(:,1)<=50));
time_close_to_obj=mat2cell(dis_time_cdf(idx_close_to_obj,2:end),1,ones(1,length(in_use_objects)));
if (exp==10||exp==12||exp==13)&&i==3
    t=time_close_to_obj(2);
    time_close_to_obj(2)=time_close_to_obj(3);
    time_close_to_obj(3)=t;
end
save([conditionfolder{i},'/','distance_totalTime_Relationship_data.mat'],'distance_time_relationship_obj','distance_to_obj','ifMouseHeadToObj','in_use_objects','dis_time_cdf','time_close_to_obj');
