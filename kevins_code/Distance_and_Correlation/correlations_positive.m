function correlations=correlations_positive(neuron1,neuron2,type)
if ~exist('type','var')||isempty(type)
    type='spearman';
end

if ~isequal(type,'S')
    if ismatrix(neuron1)
        C1=neuron1;
        C2=neuron2;
    else
        C1=neuron1.C;
        C2=neuron2.C;
    end
correlations=zeros(size(C1,1),size(C2,1));
%correlations_binary=zeros(size(C1,1),size(C2,1));
parfor k=1:size(C1,1)*size(C2,1)
%for k=3671
        [i,j]=ind2sub([size(C1,1),size(C2,1)],k);
        %indices1=C1(i,:)>.01*max(C1(i,:));
        %indices2=C2(j,:)>.01*max(C2(j,:));
        indices1=C1(i,:)>=.01*max(C1(i,:));
        indices2=C2(j,:)>=0.01*max(C2(j,:));
        indices=find(indices1&indices2);
        %if length(indices)>0
        %    correlations(k)=max(corr(C1(i,indices)',C2(j,indices)','type',type),corr(C1(i,:)',C2(j,:)','type',type));
            
        %else
            correlations(k)=corr(C1(i,:)',C2(j,:)','type',type);
        %end
        %indices1=C1(i,:)>.1*max(C1(i,:));
        %indices2=C2(j,:)>.1*max(C2(j,:));
        %indices=find(indices1|indices2);
        %C1_binary=zeros(1,length(indices1));
        %C1_binary(indices1)=1;
        %C2_binary=zeros(1,length(indices2));
        %C2_binary(indices2)=1;
        %if length(indices)>0
        %    correlations_binary(k)=corr(C1_binary',C2_binary');
        %end
        
end
else
    if ismatrix(neuron1)
        S1=neuron1;
        S2=neuron2;
    else
        S1=neuron1.S;
        S2=neuron2.S;
    end
    correlations=zeros(size(S1,1),size(S2,1));
    parfor k=1:size(S1,1)*size(S2,1)

        [i,j]=ind2sub([size(S1,1),size(S2,1)],k);
        indices1=S1(i,:)>0;
        std1=std(S1(i,indices1));
        
        indices2=S2(j,:)>0;
        std2=std(S2(j,indices2));
        
        
       
        correlations(k)=corr(gaussian_smooth(S1(i,:)/std1)',gaussian_smooth(S2(j,:)/std2)','type',type);
        
      
 
    end
end
