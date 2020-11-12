function [y_max_map,y_max_binIdx,y_all]=calcium_spatial_bayesian_decoding_031320(ntemp,prob,tuningmap,tuningmap_n,occupancy)

% P(A|S)=tuningMapAll
% PA:temporal firing rate
% PS: occupancy map
% P(S|A)=P(A|S)*P(S)/P(A)
   
y_max_map=zeros(size(tuningmap{1}));
thresh=0.1*max(ntemp.C,[],2);
%% 3: position estimate by Bayesian method
for i=1:size(ntemp.C,1)
    t=ntemp.C(i,:);
    t(t<thresh(i))=0;
    ntemp.C(i,:)=t;
    nC1(i,:)=extract_binary(ntemp.C(i,:), 15, 2);
end



y_all={};
y_max_binIdx={};
for i=1:size(nC1,2)
    
    y={};
    
    p_v=nC1(:,i);
    %calculate estimate per cell
    for j=1:length(p_v)
        tuningmap{j}(isnan(tuningmap{j}))=0;
        tuningmap_n{j}(isnan(tuningmap_n{j}))=0;
        if p_v(j)==1
            y{j}=tuningmap{j}*occupancy/(prob{j});
        else
            y{j}=tuningmap_n{j}*occupancy/(1-prob{j});
        end
    end
    %calculate overall estimate
    y_all{i}=tuningmap{1}*0;
    for j=1:length(p_v)
        y_all{i}=y_all{i}+y{j}; %change the y{1}*y{2}*...y{n} to sum. 
    end
    
    [y_max_binIdx{i}(:,2) y_max_binIdx{i}(:,1)]=find(y_all{i}==max(y_all{i}(:)));
    for p=1:size(y_max_binIdx{i},1)
        y_max_map(y_max_binIdx{i}(p,2),y_max_binIdx{i}(p,1))=y_max_map(y_max_binIdx{i}(p,2),y_max_binIdx{i}(p,1))+1;
    end
end
