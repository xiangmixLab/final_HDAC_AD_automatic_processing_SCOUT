%HDAC_AD_AUTO behav file load
function [behavcell,smallvelo,behavcellnodata]=HDAC_AD_behavload(behavnamet,num_of_all_individual_conditions,ikk,exp)

%% behav load
sectleng=num_of_all_individual_conditions;
FileNameb=cell(1,sectleng);
PathNameb=cell(1,sectleng);
behavcell=cell(1,sectleng);
headorientationcell=cell(1,sectleng);
smallvelo=cell(1,sectleng);
behavcellnodata=zeros(1,sectleng);

for i=1:sectleng
if ~isempty(behavnamet{ikk,i})
    behavnamet{ikk,i}
    load(behavnamet{ikk,i});
    behavcell{1,i}=behav;
    for j=1:size(behav.object,1)
        if sum(behavcell{1,i}.object(:))>0
            if exp==13||exp==14
                behavcell{1,i}.object(j,1)=behavcell{1,i}.object(j,1)-behav.ROI(1);% object x coordination fix
            end            
        end
    end
    
    if exp==13||exp==14
        % adjust ROI to real box size (behav.trackLength, box length)
        ROI3=behav.ROI(3);
        behav.ROI([1 2 4])=behav.ROI([1 2 4])*behav.trackLength/ROI3;
        behav.ROI(3)=behav.trackLength;

        % adjust object pos to real box size
        behavcell{1,i}.object=behavcell{1,i}.object*behav.trackLength/ROI3;
    end
%     if exist('mouse_head_object_cal')~=0
%         headorientationcell{1,i}=mouse_head_object_cal;
%     end
    if exist('velosmallthan3')~=0
        smallvelo{1,i}=velosmallthan3;
    end
else
    behavcell{1,i}=[];
%     headorientationcell{1,i}=[];
    behavcellnodata(i)=1;
end
end

