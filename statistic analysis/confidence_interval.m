function ci=confidence_interval(data,level)

%http://matlab.cheme.cmu.edu/2011/08/27/introduction-to-statistical-data-analysis/
%https://www.mathworks.com/matlabcentral/answers/159417-how-to-calculate-the-confidence-interval
if length(size(data))>1
    data=reshape(data,size(data,1)*size(data,2),1);
end

alpha = 1 - level;

n = length(data);
data_mean=mean(data(:));
data_std=std(data(:));
data_SEM = data_std/sqrt(n); 

ts = tinv([alpha/2 1-alpha/2],n-1);      % T-Score
ci = data_mean + ts*data_SEM;  %upper and lower boundaries


