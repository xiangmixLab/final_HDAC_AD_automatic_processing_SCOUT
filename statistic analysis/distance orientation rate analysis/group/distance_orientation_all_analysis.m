 % all cell ensemble activity    
function distance_orientation_all_analysis(group,cfolder,groupname,nameparts,conditionfolder,num_of_conditions,foldernamet,numpartsall,in_use_objects,exp)
close all;    
for ikkk=1:length(group)
    if exp==10&&ikkk==2
        continue;
    end
    dis_ori_all_m_all_c={};
    ct=1;
    for ikk=group{ikkk}  
        if ikk==10&&exp==10
            continue;
        end
        cd(foldernamet{ikk})
        np=numpartsall{ikk};
        for i=1:num_of_conditions
            if np(i)>0
                load([pwd,'\',conditionfolder{i},'/','distanceOrientationRelationship_data.mat']);
                dis_ori_all_m_all_c{ct,i}=cell2mat(distance_orientation_relationship_obj); 
%                 ktl=[];
%                 ct=1;
%                 for l1=1:2:2*length(in_use_objects)-1
%                     ktl(:,l1)=distance_to_obj(:,ct);
%                     ktl(:,l1+1)=ifMouseHeadToObj(:,ct);
%                     ct=ct+1;
%                 end
%                     
%                 dis_ori_all_m_all_c{ct,i}=ktl;   
%                 dat_sample=dis_ori_all_m_all_c{ct,i};
                if exp==10&&ikk==8&&i==2
%                     dis_ori_all_m_all_c{ct,i}=[nan(size(cell2mat(distance_orientation_relationship_obj),1),2),cell2mat(distance_orientation_relationship_obj)]; 
%                     dat_sample=dis_ori_all_m_all_c{ct,i};
                end                      
            end
            end 
        ct=ct+1;
    end
    
  %% plot
   
  mkdir(cfolder)
  for i=1:num_of_conditions
      distance_orientation_relationship_obj_all_m_all_c={};
      ktttt=dis_ori_all_m_all_c(:,i);
      ktttt=ktttt(~cellfun('isempty',ktttt));
      dis_ori_all_m_all_c_current=cell2mat(ktttt);
      leng_all_obj=[];
      max_all_obj=[];
      ct=1;
        for idor2=1:2:size(dis_ori_all_m_all_c_current,2)-1
            d_o_result=[];
            distance_to_obj_c=dis_ori_all_m_all_c_current(:,idor2);
            ifMouseHeadToObj_c=dis_ori_all_m_all_c_current(:,idor2+1);
            hh=histogram(distance_to_obj_c,50);
            binEdge=hh.BinEdges;
            close;
            for idor3=1:length(binEdge)-1      
                idxx=double(distance_to_obj_c>binEdge(idor3)).*double(distance_to_obj_c<=binEdge(idor3+1));
                ifMouseHeadToObj_c_fraction=mean(ifMouseHeadToObj_c(logical(idxx)));
                ifMouseHeadToObj_c_fraction_min=min(ifMouseHeadToObj_c(logical(idxx)));
                ifMouseHeadToObj_c_fraction_max=max(ifMouseHeadToObj_c(logical(idxx)));
                d_o_result(idor3,1)=mean([binEdge(idor3) binEdge(idor3+1)]);
                d_o_result(idor3,2)=ifMouseHeadToObj_c_fraction;
                d_o_result(idor3,3)=ifMouseHeadToObj_c_fraction_min;
                d_o_result(idor3,4)=ifMouseHeadToObj_c_fraction_max;
            end
            distance_orientation_relationship_obj_all_m_all_c{1,ct}=d_o_result;
            leng_all_obj(ct)=max(d_o_result(:,1));
            max_all_obj(ct)=max(d_o_result(:,2));
            ct=ct+1;
        end

        figure;hold on
        namedocell={};
        if (exp==10||exp==12)&&i==1
%             t=distance_orientation_relationship_obj_all_m_all_c{1,2};
%             distance_orientation_relationship_obj{1,2}=distance_orientation_relationship_obj_all_m_all_c{1,1};% ori is assigned as 2, change obj name may get better
%             distance_orientation_relationship_obj_all_m_all_c{1,1}=t;
            namedocell={'ori(fake)','nov_tr(fake)','nov_ts(fake)'};
            if ikk==8&&exp==10
                namedocell={'ori(fake)','nov ts(fake)'};
            end
        end
        if (exp==10||exp==12)&&i==2
            namedocell={'ori','nov tr','nov ts(fake)'};
            if ikk==8&&exp==10
                namedocell={'ori(fake)','nov ts(fake)'};
            end
        end
        if (exp==10||exp==12)&&i==3
            namedocell={'ori','nov ts','nov tr(fake)'};
        end
        
        if (exp==10||exp==12)
            colorm={{'r','b','m','g'},{'r','b','m','g'},{'r','m','b','g'}};
        end
        for idor2=1:length(in_use_objects)  
            cm=colorm{i};
            poss=distance_orientation_relationship_obj_all_m_all_c{1,idor2}(:,1);
            ls=distance_orientation_relationship_obj_all_m_all_c{1,idor2}(:,3);
            hs=distance_orientation_relationship_obj_all_m_all_c{1,idor2}(:,4);

            hhp(idor2,1)=patch([poss;poss(end:-1:1,1);poss(1,1)],[ls;hs(end:-1:1);ls(1,1)],cm{idor2});hold on;
            set(hhp(idor2,1), 'FaceAlpha', 0.1, 'edgecolor', 'none');
            hhh(idor2)=plot(distance_orientation_relationship_obj_all_m_all_c{1,idor2}(:,1),distance_orientation_relationship_obj_all_m_all_c{1,idor2}(:,2),'color',cm{idor2});
%             text(max(leng_all_obj)-10,max(max_all_obj)-(idor2-1)*0.1,namedocell{idor2},'color',colorm{idor2});
        end
        hold off
        % namedocell={'1','2','3'};
        legend(namedocell);
        ylabel('fraction of time that facing to obj')
        xlabel('distance(mm)')
        ylim([0 1]);
        title('distance-orientation relationship')
        set(gcf,'renderer','painter');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distanceOrientationRelationship','.fig'],'fig');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distanceOrientationRelationship','.tif'],'tif');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distanceOrientationRelationship','.eps'],'epsc');
        save([cfolder,'/',groupname{ikkk},'_',nameparts{i},'distanceOrientationRelationship_data.mat'],'distance_orientation_relationship_obj_all_m_all_c','dis_ori_all_m_all_c');
        close;
      end
end