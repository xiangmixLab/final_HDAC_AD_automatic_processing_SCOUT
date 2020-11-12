function [unique_prefix]=prefix_check(orilocation)

cd(orilocation)

all_vid_dir=dir('*.avi');

if mod(length(all_vid_dir),2)>0
    vid_num=length(all_vid_dir)-1;
else
    vid_num=length(all_vid_dir);
end

single_vid_num=vid_num/2;

for i=1:single_vid_num
    possible_vid_postfix{i}=[num2str(i),'.avi'];
end

possible_prefix={};
idx_chosen=floor(length(possible_vid_postfix)/10);
if idx_chosen==0
    idx_chosen=1;
else
    idx_chosen=idx_chosen+10;
end

possible_prefix={};
ctt=1;
for i=1:length(all_vid_dir)
    fname_t=all_vid_dir(i).name;    
    if_idx_fit=strfind(fname_t,possible_vid_postfix{idx_chosen});
    if ~isempty(if_idx_fit)
        possible_prefix{ctt}=fname_t(1:end-length(possible_vid_postfix{length(possible_vid_postfix)}));
        ctt=ctt+1;
    end
end

unique_prefix=unique(possible_prefix);