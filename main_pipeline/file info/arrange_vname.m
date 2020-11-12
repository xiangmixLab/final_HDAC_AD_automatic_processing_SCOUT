function [vname_arranged, destination_arranged, orilocation_arranged,ROIlist_arranged,objlist_arranged]=arrange_vname(orilocation,destination,ROIlist,objlist,vname,condition_list_in_order)

vname_arranged=[];
destination_arranged=[];
orilocation_arranged=[];
ROIlist_arranged=[];
objlist_arranged=[];

if isempty(condition_list_in_order)
    uni_vname=unique(vname);
    name_order=[];
    for i=1:length(uni_vname)
        for j=1:length(vname)
            if isequal(uni_vname{i},vname{j})
                name_order(i)=j;
                break;
            end
        end
    end
    [~,idx]=sort(name_order);
    uni_vname=uni_vname(idx);
else
    uni_vname=condition_list_in_order;
end

ctt=1;
for i=1:length(uni_vname)
    for j=1:length(vname)
        if isequal(vname{j},uni_vname{i})
            vname_arranged{ctt,1}=vname{j};
            orilocation_arranged{ctt,1}=orilocation{j};
            destination_arranged{ctt,1}=destination{j};
            if ~isempty(ROIlist)
                ROIlist_arranged{ctt,1}=ROIlist{j};
            end
            if ~isempty(objlist)
                objlist_arranged{ctt,1}=objlist{j};
            end
            ctt=ctt+1;
        end
    end
end
                
            
