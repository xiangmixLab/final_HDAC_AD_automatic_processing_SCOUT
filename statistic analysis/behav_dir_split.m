function [bpos_dir1,bpos_dir2,btime_dir1,btime_dir2]=behav_dir_split(behavpos,behavtime,dir_label)

% usually dir1 is left/up (dir -1), dir2 is right/down (dir 1)
%dir1
bpos_dir1=behavpos(dir_label==-1,:);
btime_dir1=behavtime(dir_label==-1,:);

%dir2
bpos_dir2=behavpos(dir_label==1,:);
btime_dir2=behavtime(dir_label==1,:);

