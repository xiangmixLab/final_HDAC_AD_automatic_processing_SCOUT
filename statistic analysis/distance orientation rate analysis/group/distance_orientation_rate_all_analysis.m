 % all cell ensemble activity    
function distance_orientation_rate_all_analysis(group,cfolder,groupname,nameparts,conditionfolder,num_of_conditions,foldernamet,numpartsall,in_use_objects,exp)
close all;
for ikkk=1:length(group)
    if exp==10&&ikkk==2
        continue;
    end
    dis_ori_all_m_all_c={};
    dis_nCa_all_m_all_c={};
    dis_nCc_all_m_all_c={};
    dis_nS_all_m_all_c={};
    
    ct=1;
    for ikk=group{ikkk}  
        if ikk==10&&exp==10
            continue;
        end
        cd(foldernamet{ikk})
        np=numpartsall{ikk};
        for i=1:num_of_conditions
            if np(i)>0
                load([pwd,'\',conditionfolder{i},'/','distanceActivityRelationship_data.mat']);
                dis_ori_all_m_all_c{ct,i}=cell2mat(dis_ori_rate_obj);          
                dat_sample=dis_ori_all_m_all_c{ct,i};
                if exp==10&&ikk==8&&i==2
                    dis_ori_all_m_all_c{ct,i}=[nan(size(cell2mat(distance_orientation_relationship_obj),1),2),cell2mat(distance_orientation_relationship_obj)]; 
                    dat_sample=dis_ori_all_m_all_c{ct,i};
                end                  
                dis_nCa_all_m_all_c{ct,1}=distance_nCa;
                dis_nCc_all_m_all_c{ct,1}=distance_nCc;
                dis_nS_all_m_all_c{ct,1}=distance_nS;
            end
        end 
        ct=ct+1;
    end
    
  %% plot
   
  mkdir(cfolder)
  
  for i=1:num_of_conditions
      dis_ori_rate_obj={};
      ktttt=dis_ori_all_m_all_c(:,i);
      ktttt=ktttt(~cellfun('isempty',ktttt));
      dis_ori_all_m_all_c_current=cell2mat(ktttt);
%       dis_ori_all_m_all_c_current(isnan(dis_ori_all_m_all_c_current))=0;
      leng_all_obj=[];
      max_all_obj=[];
      ct=1;
      for idor2=1:size(dis_ori_all_m_all_c_current,2)/length(in_use_objects):size(dis_ori_all_m_all_c_current,2)-round(size(dis_ori_all_m_all_c_current,2)/(length(in_use_objects)))+1
            d_o_result=[];
            distance_to_obj_c=dis_ori_all_m_all_c_current(:,idor2);
            amp_c=dis_ori_all_m_all_c_current(:,idor2+1);
%             amp_max_c=dis_ori_all_m_all_c_current(:,idor2+2);
%             amp_min_c=dis_ori_all_m_all_c_current(:,idor2+3);
            rate_c=dis_ori_all_m_all_c_current(:,idor2+4);
%             rate_max_c=dis_ori_all_m_all_c_current(:,idor2+5);
%             rate_min_c=dis_ori_all_m_all_c_current(:,idor2+6);
            s_c=dis_ori_all_m_all_c_current(:,idor2+7);
%             s_max_c=dis_ori_all_m_all_c_current(:,idor2+8);
%             s_min_c=dis_ori_all_m_all_c_current(:,idor2+9);
            amp_nc=dis_ori_all_m_all_c_current(:,idor2+10);
%             amp_max_nc=dis_ori_all_m_all_c_current(:,idor2+11);
%             amp_min_nc=dis_ori_all_m_all_c_current(:,idor2+12);
            rate_nc=dis_ori_all_m_all_c_current(:,idor2+13);
%             rate_max_nc=dis_ori_all_m_all_c_current(:,idor2+14);
%             rate_min_nc=dis_ori_all_m_all_c_current(:,idor2+15);
            s_nc=dis_ori_all_m_all_c_current(:,idor2+16);
%             s_max_nc=dis_ori_all_m_all_c_current(:,idor2+17);
%             s_min_nc=dis_ori_all_m_all_c_current(:,idor2+18);
            event_c=dis_ori_all_m_all_c_current(:,idor2+19);
%             event_max_c=dis_ori_all_m_all_c_current(:,idor2+20);
%             event_min_c=dis_ori_all_m_all_c_current(:,idor2+21);
            event_s_c=dis_ori_all_m_all_c_current(:,idor2+22);
%             event_s_max_c=dis_ori_all_m_all_c_current(:,idor2+23);
%             event_s_min_c=dis_ori_all_m_all_c_current(:,idor2+24);
            hh=histogram(distance_to_obj_c,100);
            binEdge=hh.BinEdges;
            close;
            for idor3=1:length(binEdge)-1      
                idxx=double(distance_to_obj_c>binEdge(idor3)).*double(distance_to_obj_c<=binEdge(idor3+1));
                amp_cc=mean(amp_c(logical(idxx)));% average by mouse, inside this distance range
                amp_max_cc=max(amp_c(logical(idxx)));
                amp_min_cc=min(amp_c(logical(idxx)));
                rate_cc=mean(rate_c(logical(idxx)));
                rate_max_cc=max(rate_c(logical(idxx)));
                rate_min_cc=min(rate_c(logical(idxx)));
                s_cc=mean(s_c(logical(idxx)));
                s_max_cc=max(s_c(logical(idxx)));
                s_min_cc=min(s_c(logical(idxx)));
                amp_ncc=mean(amp_nc(logical(idxx)));
                amp_max_ncc=max(amp_nc(logical(idxx)));
                amp_min_ncc=min(amp_nc(logical(idxx)));
                rate_ncc=mean(rate_nc(logical(idxx)));
                rate_max_ncc=max(rate_nc(logical(idxx)));
                rate_min_ncc=min(rate_nc(logical(idxx)));
                s_ncc=mean(s_nc(logical(idxx)));
                s_max_ncc=max(s_nc(logical(idxx)));
                s_min_ncc=min(s_nc(logical(idxx)));
                event_cc=mean(event_c(logical(idxx)));
                event_max_cc=max(event_c(logical(idxx)));
                event_min_cc=min(event_c(logical(idxx)));
                event_s_cc=mean(event_s_c(logical(idxx)));
                event_s_max_cc=max(event_s_c(logical(idxx)));
                event_s_min_cc=min(event_s_c(logical(idxx)));
                
                d_o_result(idor3,1)=mean([binEdge(idor3) binEdge(idor3+1)]);
                d_o_result(idor3,2)=amp_cc;
                d_o_result(idor3,3)=amp_max_cc;
                d_o_result(idor3,4)=amp_min_cc;
                d_o_result(idor3,5)=rate_cc;
                d_o_result(idor3,6)=rate_max_cc;
                d_o_result(idor3,7)=rate_min_cc;
                d_o_result(idor3,8)=s_cc;                
                d_o_result(idor3,9)=s_max_cc;      
                d_o_result(idor3,10)=s_min_cc;  
                d_o_result(idor3,11)=amp_ncc;    
                d_o_result(idor3,12)=amp_max_ncc; 
                d_o_result(idor3,13)=amp_min_ncc; 
                d_o_result(idor3,14)=rate_ncc;
                d_o_result(idor3,15)=rate_max_ncc;
                d_o_result(idor3,16)=rate_min_ncc;
                d_o_result(idor3,17)=s_ncc;        
                d_o_result(idor3,18)=s_max_ncc;      
                d_o_result(idor3,19)=s_min_ncc;             
                d_o_result(idor3,20)=event_cc;
                d_o_result(idor3,21)=event_max_cc;
                d_o_result(idor3,22)=event_min_cc;
                d_o_result(idor3,23)=event_s_cc;                
                d_o_result(idor3,24)=event_s_max_cc; 
                d_o_result(idor3,25)=event_s_min_cc; 
            end
            dis_ori_rate_obj{1,ct}=d_o_result;
            leng_all_obj(ct)=max(d_o_result(:,1));
%             max_all_obj(ct,1)=max(d_o_result(:,2));
%             max_all_obj(ct,2)=max(d_o_result(:,3));
%             max_all_obj(ct,3)=max(d_o_result(:,4));
%             max_all_obj(ct,4)=max(d_o_result(:,5));
%             max_all_obj(ct,5)=max(d_o_result(:,6));
%             max_all_obj(ct,6)=max(d_o_result(:,7));
%             max_all_obj(ct,7)=max(d_o_result(:,8));
%             max_all_obj(ct,8)=max(d_o_result(:,9));
%             max_all_obj(ct,9)=max(d_o_result(:,10));
%             max_all_obj(ct,10)=max(d_o_result(:,11));
%             max_all_obj(ct,11)=max(d_o_result(:,12));
%             max_all_obj(ct,12)=max(d_o_result(:,13));    
%             max_all_obj(ct,13)=max(d_o_result(:,14));
%             max_all_obj(ct,14)=max(d_o_result(:,15));
%             max_all_obj(ct,15)=max(d_o_result(:,16));
%             max_all_obj(ct,16)=max(d_o_result(:,17));  
            ct=ct+1;
       end

        figure;hold on
        namedocell={};
        if (exp==10||exp==12)&&i==1
%             t=distance_orientation_relationship_obj_all_m_all_c{1,2};
%             distance_orientation_relationship_obj{1,2}=distance_orientation_relationship_obj_all_m_all_c{1,1};% ori is assigned as 2, change obj name may get better
%             distance_orientation_relationship_obj_all_m_all_c{1,1}=t;
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
        if (exp==10||exp==12)
            colorm={{'r','g','b'};{'r','g','b'};{'r','b','g'}};
        end

        %% amplitude look at obj
        cm=colorm{i};
        for idor2=1:length(in_use_objects)   
            poss=dis_ori_rate_obj{1,idor2}(:,1);
            la=dis_ori_rate_obj{1,idor2}(:,4);
            ha=dis_ori_rate_obj{1,idor2}(:,3);
%             lan=dis_ori_rate_obj{1,idor2}(:,8)-dis_ori_rate_obj{1,idor2}(:,9);
%             han=dis_ori_rate_obj{1,idor2}(:,8)+dis_ori_rate_obj{1,idor2}(:,9);

            hhp(idor2,1)=patch([poss;poss(end:-1:1,1);poss(1,1)],[la;ha(end:-1:1);la(1,1)],cm{idor2});hold on;
            set(hhp(idor2,1), 'FaceAlpha', 0.1, 'edgecolor', 'none');
%             hhp(idor2,2)=patch([poss;poss(end:-1:1,1);poss(1,1)],[lan;han(end:-1:1);lan(1,1)],cm{idor2});
%             set(hhp(idor2,2), 'FaceAlpha', 0.05, 'edgecolor', 'none');
            hhh(idor2,1)=plot(poss,dis_ori_rate_obj{1,idor2}(:,2),'color',cm{idor2});hold on
%             hhh(idor2,2)=plot(poss,dis_ori_rate_obj{1,idor2}(:,8),'--','color',cm{idor2});
%             text(max(leng_all_obj)-50,max(max_all_obj(:,1))-(idor2-1)*1,[namedocell{idor2},'(-lk,--nlk)'],'color',colorm{idor2,1});
        end
        hold off
        % namedocell={'1','2','3'};
        legend(namedocell);
        ylabel('amplitude ')
        xlabel('distance(mm)')
        ylim([0 2000])
        title('distance-amplitude relationship')
        set(gcf,'renderer','painters');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distanceAmplitudeRelationship.fig'],'fig');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distanceAmplitudeRelationship.tif'],'tif');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distanceAmplitudeRelationship.eps'],'epsc');
        close;

        %% firing rate look at obj
        for idor2=1:length(in_use_objects)   
            poss=dis_ori_rate_obj{1,idor2}(:,1);
            lc=dis_ori_rate_obj{1,idor2}(:,7);
            hc=dis_ori_rate_obj{1,idor2}(:,6);
%             lcn=dis_ori_rate_obj{1,idor2}(:,10)-dis_ori_rate_obj{1,idor2}(:,11);
%             hcn=dis_ori_rate_obj{1,idor2}(:,10)+dis_ori_rate_obj{1,idor2}(:,11);

            hhp(idor2,1)=patch([poss;poss(end:-1:1,1);poss(1,1)],[lc;hc(end:-1:1);lc(1,1)],cm{idor2});hold on;
            set(hhp(idor2,1), 'FaceAlpha', 0.1, 'edgecolor', 'none');
%             hhp(idor2,2)=patch([poss;poss(end:-1:1,1);poss(1,1)],[lcn;hcn(end:-1:1);lcn(1,1)],cm{idor2});
%             set(hhp(idor2,2), 'FaceAlpha', 0.05, 'edgecolor', 'none');
            hhh(idor2,1)=plot(poss,dis_ori_rate_obj{1,idor2}(:,5),'color',cm{idor2});hold on
%             hhh(idor2,2)=plot(poss,dis_ori_rate_obj{1,idor2}(:,10),'--','color',cm{idor2});
%             text(max(leng_all_obj)-50,max(max_all_obj(:,3))-(idor2-1)*1,[namedocell{idor2},'(-lk,--nlk)'],'color',colorm{idor2,1});
        end
        hold off
        % namedocell={'1','2','3'};
        legend(namedocell);
        ylabel('firing rate')
        xlabel('distance(mm)')
        title('distance-firingRate relationship')
        ylim([0 0.5])
        set(gcf,'renderer','painters');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distancefiringRateRelationship.fig'],'fig');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distancefiringRateRelationship.tif'],'tif');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distancefiringRateRelationship.eps'],'epsc');
        close;

        %% S look at obj
        for idor2=1:length(in_use_objects)   
            poss=dis_ori_rate_obj{1,idor2}(:,1);
            ls=dis_ori_rate_obj{1,idor2}(:,10);
            hs=dis_ori_rate_obj{1,idor2}(:,9);
%             lsn=dis_ori_rate_obj{1,idor2}(:,12)-dis_ori_rate_obj{1,idor2}(:,13);
%             hsn=dis_ori_rate_obj{1,idor2}(:,12)+dis_ori_rate_obj{1,idor2}(:,13);

            hhp(idor2,1)=patch([poss;poss(end:-1:1,1);poss(1,1)],[ls;hs(end:-1:1);ls(1,1)],cm{idor2});hold on;
            set(hhp(idor2,1), 'FaceAlpha', 0.1, 'edgecolor', 'none');
%             hhp(idor2,2)=patch([poss;poss(end:-1:1,1);poss(1,1)],[lsn;hsn(end:-1:1);lsn(1,1)],cm{idor2});
%             set(hhp(idor2,2), 'FaceAlpha', 0.05, 'edgecolor', 'none');
            hhh(idor2,1)=plot(poss,dis_ori_rate_obj{1,idor2}(:,8),'color',cm{idor2});hold on
%             hhh(idor2,2)=plot(poss,dis_ori_rate_obj{1,idor2}(:,12),'--','color',cm{idor2});
%             text(max(leng_all_obj)-50,max(max_all_obj(:,5))-(idor2-1)*1,[namedocell{idor2},'(-lk,--nlk)'],'color',colorm{idor2,1});
        end
        hold off
        % namedocell={'1','2','3'};
        legend(namedocell);
        ylabel('neuron S')
        xlabel('distance(mm)')
        title('distance-firingRateS relationship')
        set(gcf,'renderer','painters');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distanceNeuronSRateRelationship.fig'],'fig');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distanceNeuronSRateRelationship.tif'],'tif');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distanceNeuronSRateRelationship.eps'],'epsc');
        save([cfolder,'/',groupname{ikkk},'_','distanceActivityRelationship_data.mat'],'dis_ori_rate_obj','in_use_objects');
        close;
        
        %% C count look at obj
        for idor2=1:length(in_use_objects)   
            poss=dis_ori_rate_obj{1,idor2}(:,1);
            ls=dis_ori_rate_obj{1,idor2}(:,22);
            hs=dis_ori_rate_obj{1,idor2}(:,21);

            hhp(idor2,1)=patch([poss;poss(end:-1:1,1);poss(1,1)],[ls;hs(end:-1:1);ls(1,1)],cm{idor2});hold on;
            set(hhp(idor2,1), 'FaceAlpha', 0.1, 'edgecolor', 'none');
            hhh(idor2,1)=plot(poss,dis_ori_rate_obj{1,idor2}(:,20),'color',cm{idor2});
        %     text(max(leng_all_obj)-50,max(max_all_obj(:,5))-(idor2-1)*0.1,[namedocell{idor2},'(-lk,--nlk)'],'color',colorm{idor2,1});
        end
        hold off
        % namedocell={'1','2','3'};
        legend(namedocell);
        ylabel('neuron C count')
        xlabel('distance(mm)')
        title('distance-Count C relationship')
        ylim([0 60])
        set(gcf,'renderer','painters');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distanceNeuronCountRelationship.fig'],'fig');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distanceNeuronCountRelationship.tif'],'tif');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distanceNeuronCountRelationship.eps'],'epsc');
        close;

        %% S count look at obj
        for idor2=1:length(in_use_objects)   
            poss=dis_ori_rate_obj{1,idor2}(:,1);
            ls=dis_ori_rate_obj{1,idor2}(:,25);
            hs=dis_ori_rate_obj{1,idor2}(:,24);

            hhp(idor2,1)=patch([poss;poss(end:-1:1,1);poss(1,1)],[ls;hs(end:-1:1);ls(1,1)],cm{idor2});hold on;
            set(hhp(idor2,1), 'FaceAlpha', 0.1, 'edgecolor', 'none');
            hhh(idor2,1)=plot(poss,dis_ori_rate_obj{1,idor2}(:,23),'color',cm{idor2});
        %     text(max(leng_all_obj)-50,max(max_all_obj(:,5))-(idor2-1)*0.1,[namedocell{idor2},'(-lk,--nlk)'],'color',colorm{idor2,1});
        end
        hold off
        % namedocell={'1','2','3'};
        legend(namedocell);
        ylabel('neuron S count')
        xlabel('distance(mm)')
        title('distance-Count S relationship')
        set(gcf,'renderer','painters');
        
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distanceNeuronCount_S_Relationship.fig'],'fig');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distanceNeuronCount_S_Relationship.tif'],'tif');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distanceNeuronCount_S_Relationship.eps'],'epsc');
        close;
        
        %% amplitude histogram
        distance_nCa=cell2mat(dis_nCa_all_m_all_c);
        for idor=1:size(distance_nCa,2)
        histogram(distance_nCa(:,idor),100);hold on;
        end

        ylabel('Integrate amplitude')
        xlabel('distance(mm)')
        title('distance-amplitude relationship')
         set(gcf,'renderer','painters');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distanceNeuronAmplitudeRelationship_histogram.fig'],'fig');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distanceNeuronAmplitudeRelationship_histogram.tif'],'tif');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distanceNeuronAmplitudeRelationship_histogram.eps'],'epsc');
        close;

        %% count C histogram
        distance_nCc=cell2mat(dis_nCc_all_m_all_c);
        for idor=1:size(distance_nCc,2)
        histogram(distance_nCc(:,idor),100);hold on;
        end

        ylabel('Count C')
        xlabel('distance(mm)')
        title('distance-event relationship')
         set(gcf,'renderer','painters');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distanceNeuronCountRelationship_histogram.fig'],'fig');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distanceNeuronCountRelationship_histogram.tif'],'tif');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distanceNeuronCountRelationship_histogram.eps'],'epsc');
        close;

        %% count S histogram
        distance_nS=cell2mat(dis_nS_all_m_all_c);
        for idor=1:size(distance_nS,2)
        histogram(distance_nS(:,idor),100);hold on;
        end

        ylabel('Count S')
        xlabel('distance(mm)')
        title('distance-event S relationship')
       set(gcf,'renderer','painters');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distanceNeuronCount_S_Relationship_histogram.fig'],'fig');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distanceNeuronCount_S_Relationship_histogram.tif'],'tif');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_',nameparts{i},'distanceNeuronCount_S_Relationship_histogram.eps'],'epsc');
        close;
     end
end