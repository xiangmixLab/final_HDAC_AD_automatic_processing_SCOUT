function [real_decode_error,y_max_binIdx_up_res,real_behav]=decoding_error_estimate(y_max_binIdx,real_behav)


y_max_binIdx_up_res=[resample(y_max_binIdx(:,1),size(real_behav,1),size(y_max_binIdx(:,1),1)),resample(y_max_binIdx(:,2),size(real_behav,1),size(y_max_binIdx(:,2),1))];

y_max_binIdx_up_res(isnan(real_behav(:,1)),:)=[];
real_behav(isnan(real_behav(:,1)),:)=[];

real_decode_error=abs(real_behav-y_max_binIdx_up_res);
real_decode_error=mean((real_decode_error(:,1).^2+real_decode_error(:,2).^2).^0.5,1);
