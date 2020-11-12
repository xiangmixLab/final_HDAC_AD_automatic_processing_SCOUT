function distance_orientation_relationship_obj=HDAC_AD_distance_orientation_relationship(headorientationcell,behavpos,in_use_objects,exp,conditionfolder,i,ikk)

ifMouseHeadToObj=headorientationcell.if_mouse_head_toward_object;

% unique_obj_current=unique_obj_name_map(:,i);

distance_to_obj=[];
unique_distance_for_obj={};
for idor=1:length(in_use_objects)
    posObjects=in_use_objects{idor};
    posObjects(:,2)=max(max(behavpos(:,2)))-posObjects(:,2);
    distance_to_obj(:,idor)=sum((repmat(posObjects,length(ifMouseHeadToObj),1)-behavpos).^2,2).^0.5;
% unique_distance_for_obj{1,idor}=unique(distance_to_obj(:,idor));
end


distance_orientation_relationship_obj={};

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
        ifMouseHeadToObj_c_fraction=sum(ifMouseHeadToObj_c(logical(idxx))==1)/length(ifMouseHeadToObj_c(logical(idxx)));
        d_o_result(idor3,1)=mean([binEdge(idor3) binEdge(idor3+1)]);
        d_o_result(idor3,2)=ifMouseHeadToObj_c_fraction;
        leng_all_obj(idor2)=max(d_o_result(:,1));
        max_all_obj(idor2)=max(d_o_result(:,2));
        min_all_obj(idor2)=min(d_o_result(:,2));
    end
    distance_orientation_relationship_obj{1,idor2}=d_o_result;
end

figure;hold on
namedocell={};
if (exp==10||exp==12)&&i==1
    t=distance_orientation_relationship_obj{1,2};
    distance_orientation_relationship_obj{1,2}=distance_orientation_relationship_obj{1,1};% ori is assigned as 2, change obj name may get better
    distance_orientation_relationship_obj{1,1}=t;
    namedocell={'ori*','nov tr*','nov ts*'};
    if ikk==8&&exp==10
        namedocell={'ori*','nov ts*'};
    end
end
if (exp==10||exp==12)&&i==2
    namedocell={'ori','nov tr','nov ts*'};
    if ikk==8&&exp==10
        namedocell={'ori*','nov ts*'};
    end
end
if (exp==10||exp==12)&&i==3
    namedocell={'ori','nov ts','nov tr*'};
end

colorm={'r','b','m','g'};
if (exp==10||exp==12)&&i==3
    colorm={'r','m','b','g'};
end

for idor2=1:length(in_use_objects)    
    
    plot(distance_orientation_relationship_obj{1,idor2}(:,1),distance_orientation_relationship_obj{1,idor2}(:,2),'color',colorm{idor2});
%     text(max(leng_all_obj)-10,max(max_all_obj)-(idor2-1)*0.1,namedocell{idor2},'color',colorm{idor2});
end
% namedocell={'1','2','3'};
% legend(namedocell);
ylabel('fraction of time that facing to obj')
xlabel('distance(mm)')
title('distance-orientation relationship')

saveas(gcf,[conditionfolder{i},'/','distanceOrientationRelationship.fig'],'fig');
saveas(gcf,[conditionfolder{i},'/','distanceOrientationRelationship.tif'],'tif');
saveas(gcf,[conditionfolder{i},'/','distanceOrientationRelationship.eps'],'epsc');
save([conditionfolder{i},'/','distanceOrientationRelationship_data.mat'],'distance_orientation_relationship_obj','distance_to_obj','ifMouseHeadToObj','in_use_objects');
% close;