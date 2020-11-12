
addpath(genpath('/Users/suoqinjin/Documents/Yanjun_nn_revision_exp/miniscopeDataAnalysisCode_SJ_Jan2019'))



mice = [mice_saline,mice_CNO,mice_rev_saline,mice_rev_CNO];
corr_offsetAll = [];
for i = 1:length(mice)
    filefolder = fullfile(pwd,mice{i})
    load(fullfile(filefolder,'results',['ensembleMeasures_',mice{i},'.mat'],'FiringRateAll'))
    FiringRateAll = cellfun(@replace_nan, FiringRateAll, repmat( {0}, size(FiringRateAll,1), size(FiringRateAll,2)) , 'UniformOutput', 0);
    corr_offset = zeros(size(FiringRateAll,1),1);
    for j = 1:size(FiringRateAll,1)
        rateMap1 = FiringRateAll{j,1}; rateMap2 = FiringRateAll{j,2};
        cc = xcorr2(rateMap2,rateMap1);
        [max_cc, imax] = max(abs(cc(:)));
        [ypeak, xpeak] = ind2sub(size(cc),imax(1));
        offset = [(ypeak-size(rateMap1,1)) (xpeak-size(rateMap1,2))];
        corr_offset(j) = sqrt(offset(1)^2 + offset(2)^2);
    end
    corr_offsetAll = [corr_offsetAll;corr_offset];
end


corr_offsetAll_shuffled = [];
for i = 1:length(mice)
    filefolder = fullfile(pwd,mice{i})
    load(fullfile(filefolder,'results',['ensembleMeasures_',mice{i},'.mat'],'FiringRateAll'))
    FiringRateAll = cellfun(@replace_nan, FiringRateAll, repmat( {0}, size(FiringRateAll,1), size(FiringRateAll,2)) , 'UniformOutput', 0);
    corr_offset = zeros(N,1);
    for nboot = 1:N
    %    j = randperm(size(FiringRateAll,1),2);
        j = randi(size(FiringRateAll,1),1,2);
        rateMap1 = FiringRateAll{j(1),1}; rateMap2 = FiringRateAll{j(2),2};
        cc = xcorr2(rateMap2,rateMap1);
        [max_cc, imax] = max(abs(cc(:)));
        [ypeak, xpeak] = ind2sub(size(cc),imax(1));
        offset = [(ypeak-size(rateMap1,1)) (xpeak-size(rateMap1,2))];
        corr_offset(nboot) = sqrt(offset(1)^2 + offset(2)^2);
    end
    corr_offsetAll_shuffled = [corr_offsetAll_shuffled;corr_offset];
end

corr_offsetAll = corr_offsetAll*1.5;
corr_offsetAll_shuffled = corr_offsetAll_shuffled*1.5;
figure
cdfplot(corr_offsetAll)
hold on
cdfplot(corr_offsetAll_shuffled)
legend({'Circle vs. Square','shuffled'})
ylabel('Cumulative probability'); xlabel('Shift (cm)')
[~,p] = kstest2(corr_offsetAll,corr_offsetAll_shuffle)





mice_saline = {'M3421F','M3423F','M3427F','M3411','M3414'};
mice_CNO = {'M3425F','M3426F','M3422F','M3424F','M3415','M3412'};
mice_rev_saline = {'M3425F_rev','M3413_rev','M3424F_rev','M3415_rev','M3412_rev'};
mice_rev_CNO = {'M3421F_rev','M3423F_rev','M3422F_rev','M3411_rev','M3414_rev'};

warning('off','all')
mice = mice_rev_CNO;

for i = 1:length(mice)
    cd('/Users/suoqinjin/Documents/Yanjun_nn_revision_exp')
    filefolder = fullfile(pwd,mice{i})
    demo_calciumImagingData_analysis_rev(filefolder,mice{i})
    % demo_calciumImagingData_analysis(filefolder,mice{i})
end

%%%%%%%%%%------- downstream analysis ------------%%%%%%%%%%
%% calculate discrimination index
mice = [mice_saline,mice_CNO,mice_rev_saline,mice_rev_CNO];
for i = 1:length(mice)
    filefolder = fullfile(pwd,mice{i})
    load(fullfile(filefolder,'results',['ensembleMeasures_',mice{i},'.mat']))
    DI.sumFiringRate = calculate_discriminationIndex(sumFiringRateObjectAll);
    DI.sumCountTime = calculate_discriminationIndex(sumCountTimeObjectAll);
    DI.sumCount = calculate_discriminationIndex(sumCountObjectAll);
    DI.sumAmplitude = calculate_discriminationIndex(sumAmplitudeObjectAll);
    
    %     DI.sumFiringRate_individual = calculate_discriminationIndex(sumFiringRateObject_individualAll);
    %     DI.sumCountTime_individual = calculate_discriminationIndex(sumCountTimeObject_individualAll);
    %     DI.sumCount_individual = calculate_discriminationIndex(sumCountObject_individualAll);
    %     DI.sumAmplitude_individual = calculate_discriminationIndex(sumAmplitudeObject_individualAll);
    
    save(fullfile(filefolder,'results',['discriminationIndex_',mice{i},'.mat']), 'DI')
end

mice = [mice_saline,mice_CNO,mice_rev_saline,mice_rev_CNO];
for i = 1:length(mice)
    ensemble_analysis_individualMice(mice{i})
end
mkdir results
measureNames = {'sumFiringRate','sumCountTime','sumCount','sumAmplitude','sumFiringRate_individual','sumCountTime_individual','sumCount_individual','sumAmplitude_individual'};
measureNames = {'sumFiringRate','sumCountTime','sumCount','sumAmplitude'};
% collect all the saline mice
mice = [mice_saline,mice_rev_saline];
DIall = cell2struct(cell(length(measureNames),1),measureNames)
for i = 1:length(mice)
    filefolder = fullfile(pwd,mice{i})
    load(fullfile(filefolder,'results',['discriminationIndex_',mice{i},'_radius3_allCells_sum.mat']))
    %measureNames = fieldnames(DI);
    for j = 1:length(measureNames)
        if i <= length(mice_saline)
            DIall.(char(measureNames(j))) = [DIall.(char(measureNames(j)));DI.(char(measureNames(j)))(2:end)];
        else
            DIall.(char(measureNames(j))) = [DIall.(char(measureNames(j)));DI.(char(measureNames(j)))];
        end
    end
end
DIall_saline = DIall;
save(fullfile(pwd,'results','discriminationIndex_saline.mat'), 'DIall_saline')

% collect all the CNO mice
mice = [mice_CNO,mice_rev_CNO];
DIall = cell2struct(cell(length(measureNames),1),measureNames)
for i = 1:length(mice)
    filefolder = fullfile(pwd,mice{i})
    load(fullfile(filefolder,'results',['discriminationIndex_',mice{i},'_radius3_allCells_sum.mat']))
    %  measureNames = fieldnames(DI);
    for j = 1:length(measureNames)
        if i <= length(mice_CNO)
            DIall.(char(measureNames(j))) = [DIall.(char(measureNames(j)));DI.(char(measureNames(j)))(2:end)];
        else
            DIall.(char(measureNames(j))) = [DIall.(char(measureNames(j)));DI.(char(measureNames(j)))];
        end
    end
end
DIall_CNO = DIall;
save(fullfile(pwd,'results','discriminationIndex_CNO.mat'), 'DIall_CNO')

% box plot showing the comparison of discrimination index between different groups
sessionID = 2; sessionName = 'training';
discriminationIndexComparison(DIall_saline,DIall_CNO,sessionID,sessionName)
sessionID = 3; sessionName = 'testing';
discriminationIndexComparison(DIall_saline,DIall_CNO,sessionID,sessionName)

%% compare the firing rate
mice = [mice_saline,mice_CNO,mice_rev_saline,mice_rev_CNO];
mice = [mice_saline,mice_rev_saline];
sumFiringRateObjectAllAll_saline = [];
for i = 1:length(mice)
    filefolder = fullfile(pwd,mice{i})
    load(fullfile(filefolder,'results',['ensembleMeasures_',mice{i},'_radius3_allCells_sum.mat']))
    sumFiringRateObjectAllAll_saline = [sumFiringRateObjectAllAll_saline;sumFiringRateObjectAll(end-2:end)];
end
mice = [mice_CNO,mice_rev_CNO];
sumFiringRateObjectAllAll_CNO = [];
for i = 1:length(mice)
    filefolder = fullfile(pwd,mice{i})
    load(fullfile(filefolder,'results',['ensembleMeasures_',mice{i},'_radius3_allCells_sum.mat']))
    sumFiringRateObjectAllAll_CNO = [sumFiringRateObjectAllAll_CNO;sumFiringRateObjectAll(end-2:end)];
end

% box plot showing the comparison of discrimination index between different groups
sessionID = 2; sessionName = 'training';
discriminationIndexComparison(DIall_saline,DIall_CNO,sessionID,sessionName)
sessionID = 3; sessionName = 'testing';
discriminationIndexComparison(DIall_saline,DIall_CNO,sessionID,sessionName)

firingRateComparison_object(sumFiringRateObjectAllAll_saline,sumFiringRateObjectAllAll_CNO)

%% comparison of spatial information score and firing rate
sessions = {'baseline2','training','testing'};
condition = 'CNO';
if strcmpi(condition,'Saline')
    mice = [mice_saline,mice_rev_saline];
elseif strcmpi(condition,'CNO')
    mice = [mice_CNO,mice_rev_CNO];
end
InfoScoreAllAll = [];miceIDAllAll = [];MeanFiringRateAllAll = [];
for i = 1:length(mice)
    filefolder = fullfile(pwd,mice{i})
    load(fullfile(filefolder,'results',['InfoScore_',mice{i},'.mat']))
    load(fullfile(filefolder,'results',['FiringRate_',mice{i},'.mat']))
    load(fullfile(filefolder,'results',['place_cells_',mice{i},'.mat']))
    
    % segments = place_cellsAll{length(place_cellsAll)-2};
    segments = 1:size(FiringRateAll,1);
    miceIDAllAll = [miceIDAllAll; ones(length(segments),1)*i];
    
    InfoScoreAllAll = [InfoScoreAllAll;InfoScoreAll(segments,length(place_cellsAll)-1:end)];
    MeanFiringRateAllAll = [MeanFiringRateAllAll;MeanFiringRateAll(segments,length(place_cellsAll)-1:end)];
end
save(fullfile(pwd,'results',['InfoScoreAllAll_',condition,'.mat']), 'InfoScoreAllAll', 'MeanFiringRateAllAll', 'miceIDAllAll')

colors_session = []; show_pvalue = true;
SpatialInfoComparison(InfoScoreAllAll,colors_session,sessions,show_pvalue,'SI',condition) % box plot showing the distribution of info score
SpatialInfoComparison(MeanFiringRateAllAll,colors_session,sessions,show_pvalue,'event rate',condition) % box plot showing the distribution of event rate

load('InfoScoreAllAll_CNO.mat')
InfoScoreAllAll_CNO = InfoScoreAllAll;
MeanFiringRateAllAll_CNO = MeanFiringRateAllAll;
load('InfoScoreAllAll_Saline.mat')
InfoScoreAllAll_Saline = InfoScoreAllAll;
MeanFiringRateAllAll_Saline = MeanFiringRateAllAll;
conditions = {'Saline','CNO'};show_pvalue = 1; measure = 'SI';
colors_conditions = [228,26,28;55,126,184]/255;
SpatialInfoComparison_conditions(InfoScoreAllAll_Saline,InfoScoreAllAll_CNO,colors_conditions,conditions,show_pvalue,measure)

SpatialInfoComparison_conditions(MeanFiringRateAllAll_Saline,MeanFiringRateAllAll_CNO,colors_conditions,conditions,show_pvalue,'event rate')

%% behavior exploration time (10 mins)
DI_behav_CNO = [14.08 -5.24 5.08 9.19 -4.06 -4.48 12.69 5.32 -9.40-2.02 -0.73];
DI_behav_saline = [ 12.21 7.86 19.90 27.54 24.09 15.82 18.00 35.53 27.00 24.54];
sessionID = 3; sessionName = 'testing';
discriminationIndexComparison(DIall_saline,DIall_CNO,sessionID,sessionName)

%% behavior exploration time (5 mins)
DI_behav_saline = [10.12 16.21 25.94 40.04 25.93 21.47 2.25 35.88 27.59 22.05];
DI_behav_CNO  = [10.00 -3.44 21.87 14.43 -10.39 -4.68 14.13 1.69 -15.53 7.40 0.51];
sessionID = 3; sessionName = 'testing';
discriminationIndexComparison(DIall_saline,DIall_CNO,sessionID,sessionName)


hFig = figure('position', [200, 200, 200,200]);
h = boxplot(data,'colors',colors_session,'symbol', '.');

xlim([0.5 size(data,2)+0.5])
set(gca,'Xtick',1:size(data,2))
set(gca,'XtickLabel',sessions,'FontSize',12,'FontName','Arial')
xtickangle(30)
if strcmpi(measure,'SI')
    ylabel([measure,' (Bit / Sec)'],'FontSize',12,'FontName','Arial')
elseif strcmpi(measure,'event rate')
    ylabel(['Ca^{2+} ', measure,' (Hz)'],'FontSize',12,'FontName','Arial')
end
title(['#cells: n = ',num2str(size(data,1))],'FontSize',12,'FontName','Arial')
set(gca,'FontSize',12,'FontName','Arial')


