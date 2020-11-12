%cluster neuron ensemble to excel
function data_cell=place_cell_ensemble_analysis_to_excel(foldername,conditionfoldername,objname,nameset,nameparts,exp,t1,group_idx)
data_cell={};

%% foldername: sorted according to group
for ik=1:length(foldername)
    foldername1{group_idx(ik)}=foldername{ik};
end
foldername=foldername1;

%% start
for ik=1:length(foldername)
    for i=1:length(conditionfoldername)
        if exist([foldername{ik},'\',conditionfoldername{i}])
        clusterNum=2;
        measure_num=4;
        for j=1:clusterNum
            data_cell{ik+2,1,j}=foldername{ik};
            data_cell{1,2+(i-1)*measure_num*length(nameset),j}=[nameparts{i},' count events'];
            data_cell{2,2+(i-1)*measure_num*length(nameset),j}='ori';
            data_cell{2,3+(i-1)*measure_num*length(nameset),j}='mov';
            data_cell{2,4+(i-1)*measure_num*length(nameset),j}='upd';
            data_cell{2,5+(i-1)*measure_num*length(nameset),j}='nov';
            
            
            load([foldername{ik},'\',conditionfoldername{i},'\','cluster_ensemble_analysis','\','cluster',num2str(j),'_neuron_comparingCountevents_binsize15data.mat']);
            
            if ~isnan(sumFiringRateObject)
            data_cell{ik+2,2+(i-1)*measure_num*length(nameset),j}=sumFiringRateObject(contains(objname,nameset{1}));
            if isempty(data_cell{ik+2,2+(i-1)*measure_num*length(nameset),j})
                data_cell{ik+2,2+(i-1)*measure_num*length(nameset),j}=0;
            end
            data_cell{ik+2,3+(i-1)*measure_num*length(nameset),j}=sumFiringRateObject(contains(objname,nameset{2}));
            if isempty(data_cell{ik+2,3+(i-1)*measure_num*length(nameset),j})
                data_cell{ik+2,3+(i-1)*measure_num*length(nameset),j}=0;
            end
            data_cell{ik+2,4+(i-1)*measure_num*length(nameset),j}=sumFiringRateObject(contains(objname,nameset{3}));
            if isempty(data_cell{ik+2,4+(i-1)*measure_num*length(nameset),j})
                data_cell{ik+2,4+(i-1)*measure_num*length(nameset),j}=0;
            end
            data_cell{ik+2,5+(i-1)*measure_num*length(nameset),j}=sumFiringRateObject(contains(objname,nameset{4}));
            if isempty(data_cell{ik+2,5+(i-1)*measure_num*length(nameset),j})
                data_cell{ik+2,5+(i-1)*measure_num*length(nameset),j}=0;
            end
            end
            
            
            data_cell{1,6+(i-1)*measure_num*length(nameset),j}=[nameparts{i},' firing rate'];
            data_cell{2,6+(i-1)*measure_num*length(nameset),j}='ori';
            data_cell{2,7+(i-1)*measure_num*length(nameset),j}='mov';
            data_cell{2,8+(i-1)*measure_num*length(nameset),j}='upd';
            data_cell{2,9+(i-1)*measure_num*length(nameset),j}='nov';
            
            load([foldername{ik},'\',conditionfoldername{i},'\','cluster_ensemble_analysis','\','cluster',num2str(j),'_neuron_comparingfiringRate_binsize15data.mat']);
           
            if ~isnan(sumFiringRateObject)
            data_cell{ik+2,6+(i-1)*measure_num*length(nameset),j}=sumFiringRateObject(contains(objname,nameset{1}));
            if isempty(data_cell{ik+2,6+(i-1)*measure_num*length(nameset),j})
                data_cell{ik+2,6+(i-1)*measure_num*length(nameset),j}=0;
            end
            data_cell{ik+2,7+(i-1)*measure_num*length(nameset),j}=sumFiringRateObject(contains(objname,nameset{2}));
            if isempty(data_cell{ik+2,7+(i-1)*measure_num*length(nameset),j})
                data_cell{ik+2,7+(i-1)*measure_num*length(nameset),j}=0;
            end
            data_cell{ik+2,8+(i-1)*measure_num*length(nameset),j}=sumFiringRateObject(contains(objname,nameset{3}));
            if isempty(data_cell{ik+2,8+(i-1)*measure_num*length(nameset),j})
                data_cell{ik+2,8+(i-1)*measure_num*length(nameset),j}=0;
            end
            data_cell{ik+2,9+(i-1)*measure_num*length(nameset),j}=sumFiringRateObject(contains(objname,nameset{4}));
            if isempty(data_cell{ik+2,9+(i-1)*measure_num*length(nameset),j})
                data_cell{ik+2,9+(i-1)*measure_num*length(nameset),j}=0;
            end
            end
            
            
            data_cell{1,10+(i-1)*measure_num*length(nameset),j}=[nameparts{i},' Count Event S'];
            data_cell{2,10+(i-1)*measure_num*length(nameset),j}='ori';
            data_cell{2,11+(i-1)*measure_num*length(nameset),j}='mov';
            data_cell{2,12+(i-1)*measure_num*length(nameset),j}='upd';
            data_cell{2,13+(i-1)*measure_num*length(nameset),j}='nov';
            
            load([foldername{ik},'\',conditionfoldername{i},'\','cluster_ensemble_analysis','\','cluster',num2str(j),'_neuron_comparingCountevents_S_binsize15data_S.mat']);
            
            if ~isnan(sumFiringRateObject)
            data_cell{ik+2,10+(i-1)*measure_num*length(nameset),j}=sumFiringRateObject(contains(objname,nameset{1}));
            if isempty(data_cell{ik+2,10+(i-1)*measure_num*length(nameset),j})
                data_cell{ik+2,10+(i-1)*measure_num*length(nameset),j}=0;
            end
            data_cell{ik+2,11+(i-1)*measure_num*length(nameset),j}=sumFiringRateObject(contains(objname,nameset{2}));
            if isempty(data_cell{ik+2,11+(i-1)*measure_num*length(nameset),j})
                data_cell{ik+2,11+(i-1)*measure_num*length(nameset),j}=0;
            end
            data_cell{ik+2,12+(i-1)*measure_num*length(nameset),j}=sumFiringRateObject(contains(objname,nameset{3}));
            if isempty(data_cell{ik+2,12+(i-1)*measure_num*length(nameset),j})
                data_cell{ik+2,12+(i-1)*measure_num*length(nameset),j}=0;
            end
            data_cell{ik+2,13+(i-1)*measure_num*length(nameset),j}=sumFiringRateObject(contains(objname,nameset{4}));
            if isempty(data_cell{ik+2,13+(i-1)*measure_num*length(nameset),j})
                data_cell{ik+2,13+(i-1)*measure_num*length(nameset),j}=0;
            end 
            end

            data_cell{1,14+(i-1)*measure_num*length(nameset),j}=[nameparts{i},' firing Rate S'];
            data_cell{2,14+(i-1)*measure_num*length(nameset),j}='ori';
            data_cell{2,15+(i-1)*measure_num*length(nameset),j}='mov';
            data_cell{2,16+(i-1)*measure_num*length(nameset),j}='upd';
            data_cell{2,17+(i-1)*measure_num*length(nameset),j}='nov';
            
            load([foldername{ik},'\',conditionfoldername{i},'\','cluster_ensemble_analysis','\','cluster',num2str(j),'_neuron_comparingfiringRate_S_binsize15data_S.mat']);
            
            if ~isnan(sumFiringRateObject)
            data_cell{ik+2,14+(i-1)*measure_num*length(nameset),j}=sumFiringRateObject(contains(objname,nameset{1}));
            if isempty(data_cell{ik+2,14+(i-1)*measure_num*length(nameset),j})
                data_cell{ik+2,14+(i-1)*measure_num*length(nameset),j}=0;
            end
            data_cell{ik+2,15+(i-1)*measure_num*length(nameset),j}=sumFiringRateObject(contains(objname,nameset{2}));
            if isempty(data_cell{ik+2,15+(i-1)*measure_num*length(nameset),j})
                data_cell{ik+2,15+(i-1)*measure_num*length(nameset),j}=0;
            end
            data_cell{ik+2,16+(i-1)*measure_num*length(nameset),j}=sumFiringRateObject(contains(objname,nameset{3}));
            if isempty(data_cell{ik+2,16+(i-1)*measure_num*length(nameset),j})
                data_cell{ik+2,16+(i-1)*measure_num*length(nameset),j}=0;
            end
            data_cell{ik+2,17+(i-1)*measure_num*length(nameset),j}=sumFiringRateObject(contains(objname,nameset{4}));
            if isempty(data_cell{ik+2,17+(i-1)*measure_num*length(nameset),j})
                data_cell{ik+2,17+(i-1)*measure_num*length(nameset),j}=0;
            end  
            end
        end
        end
   end
end

if exp==10
    exname='hdac_injection_data_conclusion_122518_cluster_based.xlsx';
    for l=1:size(data_cell,3)
        xlswrite(['Y:\Lujia\HDAC paper figures\data_conclusion\',exname],data_cell(:,:,l),['cluster',' ',num2str(l)]);
    end
end

if exp==12
    exname='hdac_virus_control_young_data_conclusion_122518_cluster_based.xlsx';
    for l=1:size(data_cell,3)
        xlswrite(['Y:\Lujia\HDAC paper figures\data_conclusion\',exname],data_cell(:,:,l),['cluster',' ',num2str(l)]);
    end
end

if exp==13
    exname=['yanjun_nn_data_conclusion_013019_place_cell_based_',t1,'min.xlsx'];
    for l=1:size(data_cell,3)
        xlswrite([pwd,'\',exname],data_cell(:,:,l),['cluster',' ',num2str(l)]);
    end
end

if exp==14
    exname=['yanjun_nn_data_reversal_conclusion_021119_place_cell_based_',t1,'min.xlsx'];
    for l=1:size(data_cell,3)
        xlswrite([pwd,'\',exname],data_cell(:,:,l),['cluster',' ',num2str(l)]);
    end
end