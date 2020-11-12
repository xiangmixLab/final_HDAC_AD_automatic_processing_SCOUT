function [y_max_map,y_max_binIdx,y_all]=calcium_spatial_bayesian_decoding_031120(ntemp,tuningMapAll,countAll,countTime,thresh)

% P(A|S)=tuningMapAll
% PA:temporal firing rate
% PS: occupancy map
% P(S|A)=P(A|S)*P(S)/P(A)
   
y_max_map=zeros(size(countTime));
%% 3: position estimate by Bayesian method
nC=ntemp.C;
% PS=countTime/sum(countTime(:));
PS=double(countTime>0)/sum(sum(double(countTime>0)));% PS: occupancy uniform distribution
PA=[];
PS_PA={};
PS_PA_c={};
for i=1:length(countAll)
    PA(i)=sum(countAll{i}(:))/size(nC,2); % firingrate temporal
    PS_PA{i}=PS/PA(i);
    PS_PA_c{i}=PS/(1-PA(i));
end

nC1=nC>thresh;


y_all={};
y_max_binIdx={};
for i=1:size(nC1,2)
    
    y={};
    
    
    p_v=nC1(:,i);
    %calculate estimate per cell
    for j=1:length(p_v)
        tuningMapAll{j}(isnan(tuningMapAll{j}))=0;
        if p_v(j)==1
            y{j}=tuningMapAll{j}/(nansum(tuningMapAll{j}(:))).*PS_PA{j};
        else
            y{j}=(1-tuningMapAll{j})/(nansum(nansum(1-tuningMapAll{j}(:)))).*PS_PA_c{j};
        end
    end
    %calculate overall estimate
    y_all{i}=countTime*0;
    for j=1:length(p_v)
        y_all{i}=y_all{i}+y{j}; %change the y{1}*y{2}*...y{n} to sum. 
    end
    
    [y_max_binIdx{i}(:,2) y_max_binIdx{i}(:,1)]=find(y_all{i}==max(y_all{i}(:)));
    for p=1:size(y_max_binIdx{i},1)
        y_max_map(y_max_binIdx{i}(p,2),y_max_binIdx{i}(p,1))=y_max_map(y_max_binIdx{i}(p,2),y_max_binIdx{i}(p,1))+1;
    end
end
