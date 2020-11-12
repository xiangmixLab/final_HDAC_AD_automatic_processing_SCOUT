% cross_condition_video_alignment
function [num2read,filedir,data_shape]=cross_condition_video_alignment_SCOUT(des,mrange,fix,method)

for i=1:size(des,1)
    if isempty(des{i})
        des{i}='notExist';
    end
end

unique_des=unique(des);
% if max(mrange)>length(unique_des)
%     mrange=[min(mrange):length(unique_des)];
% end
if isempty(mrange)
    mrange=[1:length(unique_des)];
end
for i=mrange
    [n2d,fdir,ds]=autoAlignmentDirectory_adapted_SCOUT(unique_des{i},fix,method);
    num2read{i}=n2d;
    filedir{i}=fdir;
    data_shape{i}=ds;
    disp(['fin ',num2str(i)])
end