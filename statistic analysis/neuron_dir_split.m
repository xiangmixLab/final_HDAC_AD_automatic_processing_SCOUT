function [neu_dir1,neu_dir2]=neuron_dir_split(neuron,behavtime,dir_label)

% usually dir1 is left/up (dir -1), dir2 is right/down (dir 1)
dir_label_resample1=interp1(behavtime,double(dir_label),neuron.time,'nearest');
dir_label=dir_label_resample1(1:2:end);

if size(neuron.C,2)<length(dir_label)
    dir_label=dir_label(1:size(neuron.C,2));
end
neu_dir1=neuron.copy;
neu_dir2=neuron.copy;

%dir1
neu_dir1.C=neu_dir1.C(:,dir_label==-1);
neu_dir1.S=neu_dir1.S(:,dir_label==-1);
neu_dir1.time=neu_dir1.time(dir_label_resample1==-1);

%dir2
neu_dir2.C=neu_dir2.C(:,dir_label==1);
neu_dir2.S=neu_dir2.S(:,dir_label==1);
neu_dir2.time=neu_dir2.time(dir_label_resample1==1);
