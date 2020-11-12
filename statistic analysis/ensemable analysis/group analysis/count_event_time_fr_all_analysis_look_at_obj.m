% all cell ensemble activity    
 function count_event_time_fr_all_analysis_look_at_obj(group,cfolder,binsize,groupname,nameparts,foldernamet,numpartsall,conditionfolder,num_of_conditions,boxlength,exp)
 close all;   
    for ikkk=1:length(group)
    count_all_m_all_c={};
    countT_all_m_all_c={};
    firingr_all_m_all_c={};
    amplitude_all_m_all_c={};
    amplitude_n_all_m_all_c={};
    obj_all_m_all_c={};
    ct=1;
    obj_sample={};
    for ikk=group{ikkk}  
        if ikk==10&&exp==10
            continue;
        end
        cd(foldernamet{ikk})
        np=numpartsall{ikk};
        for i=1:num_of_conditions
            if np(i)>0
            dat1=importdata([pwd,'\',conditionfolder{i},'/','single_cell_firing_profile_look_at_obj.mat']);% load real count, countTime,firingrate
            dat2=importdata([pwd,'\',conditionfolder{i},'/','single_cell_amp_profile_look_at_obj.mat']);% load real amplitude, amplitude_normalized
            countmouob1=dat1.countmouob1;
            countTimemouob1=dat1.countTimemouob1;
            firingratemouob=dat1.firingratemouob;
            objects=dat1.objects;
            countmouob1_amp=dat2.countmouob1_amp;
            firingratemouob_amp=dat2.firingratemouob_amp;
            count_all_m_all_c(ct:length(countmouob1)+ct-1,i)=countmouob1;          
            firingr_all_m_all_c(ct:length(firingratemouob)+ct-1,i)=firingratemouob;
            amplitude_all_m_all_c(ct:length(countmouob1_amp)+ct-1,i)=countmouob1_amp;
            amplitude_n_all_m_all_c(ct:length(firingratemouob_amp)+ct-1,i)=firingratemouob_amp;
            
            [countmouob1,firingratemouob,countmouob1_amp,firingratemouob_amp,countTimemouob1,objects]=reversedir(countmouob1,firingratemouob,countmouob1_amp,firingratemouob_amp,countTimemouob1,objects,boxlength);

            for lp=1:length(countmouob1)           
                countT_all_m_all_c(lp+ct-1,i)={countTimemouob1};    
            end
            
            for lp=1:length(count)
                obj_all_m_all_c(lp+ct-1,i)={objects}; 
            end

%             obj_sample{1,i}=objects;%just need to see the number of objs, no matter the pos
            ct=ct+length(countmouob1);    
        end
        end
    end
    
    %% resample to 15*20
    for i=1:size(count_all_m_all_c,1)
        for j=1:size(count_all_m_all_c,2)
            c01=count_all_m_all_c{i,j};
            c02=firingr_all_m_all_c{i,j};
            c03=countT_all_m_all_c{i,j};
            c04=amplitude_all_m_all_c{i,j};
            c05=amplitude_n_all_m_all_c{i,j};
            obj=obj_all_m_all_c{i,j};
            if ~isempty(c01)
                scale=[15/size(c01,1),20/size(c01,2)];
                c01=imresize(c01,[15 20]);
                count_all_m_all_c{i,j}=c01;               
            end
%             countT_all_m_all_c(ct:length(countTime)+ct-1,i)={countTime};
            if ~isempty(c02)
                c02=imresize(c02,[15 20]);
                firingr_all_m_all_c{i,j}=c02;
            end
            if ~isempty(c03)
                scale=[15/size(c03,1),20/size(c03,2)];
                c03=imresize(c03,[15 20]);
                countT_all_m_all_c{i,j}=c03;
                obj(:,1)=obj(:,1)*scale(2);
                obj(:,2)=obj(:,2)*scale(1);
                obj_all_m_all_c{i,j}=obj;
            end
            if ~isempty(c04)
                scale=[15/size(c04,1),20/size(c04,2)];
                c04=imresize(c04,[15 20]);
                amplitude_all_m_all_c{i,j}=c04;
            end
            if ~isempty(c05)
                c05=imresize(c05,[15 20]);
                amplitude_n_all_m_all_c{i,j}=c05;
            end
        end
    end

    %% object position average
    objpos={};
    for j=1:size(count_all_m_all_c,2)
        objposcd=[];
        ctt=1;
        for i=1:size(count_all_m_all_c,1)   
            if ~isempty(obj_all_m_all_c{i,j})&&sum(sum(obj_all_m_all_c{i,j}))>0
                objposcd(:,:,ctt)=obj_all_m_all_c{i,j};
                ctt=ctt+1;
            end
            
        end
        objposcd=mean(objposcd,3);
        objpos{1,j}=objposcd;
    end
    
    %% add non-exist obj
    objnamehall={};
    for j=1:size(count_all_m_all_c,2)
        if (exp==10||exp==12)&&j==1
            objtt=[mean([objpos{1,2}(1,:);objpos{1,3}(1,:)],1);objpos{1,2}(2,:);objpos{1,3}(2,:)];   
            objnamehall{j}={'1(n.e.)','2(n.e.)','3(n.e.)'};
        end
        if (exp==10||exp==12)&&j==2
            objtt=[objpos{1,j};objpos{1,3}(2,:)]; 
            objnamehall{j}={'1','2','3(n.e.)'};
        end     
        if (exp==10||exp==12)&&j==3
            objtt=[objpos{1,j};objpos{1,2}(2,:)];   
            objnamehall{j}={'1','3','2(n.e.)'};
        end    
        objpos{1,j}=objtt;
    end
    %% plot
    mkdir(cfolder)
%     define_colormap_across_mouse;
    colorscale1=[0 0.8];
    colorscale2=[0 0.8];
    colorscale3=[0 0.8];
    colorscale4=[0 30];
    colorscale5=[0 30];
    for i=1:num_of_conditions
        [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects,sumFiringRateObject_individual]=comparingFiringRateSingleConditionMultiObjects(count_all_m_all_c(:,i)',binsize,[], objpos{i},'events',colorscale1,1,1,objnamehall{i});
        save([cfolder,'/',groupname{ikkk},'_neuron_comparingCountevents_',nameparts{i},'_binsize',num2str(binsize),'data.mat'],'firingRateSmoothing','sumFiringRateObject','firingRateSmoothing2','radius','posObjects','count_all_m_all_c','obj_all_m_all_c');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingCountevents_',nameparts{i},'_binsize',num2str(binsize),'.fig'],'fig');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingCountevents_',nameparts{i},'_binsize',num2str(binsize),'.tif'],'tif');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingCountevents_',nameparts{i},'_binsize',num2str(binsize),'.eps'],'epsc');
        [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects,sumFiringRateObject_individual]=comparingFiringRateSingleConditionMultiObjects(countT_all_m_all_c(:,i)',binsize,[], objpos{i},'count Time',colorscale2,1,1,objnamehall{i});
        save([cfolder,'/',groupname{ikkk},'_neuron_comparingCountTime_',nameparts{i},'_binsize',num2str(binsize),'data.mat'],'firingRateSmoothing','sumFiringRateObject','firingRateSmoothing2','radius','posObjects','countT_all_m_all_c','obj_all_m_all_c');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingCountTime_',nameparts{i},'_binsize',num2str(binsize),'.fig'],'fig');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingCountTime_',nameparts{i},'_binsize',num2str(binsize),'.tif'],'tif');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingCountTime_',nameparts{i},'_binsize',num2str(binsize),'.eps'],'epsc');
        [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects,sumFiringRateObject_individual]=comparingFiringRateSingleConditionMultiObjects(firingr_all_m_all_c(:,i)',binsize,[], objpos{i},'firing rate',colorscale3,1,1,objnamehall{i});
        save([cfolder,'/',groupname{ikkk},'_neuron_comparingFiringRate_',nameparts{i},'_binsize',num2str(binsize),'data.mat'],'firingRateSmoothing','sumFiringRateObject','firingRateSmoothing2','radius','posObjects','firingr_all_m_all_c','obj_all_m_all_c');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingFiringRate_',nameparts{i},'_binsize',num2str(binsize),'.fig'],'fig');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingFiringRate_',nameparts{i},'_binsize',num2str(binsize),'.tif'],'tif');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingFiringRate_',nameparts{i},'_binsize',num2str(binsize),'.eps'],'epsc');
        [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects,sumFiringRateObject_individual]=comparingFiringRateSingleConditionMultiObjects(amplitude_all_m_all_c(:,i)',binsize,[], objpos{i},'Amplitude',colorscale4,1,1,objnamehall{i});
        save([cfolder,'/',groupname{ikkk},'_neuron_comparingAmplitude_',nameparts{i},'_binsize',num2str(binsize),'data.mat'],'firingRateSmoothing','sumFiringRateObject','firingRateSmoothing2','radius','posObjects','amplitude_all_m_all_c','obj_all_m_all_c');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingAmplitude_',nameparts{i},'_binsize',num2str(binsize),'.fig'],'fig');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingAmplitude_',nameparts{i},'_binsize',num2str(binsize),'.tif'],'tif');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingAmplitude_',nameparts{i},'_binsize',num2str(binsize),'.eps'],'epsc');
        [firingRateSmoothing,sumFiringRateObject,firingRateSmoothing2,~,radius,posObjects,sumFiringRateObject_individual]=comparingFiringRateSingleConditionMultiObjects(amplitude_n_all_m_all_c(:,i)',binsize,[], objpos{i},'Normalized Amplitude',colorscale5,1,1,objnamehall{i});
        save([cfolder,'/',groupname{ikkk},'_neuron_comparingAmplitudeNormalized_',nameparts{i},'_binsize',num2str(binsize),'data.mat'],'firingRateSmoothing','sumFiringRateObject','firingRateSmoothing2','radius','posObjects','amplitude_n_all_m_all_c','obj_all_m_all_c');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingAmplitudeNormalized_',nameparts{i},'_binsize',num2str(binsize),'.fig'],'fig');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingAmplitudeNormalized_',nameparts{i},'_binsize',num2str(binsize),'.tif'],'tif');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingAmplitudeNormalized_',nameparts{i},'_binsize',num2str(binsize),'.eps'],'epsc');
%         exname=[cfolder,'/',groupname{ikkk},'_neuron comparingData.xlsx'];
%         sname1=[nameparts{i},'_count_events'];
%         sname2=[nameparts{i},'_bin_time'];
%         sname3=[nameparts{i},'_firing_rate'];
%         sname4=[nameparts{i},'_amplitude'];
%         sname5=[nameparts{i},'_amplitude_norm'];
%         xlswrite(exname,count_all_m_all_c(:,i),sname1);
%         xlswrite(exname,countT_all_m_all_c(:,i),sname2);
%         xlswrite(exname,firingr_all_m_all_c(:,i),sname3);
%         xlswrite(exname,amplitude_all_m_all_c(:,i),sname4);
%         xlswrite(exname,amplitude_n_all_m_all_c(:,i),sname5);
    end
    end