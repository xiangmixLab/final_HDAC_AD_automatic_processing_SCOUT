 % all cell ensemble activity    
    function count_event_time_fr_all_analysis_all_obj(group,cfolder,binsize,groupname,nameparts,foldernamet,numpartsall,conditionfolder,objname,num_of_conditions,boxlength,exp,temp)
        
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
            if isequal(temp,'C')
            dat1=importdata([pwd,'\',conditionfolder{i},'/','single_cell_firing_profile.mat']);% load real count, countTime,firingrate
            dat2=importdata([pwd,'\',conditionfolder{i},'/','single_cell_amplitude_profile.mat']);% load real amplitude, amplitude_normalized
            count=dat1.count;
            countTime=dat1.countTime;
            firingrate=dat1.firingrate;
            objects=dat1.objects;
            amplitude=dat2.amplitude;
            amplitude_normalized=dat2.amplitude_normalized;
            end
            if isequal(temp,'S')
            dat1=importdata([pwd,'\',conditionfolder{i},'/','single_cell_firing_profile_S.mat']);% load real count, countTime,firingrate
            dat2=importdata([pwd,'\',conditionfolder{i},'/','single_cell_amplitude_profile_S.mat']);% load real amplitude, amplitude_normalized
            count=dat1.countS;
            countTime=dat1.countTime;
            firingrate=dat1.firingrateS;
            objects=dat1.objects;
            amplitude=dat2.amplitudeS;
            amplitude_normalized=dat2.amplitude_normalizedS;
            end    
            if isequal(temp,'trace')
            dat1=importdata([pwd,'\',conditionfolder{i},'/','single_cell_firing_profile_tr.mat']);% load real count, countTime,firingrate
            dat2=importdata([pwd,'\',conditionfolder{i},'/','single_cell_amplitude_profile.mat']);% load real amplitude, amplitude_normalized
            count=dat1.counttr;
            countTime=dat1.countTime;
            firingrate=dat1.firingratetr;
            objects=dat1.objects;
            amplitude=dat2.amplitude;
            amplitude_normalized=dat2.amplitude_normalized;
            end            

            if ikk<=4&&exp==10
                for pp=1:length(count)
                    countt=count{pp};
                    countt=rot90(countt);
                    countt=flipud(countt);
                    count{pp}=countt;
                    firingratet=firingrate{pp};
                    firingratet=rot90(firingratet);
                    firingratet=flipud(firingratet);
                    firingrate{pp}=firingratet;
                    amplitudet=amplitude{pp};
                    amplitudet=rot90(amplitudet);
                    amplitudet=flipud(amplitudet);
                    amplitude{pp}=amplitudet;                    
                    amplitude_normalizedt= amplitude_normalized{pp};
                     amplitude_normalizedt=rot90( amplitude_normalizedt);
                     amplitude_normalizedt=flipud( amplitude_normalizedt);
                     amplitude_normalized{pp}= amplitude_normalizedt;
                end
            end
            if exp==10&&(ikk==16||ikk==17)&&i==2
                   for pp=1:length(count)
                        countt=count{pp};
                        countt=fliplr(countt);
                        count{pp}=countt;
                        firingratet=firingrate{pp};
                        firingratet=fliplr(firingratet);
                        firingrate{pp}=firingratet;
                        amplitudet=amplitude{pp};
                        amplitudet=fliplr(amplitudet);
                        amplitude{pp}=amplitudet;
                        amplitude_normalizedt=amplitude_normalized{pp};
                        amplitude_normalizedt=fliplr(amplitude_normalizedt);
                        amplitude_normalized{pp}=amplitude_normalizedt;
                   end
            end
            if exp==12&&(ikk==6||ikk==7)&&(i==2||i==3)
                   for pp=1:length(count)
                        countt=count{pp};
                        countt=fliplr(countt);
                        count{pp}=countt;
                        firingratet=firingrate{pp};
                        firingratet=fliplr(firingratet);
                        firingrate{pp}=firingratet;
                        amplitudet=amplitude{pp};
                        amplitudet=fliplr(amplitudet);
                        amplitude{pp}=amplitudet;
                        amplitude_normalizedt=amplitude_normalized{pp};
                        amplitude_normalizedt=fliplr(amplitude_normalizedt);
                        amplitude_normalized{pp}=amplitude_normalizedt;                        
                   end
            end
            count_all_m_all_c(ct:length(count)+ct-1,i)=count;          
            firingr_all_m_all_c(ct:length(firingrate)+ct-1,i)=firingrate;
            amplitude_all_m_all_c(ct:length(amplitude)+ct-1,i)=amplitude;
            amplitude_n_all_m_all_c(ct:length(amplitude_normalized)+ct-1,i)=amplitude_normalized;
            
            if ikk<=4&&exp==10
                    countTime=rot90(countTime);
                    countTime=flipud(countTime);
            end
            if exp==10&&(ikk==16||ikk==17)&&i==2
                    countTime=fliplr(countTime);
            end
            if exp==12&&(ikk==6||ikk==7)&&(i==2||i==3)
                    countTime=fliplr(countTime);
            end
            
            for lp=1:length(count)           
                countT_all_m_all_c(lp+ct-1,i)={countTime};    
            end
            
            if ikk<=4&&exp==10
                    theta = 90; % to rotate 90 counterclockwise
                    R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
                    % Rotate your point(s)
                    objects = (R*objects')'; % arbitrarily selected
                    objects(:,1)=objects(:,1)+boxlength/size(countTime,1)*size(countTime,2);% countTime already flipped
                    objects(:,2)=boxlength-objects(:,2);
            end
            if exp==10&&(ikk==16||ikk==17)&&i==2
                    objects(:,1)=boxlength-objects(:,1);
                    t=objects(2,:);% fix mechanism
                    objects(2,:)=objects(:,1);
                    objects(1,:)=t;
            end
            if exp==12&&(ikk==6||ikk==7)&&(i==2||i==3)
                    objects(:,1)=boxlength-objects(:,1);
                    t=objects(2,:);% fix mechanism
                    objects(2,:)=objects(:,1);
                    objects(1,:)=t;
            end
            for lp=1:length(count)
                obj_all_m_all_c(lp+ct-1,i)={objects}; 

            end
%             obj_sample{1,i}=objects;%just need to see the number of objs, no matter the pos
            ct=ct+length(count);    
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
                c01=imresize(c01,[15 20]);
                count_all_m_all_c{i,j}=c01;               
            end
%             countT_all_m_all_c(ct:length(countTime)+ct-1,i)={countTime};
            if ~isempty(c02)
                scale=[15/size(c02,1),20/size(c02,2)];
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
            objtt=[objpos{1,j}(1,:);objpos{1,2}(2,:);objpos{1,j}(2,:);];   
            objnamehall{j}={'1','2(n.e.)','3'};
        end    
        objpos{1,j}=objtt;
    end
    
    %%
    mkdir(cfolder)
%     define_colormap_across_mouse;
    colorscale1=[0 1.5];
    colorscale2=[0 1.5];
    colorscale3=[0 1.5];
    colorscale4=[0 60];
    colorscale5=[0 60];
    if isequal(temp,'S')
    colorscale1=[0 0.1];
    colorscale2=[0 1.5];
    colorscale3=[0 0.1];
    colorscale4=[0 2.5];
    colorscale5=[0 2.5];
    end
    if isequal(temp,'trace')
    colorscale1=[0 0.03];
    colorscale2=[0 1.5];
    colorscale3=[0 0.03];
    colorscale4=[0 60];
    colorscale5=[0 60];
    end
    for i=1:num_of_conditions
        if isequal(temp,'trace')
            temp='F';
        end
        [firingRateSmoothing1,sumFiringRateObject1,firingRateSmoothingt,~,radius,posObjects1,sumFiringRateObject_individual]=comparingFiringRateSingleConditionMultiObjects(count_all_m_all_c(:,i)',binsize,[], objpos{i},'events',colorscale1,1,1,objnamehall{i});
%         save([cfolder,'/',groupname{ikkk},'_neuron_comparingCountevents_',nameparts{i},'_binsize',num2str(binsize),'_',temp,'all_obj_data.mat'],'firingRateSmoothing','sumFiringRateObject1','firingRateSmoothing2','radius','posObjects','count_all_m_all_c','obj_all_m_all_c');
        save([cfolder,'/',groupname{ikkk},'_neuron_comparingCountevents_',nameparts{i},'_binsize',num2str(binsize),'_',temp,'all_obj_data.mat'],'firingRateSmoothing1','sumFiringRateObject1','posObjects1','count_all_m_all_c','obj_all_m_all_c');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingCountevents_',nameparts{i},'_binsize',num2str(binsize),'_',temp,'_all_obj.fig'],'fig');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingCountevents_',nameparts{i},'_binsize',num2str(binsize),'_',temp,'_all_obj.tif'],'tif');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingCountevents_',nameparts{i},'_binsize',num2str(binsize),'_',temp,'_all_obj.eps'],'epsc');
        [firingRateSmoothing2,sumFiringRateObject2,firingRateSmoothingt,~,radius,posObjects2,sumFiringRateObject_individual]=comparingFiringRateSingleConditionMultiObjects(countT_all_m_all_c(:,i)',binsize,[], objpos{i},'count Time',colorscale2,1,1,objnamehall{i});
        save([cfolder,'/',groupname{ikkk},'_neuron_comparingCountTime_',nameparts{i},'_binsize',num2str(binsize),'_',temp,'_all_obj_data.mat'],'firingRateSmoothing2','sumFiringRateObject2','posObjects2','countT_all_m_all_c','obj_all_m_all_c');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingCountTime_',nameparts{i},'_binsize',num2str(binsize),'_',temp,'_all_obj.fig'],'fig');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingCountTime_',nameparts{i},'_binsize',num2str(binsize),'_',temp,'_all_obj.tif'],'tif');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingCountTime_',nameparts{i},'_binsize',num2str(binsize),'_',temp,'_all_obj.eps'],'epsc');
        [firingRateSmoothing3,sumFiringRateObject3,firingRateSmoothingt,~,radius,posObjects3,sumFiringRateObject_individual]=comparingFiringRateSingleConditionMultiObjects(firingr_all_m_all_c(:,i)',binsize,[], objpos{i},'firing rate',colorscale3,1,1,objnamehall{i});
        save([cfolder,'/',groupname{ikkk},'_neuron_comparingFiringRate_',nameparts{i},'_binsize',num2str(binsize),'_',temp,'_all_obj_data.mat'],'firingRateSmoothing3','sumFiringRateObject3','posObjects3','firingr_all_m_all_c','obj_all_m_all_c');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingFiringRate_',nameparts{i},'_binsize',num2str(binsize),'_',temp,'_all_obj.fig'],'fig');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingFiringRate_',nameparts{i},'_binsize',num2str(binsize),'_',temp,'_all_obj.tif'],'tif');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingFiringRate_',nameparts{i},'_binsize',num2str(binsize),'_',temp,'_all_obj.eps'],'epsc');
        if ~isequal(temp,'F')        
        [firingRateSmoothing4,sumFiringRateObject4,firingRateSmoothingt,~,radius,posObjects4,sumFiringRateObject_individual]=comparingFiringRateSingleConditionMultiObjects(amplitude_all_m_all_c(:,i)',binsize,[], objpos{i},'Amplitude',colorscale4,1,1,objnamehall{i});
        save([cfolder,'/',groupname{ikkk},'_neuron_comparingAmplitude_',nameparts{i},'_binsize',num2str(binsize),'_',temp,'_all_obj_data.mat'],'firingRateSmoothing4','sumFiringRateObject4','posObjects4','amplitude_all_m_all_c','obj_all_m_all_c');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingAmplitude_',nameparts{i},'_binsize',num2str(binsize),'_',temp,'_all_obj.fig'],'fig');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingAmplitude_',nameparts{i},'_binsize',num2str(binsize),'_',temp,'_all_obj.tif'],'tif');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingAmplitude_',nameparts{i},'_binsize',num2str(binsize),'_',temp,'_all_obj.eps'],'epsc');
        [firingRateSmoothing5,sumFiringRateObject5,firingRateSmoothingt,~,radius,posObjects5,sumFiringRateObject_individual]=comparingFiringRateSingleConditionMultiObjects(amplitude_n_all_m_all_c(:,i)',binsize,[], objpos{i},'Normalized Amplitude',colorscale5,1,1,objnamehall{i});
        save([cfolder,'/',groupname{ikkk},'_neuron_comparingAmplitudeNormalized_',nameparts{i},'_binsize',num2str(binsize),'_',temp,'_all_obj_data.mat'],'firingRateSmoothing5','sumFiringRateObject5','posObjects5','amplitude_n_all_m_all_c','obj_all_m_all_c');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingAmplitudeNormalized_',nameparts{i},'_binsize',num2str(binsize),'_',temp,'_all_obj.fig'],'fig');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingAmplitudeNormalized_',nameparts{i},'_binsize',num2str(binsize),'_',temp,'_all_obj.tif'],'tif');
        saveas(gcf,[cfolder,'/',groupname{ikkk},'_neuron comparingAmplitudeNormalized_',nameparts{i},'_binsize',num2str(binsize),'_',temp,'_all_obj.eps'],'epsc');
        end
        exname=[cfolder,'/',groupname{ikkk},temp,'_neuron comparingData_allobj.xlsx'];
        sname1=[nameparts{i},'_count_events'];
        sname2=[nameparts{i},'_bin_time'];
        sname3=[nameparts{i},'_firing_rate'];
        sname4=[nameparts{i},'_amplitude'];
        sname5=[nameparts{i},'_amplitude_norm'];
        cell1(1,:)=objnamehall{i};
        for tk=1:size(sumFiringRateObject1,2)
            cell1{2,tk}=sumFiringRateObject1(tk);
        end
        xlswrite(exname,cell1,sname1);
        for tk=1:size(sumFiringRateObject2,2)
            cell1{2,tk}=sumFiringRateObject2(tk);
        end
        xlswrite(exname,cell1,sname2);
        for tk=1:size(sumFiringRateObject3,2)
            cell1{2,tk}=sumFiringRateObject3(tk);
        end
        xlswrite(exname,cell1,sname3);
       if ~isequal(temp,'F') 
        for tk=1:size(sumFiringRateObject4,2)
            cell1{2,tk}=sumFiringRateObject4(tk);
        end 
        xlswrite(exname,cell1,sname4);
        for tk=1:size(sumFiringRateObject5,2)
            cell1{2,tk}=sumFiringRateObject5(tk);
        end           
        xlswrite(exname,cell1,sname5);
       end
        end
    end
    end