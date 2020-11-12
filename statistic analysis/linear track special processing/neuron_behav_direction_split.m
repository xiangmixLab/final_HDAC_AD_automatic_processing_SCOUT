function [neuronIndividuals_ndir,neuronIndividuals_pdir,behavcell_ndir,behavcell_pdir]=neuron_behav_direction_split(neuron,neuronfilename,mscamidt,behavcamidt,timestampname,behavcell,behavled)      

%% velocity calculation
for ibehav=1:length(behavcell)
    velo{ibehav}=diff(behavcell{ibehav}.position);
    velo_blue{ibehav}=diff(behavcell{ibehav}.positionblue);         
end

%% track direction: 1-horizontal 2-vertical
direction={};
for ibehav=1:length(behavcell)
    if isequal(behavled,'red')
        x_max_diff=max(behavcell{ibehav}.position(:,1))-min(behavcell{ibehav}.position(:,1));
        y_max_diff=max(behavcell{ibehav}.position(:,2))-min(behavcell{ibehav}.position(:,2));
        if x_max_diff>y_max_diff
            direction{ibehav}=1;
        else
            direction{ibehav}=2;
        end
    else
        x_max_diff=max(behavcell{ibehav}.positionblue(:,1))-min(behavcell{ibehav}.positionblue(:,1));
        y_max_diff=max(behavcell{ibehav}.positionblue(:,2))-min(behavcell{ibehav}.positionblue(:,2));
        if x_max_diff>y_max_diff
            direction{ibehav}=1;
        else
            direction{ibehav}=2;
        end
    end
end

%% left-right (down-up) determine
dir={};
for ibehav=1:length(behavcell)
    switch direction{ibehav}
        case 1
            dir{ibehav}=velo{ibehav}(:,1)>0;
            dir_blue{ibehav}=velo_blue{ibehav}(:,1)>0;
        case 2
            dir{ibehav}=velo{ibehav}(:,2)>0;
            dir_blue{ibehav}=velo_blue{ibehav}(:,2)>0;
        otherwise
    end   
end

%% neuron data split
if isequal(behavled,'red')
    [neuronIndividuals_ndir,neuronIndividuals_pdir] = splittingMUltiConditionNeuronData_adapted_automatic_dirspec(neuron,neuronfilename,mscamidt,behavcamidt,timestampname,dir);    
else
    [neuronIndividuals_ndir,neuronIndividuals_pdir] = splittingMUltiConditionNeuronData_adapted_automatic_dirspec(neuron,neuronfilename,mscamidt,behavcamidt,timestampname,dir_blue);    
end

%% behavior data split
behavcell_ndir=behavcell;
behavcell_pdir=behavcell;
for ibehav=1:length(behavcell)
    behavcell_pdir{ibehav}.position=behavcell_pdir{ibehav}.position(dir{ibehav},:);
    behavcell_pdir{ibehav}.positionblue=behavcell_pdir{ibehav}.positionblue(dir_blue{ibehav},:);
    behavcell_ndir{ibehav}.position=behavcell_ndir{ibehav}.position(~dir{ibehav},:);
    behavcell_ndir{ibehav}.positionblue=behavcell_ndir{ibehav}.positionblue(~dir_blue{ibehav},:);
    if isequal(behavled,'red')
        behavcell_pdir{ibehav}.time=behavcell_pdir{ibehav}.time(dir{ibehav},:);
        behavcell_ndir{ibehav}.time=behavcell_ndir{ibehav}.time(~dir{ibehav},:);  
    else
        behavcell_pdir{ibehav}.time=behavcell_pdir{ibehav}.time(dir_blue{ibehav},:);
        behavcell_ndir{ibehav}.time=behavcell_ndir{ibehav}.time(~dir_blue{ibehav},:); 
    end
end