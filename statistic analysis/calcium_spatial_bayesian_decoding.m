function y_max_binIdx=calcium_spatial_bayesian_decoding(ntemp,behavpos,behavtime,maxbehavROI,binsize,thresh)

[tuningMapAll,countAll,countTimeFrame,countTime] = neuronCtuningMapCal(ntemp,behavpos,behavtime,maxbehavROI,binsize,1:size(ntemp.C,1),thresh,[0 inf],10);
   % P(A|S)=tuningMapAll
   % PA:temporal firing rate
   % PS: occupancy map
   % P(S|A)=P(A|S)*P(S)/P(A)
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

y_max_binIdx=[];
y_all={};
idx_inuse=[];
for i=1:size(nC1,2)
    
    y={};
  
    p_v=nC1(:,i);
    %calculate estimate per cell
    for j=1:length(p_v)
        if p_v(j)==1
            y{j}=tuningMapAll{j}/(nansum(tuningMapAll{j}(:))).*PS_PA{j};
        else
            y{j}=(1-tuningMapAll{j})/(nansum(nansum(1-tuningMapAll{j}(:)))).*PS_PA_c{j};
        end
    end
    %calculate overall estimate
    y_all{i}=countTime*0;
    for j=1:length(p_v)
        y_all{i}=y_all{i}+y{j}; %change the y{1}*y{2}*...y{n} to sum. final result will be exp(y_all)
    end
    
    y_all_v=(reshape(y_all{i},size(y_all{i},1)*size(y_all{i},2),1));
    y_all_v(isnan(y_all_v))=[];
    y_all_v=sort(y_all_v);
    
    y_max_binIdx_t=[];
    [y_max_binIdx_t(:,2),y_max_binIdx_t(:,1)]=find(y_all{i}==y_all_v(end));
    
    ctt=1;
    if i>1
        dist_to_pervious=sum((y_max_binIdx_t-y_max_binIdx(i-1,:)).^2,2);
        y_max_binIdx(i,:)=mean(y_max_binIdx_t(dist_to_pervious==min(dist_to_pervious),:),1);
        
        while true % only accept the next move to be inside 1 bin range
            if abs(y_max_binIdx(i,1)-y_max_binIdx(i-1,1))<=1&&abs(y_max_binIdx(i,2)-y_max_binIdx(i-1,2))<=1
                idx_inuse(i)=length(y_all_v)-ctt;
                break;
            else
                y_max_binIdx_t=[];
                [y_max_binIdx_t(:,2),y_max_binIdx_t(:,1)]=find(y_all{i}==y_all_v(length(y_all_v)-ctt));
                dist_to_pervious=sum((y_max_binIdx_t-y_max_binIdx(i-1,:)).^2,2);
                y_max_binIdx(i,:)=mean(y_max_binIdx_t(dist_to_pervious==min(dist_to_pervious),:),1);
                ctt=ctt+1;
            end
        end
    else
        if size(y_max_binIdx_t,1)==1
            y_max_binIdx(i,:)=y_max_binIdx_t;
        else
            error('check dat')
        end
    end
            
    
end
