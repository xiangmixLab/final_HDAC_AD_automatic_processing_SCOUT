%% decoding spatial position with place cells

%% 1: load data
load('D:\Yanjun_nn_revision_circle_square\M3424F\neuronIndividuals_new.mat');
load('D:\Yanjun_nn_revision_circle_square\M3424F\circle_results\current_condition_behav.mat');
load('D:\Yanjun_nn_revision_circle_square\M3424F\thresh_and_ROI.mat');

%% 2: firing rate spatial
cond=1; % condition bright
[firingrateS,countS,~,countTimeS] = calculatingCellSpatialForSingleData_Suoqin(neuronIndividuals_new{cond},behavpos,behavtime,maxbehavROI,15,1:size(neuronIndividuals_new{cond}.C,1),thresh,'S',[],[],[0 inf],10);

%% 3: place cell identification 
% [place_cells]=place_cell_identification(firingrate,neuronIndividuals_new{i}.S,behavpos,behavtime,maxbehavROI,thresh)
[place_cells,~,~,~,~,~,~,fr_final] = permutingSpike_adapt_simple_011720(neuronIndividuals_new{cond}.S,neuronIndividuals_new{cond}.time,behavpos,behavtime,maxbehavROI,thresh,[],100,15,'spk',10)

% see firing fields
figure;
for i=1:100
    subplot(10,10,i)
%     fr=filter2DMatrices(firingrateS{i},1);
%     imagesc(fr);
    plot(behavpos(:,1),behavpos(:,2));
    hold on;
    for p=1:2:size(behavpos,1)-1
        if neuronIndividuals_new{2}.S(i,min((p-1)/2+1,size(neuronIndividuals_new{2}.S,2)))>0
            plot(behavpos(p,1),behavpos(p,2),'.','color','r','markerSize',5);
        end
    end
    if ismember(i,place_cells)
        title('place cell');
    else
        title('non');
    end
end

%% 4: population code per bin

for i=1:size(countTimeS,1)
    for j=1:size(countTimeS,2)
        for k=1:length(place_cells)
            fr_population{i,j}(k)=firingrateS{place_cells(k)}(i,j);
        end
    end
end

%% 5: 10s firing rate predict location (wilson mcNaughton 1993)
for i=1:size(behavpos,1)
    plot(behavpos(:,1),behavpos(:,2));
    hold on;
    plot(behavpos(i:i+300,1),behavpos(i:i+300,2),'.','color','r');
    drawnow;
    pause(0.4);
    clf
end