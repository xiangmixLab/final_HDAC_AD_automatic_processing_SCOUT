function BatchEndoscopeAuto_adapted_new_GRABsensor(num2read,foldernamestruct,data_shape,mrange)
close all;

% global ssub tsub;
% ssub=3;
% tsub=2;
% num2read=[29100,8995,1728, 8912, 4499, 3104, 1862];% adapted 092118
tic
for i=mrange
    [filepath,name,ext] = fileparts(foldernamestruct{i}) ;
    cd(filepath);
    filename=[foldernamestruct{i}]; %Input filenames for experiment;
    dshape=data_shape{i};

    %% load data
    load(filename);
    
    %% 
    max_proj=max(Y,[],3);

    bright_region=max_proj>0.5*max(max_proj(:));

    average_intensity=[];
    for iP=1:size(Y,3)
        t=squeeze(Y(:,:,iP));
        imagesc(t.*double(bright_region));
        drawnow;
        average_intensity(1,iP)=mean(t(bright_region));
    end

    neuron=Sources2D();
    A=max_proj.*bright_region;
    neuron.A=reshape(A,size(A,1)*size(A,2),1);
    neuron.C=average_intensity;
    neuron.S=C_to_peakS(neuron.C);
    neuron.trace=neuron.C;
    neuron.Cn=max_proj;
    neuron.C_df=neuron.C;
    neuron.imageSize=size(A);
    %% dealt with some neuron 

    Cn=neuron.Cn;
    [neuron.Coor,json_file,centroid] = plot_contours(neuron.A, Cn, 0.8, 0, [], [], 2);
    % 
    % neuron.imageSize(3)=num2read(1);
    % neuron=thresholdNeuron(neuron,0.1);
    % [neuron,deleted_neurons]=Eliminate_Misshapen_adapted(neuron,0.25);
    % [neuron_c,close_neurons_deleted]=further_process_neurons(neuron,0.30);


    saveas(gcf,[[pwd,'\','contours.tif']],'tif')
    saveas(gcf,[[pwd,'\','contours.eps']],'epsc')
    saveas(gcf,[[pwd,'\','contours.fig']],'fig')
    close

    neuron.num2read=num2read{i};
    neuron.imageSize=dshape;
    neuron.centroid=centroid;
    save([pwd,'\','further_processed_neuron_extraction_final_result.mat'],'neuron','-v7.3');

    toc
end