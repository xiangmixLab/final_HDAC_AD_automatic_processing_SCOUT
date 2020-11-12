function [place_cell_num]=place_non_place_cell_ensemble(exp,foldername,conditionidx,group_idx,t1,namepart)
%place cell ensemble analysis
special_experiment_objname;
tic;
for i=1:length(foldername)
    cd(foldername{i});
    load('foldername_in_use.mat');
    for j=1:length(namepart)
        load('neuronIndividuals_new.mat');
        load([conditionfolder1{conditionidx},'/','place_cells_info_',conditionfolder1{conditionidx}(1:end-16),'_binsize',num2str(15),'.mat']);
        load([conditionfolder{j},'/','current_condition_behav.mat']);
        load('thresh_and_ROI.mat');
        group=ones(1,size(neuronIndividuals_new{1}.C,1))';
        group(place_cells)=2;
        objname=objnamecell(:,j);
% %         
%         if j==4
%             behavpos=behavpos(1:end/2,:);
%             behavtime=behavtime(1:end/2,:);
%             neuronIndividuals_new{j}.C=neuronIndividuals_new{j}.C(:,1:end/2);
%             neuronIndividuals_new{j}.S=neuronIndividuals_new{j}.S(:,1:end/2);
%             neuronIndividuals_new{j}.trace=neuronIndividuals_new{j}.trace(:,1:end/2);
%             neuronIndividuals_new{j}.time=neuronIndividuals_new{j}.time(1:end/2);
%         end

        clustered_neuron_ensemble_analysis(neuronIndividuals_new{j},group,behavpos,behavtime,maxbehavROI,15,thresh,[0.2 10], objects,objname,[0 20],[0 4],[0 10],[0 300],conditionfolder1{j});
    close all;
    place_cell_num(i,j)=sum(group==2);
    end
end
toc;
cd('D:\Yanjun_nn_revision_exp');
nameset={'ori','mov','upd','nov'};
data_cell=place_cell_ensemble_analysis_to_excel(foldername,conditionfolder1,objname,nameset,namepart,exp,t1,group_idx);