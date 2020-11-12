%HDAC_AD_AUTO behav file load
function [headorientationcell,in_use_objects,unique_obj_name_map]=HDAC_AD_headtoobj(behavcell,num_of_all_individual_conditions,ikk,objnamecell,exp,maxbehavROI)

%% behav load
sectleng=num_of_all_individual_conditions;
headorientationcell=cell(1,sectleng);
in_use_objects={};
unique_obj_name_map=[];
%% all possible obj locations
all_possible_objects={};
for i=1:sectleng
    if ~isempty(behavcell{i})
        if sum(behavcell{i}.object(:))>0
            for j=1:size(behavcell{i}.object,1)
                all_possible_objects{j,i}=behavcell{i}.object(j,:);
            end
        end
    end
end

if ~isempty(all_possible_objects)
unique_obj_name=unique(objnamecell);

for i=1:length(unique_obj_name)
    if isequal(unique_obj_name{i},'null')
        nullsign=i;
    end
end

unique_obj_name(nullsign)=[];
unique_obj_name_map=ones(size(all_possible_objects))*-1;

for i=1:size(all_possible_objects,1)
    for j=1:size(all_possible_objects,2)
        for k=1:length(unique_obj_name)
            if isequal(objnamecell{i,j},unique_obj_name{k})
                unique_obj_name_map(i,j)=k;
            end
        end
    end
end


% kt=unique_obj_name_map(:,3);
% kt(kt==1)=3;
if ikk==8&&exp==10
    kt(kt==3)=1;
    unique_obj_name_map(:,3)=kt;
end
% unique_obj_name_map(:,3)=kt;


unique_obj_name_map_unique=unique(unique_obj_name_map);
for i=1:length(unique_obj_name_map_unique)
    in_use_objects{i}=mean(cell2mat(all_possible_objects(unique_obj_name_map==unique_obj_name_map_unique(i))),1);
end
if isempty((in_use_objects{1}))
    in_use_objects(1)=[];% the first one may be -1
end

% in_use_objects_mat=cell2mat(in_use_objects');
in_use_objects_mat_all=cell(length(in_use_objects),sectleng);
for l1=1:size(unique_obj_name_map,1)
for l2=1:size(unique_obj_name_map,2) 
    if unique_obj_name_map(l1,l2)~=-1
        in_use_objects_mat_all{l1,l2}=in_use_objects{unique_obj_name_map(l1,l2)};
    end       
end
end

all_obj_idx=[1:length(in_use_objects)];
for l1=1:size(in_use_objects_mat_all,2)
ct=1;
% if isempty(in_use_objects_mat_all{1,l1})
%     for l2=1:size(in_use_objects_mat_all,1) 
%         if isempty(in_use_objects_mat_all{l2,l1})
%             in_use_objects_mat_all{l2,l1}=in_use_objects{ct};
%             ct=ct+1;
%         end       
%     end
% else
% end    
    current_col=unique_obj_name_map(:,l1);
    current_col(length(current_col)+1:length(all_obj_idx))=-1;
    missing_idx=setdiff(all_obj_idx,current_col);
    missing_idx(missing_idx==-1)=[];
    for l2=1:size(in_use_objects_mat_all,1) 
        if isempty(in_use_objects_mat_all{l2,l1})
            in_use_objects_mat_all{l2,l1}=in_use_objects{missing_idx(ct)};
            unique_obj_name_map(l2,l1)=missing_idx(ct);
            ct=ct+1;
        end       
    end

end
%% generate heading to obj data all conditions

for p=1:sectleng
    
    if ~isempty(behavcell{p})
        in_use_objects_mat=cell2mat(in_use_objects_mat_all(:,p));
        in_use_objects_mat(:,2)=behavcell{p}.ROI(2)+behavcell{p}.ROI(4)-in_use_objects_mat(:,2);% coordination correction

        mouseheading=[behavcell{p}.position(:,1)-behavcell{p}.positionblue(:,1),behavcell{p}.position(:,2)-behavcell{p}.positionblue(:,2)];
        mouse_object_dirction={};
        for i=1:size(in_use_objects_mat,1)
            mouse_object_dirction{i}=[repmat(in_use_objects_mat(i,1),length(behavcell{p}.positionblue(:,1)),1)-behavcell{p}.positionblue(:,1),repmat(in_use_objects_mat(i,2),length(behavcell{p}.positionblue(:,2)),1)-behavcell{p}.positionblue(:,2)];
        end
        if_mouse_head_toward_object=zeros(size(mouseheading,1),length(mouse_object_dirction));
        mouse_head_toward_object_angle=zeros(size(mouseheading,1),length(mouse_object_dirction));
        for i=1:size(in_use_objects_mat,1)
            for j=1:size(mouseheading,1)
                ThetaInDegrees = atan2d(norm(cross([mouseheading(j,:) 0],[mouse_object_dirction{i}(j,:) 0])),dot([mouseheading(j,:) 0],[mouse_object_dirction{i}(j,:) 0]));
%                 ThetaInDegrees = ;               
                mouse_head_toward_object_angle(j,i)=ThetaInDegrees;
            end 
        end
        for i=1:size(in_use_objects_mat,1)
            for j=1:size(mouseheading,1)-15
                if abs(mean(mouse_head_toward_object_angle(j:j+14,i)))<=30
                    if_mouse_head_toward_object(j,i)=1;
                end
            end 
        end
        if size(if_mouse_head_toward_object,2)>1
        L=[];
        for j=1:size(mouseheading,1)
                if sum(if_mouse_head_toward_object(j,:))>1
                    for l11=1:size(if_mouse_head_toward_object,2)
                        L(l11,1)=((in_use_objects_mat(l11,1)-behavcell{p}.position(j,1))^2+(in_use_objects_mat(l11,2)-behavcell{p}.position(j,2))^2)^0.5;
                    end
                        if_mouse_head_toward_object(j,:)=0;  
                        if_mouse_head_toward_object(j,find(L==min(L)))=1;  
                end
        end 
        end

        mouse_head_object_cal.mouseheading=mouseheading;
        mouse_head_object_cal.mouse_object_dirction=mouse_object_dirction;
        mouse_head_object_cal.mouse_head_toward_object_angle=mouse_head_toward_object_angle;
        mouse_head_object_cal.if_mouse_head_toward_object=if_mouse_head_toward_object;
        headorientationcell{p}=mouse_head_object_cal;
    end
end
end 