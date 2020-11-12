% object name decide
function objnamecell1=objnamedec(behavcell,numparts,nameset)

    objnamecell=cell(4,size(behavcell,2));
    objnamecell1=cell(4,size(numparts,2));
    existance=zeros(size(numparts,2),4);
%     behavpartsind=[];
%     for i=1:length(numparts)
%         for j=1:numparts(i)
%             behavpartsind=[behavpartsind,i];
%         end
%     end
    for i=1:size(behavcell,2)
        if ~isempty(behavcell{i})
        behavt=behavcell{i};
        roi=behavt.ROI;
        objec=behavt.object;
        xcenter=(roi(3)/2);
        ycenter=(roi(4)/2);
        if sum(objec)~=0
        for j=1:size(objec,1)
            if (objec(j,1))<xcenter&&(objec(j,2))<ycenter
                existance(i,1)=existance(i,1)+1;
            end
            if (objec(j,1))<xcenter&&(objec(j,2))>ycenter
                existance(i,2)=existance(i,2)+1;
            end
            if (objec(j,1))>xcenter&&(objec(j,2))>ycenter
                existance(i,3)=existance(i,3)+1;
            end
            if (objec(j,1))>xcenter&&(objec(j,2))<ycenter
                existance(i,4)=existance(i,4)+1;
            end
        end
        end
        end
    end
    
%     existance_sort=sort(existance);
    name=cell(1,4);
    for i=1:4
        existancet=existance(:,i);
        extt=find(existancet~=0);
        if length(extt)==1%smallest
            name{i}=nameset{4};
        end
        if length(extt)>1&&length(extt)<length(existancet)-1
            if min(extt)==length(existancet)-1
                name{i}=nameset{3};
            else
                name{i}=nameset{2};
            end
        end
        if length(extt)>=length(existancet)-1%largest, original
            name{i}=nameset{1};
        end
    end
    
     for i=1:size(behavcell,2)
        if ~isempty(behavcell{i})
        behavt=behavcell{i};
        roi=behavt.ROI;
        objec=behavt.object;
        xcenter=(roi(3)/2);
        ycenter=(roi(4)/2);
        for j=1:size(objec,1)
        if sum(objec)~=0       
            if (objec(j,1))<xcenter&&(objec(j,2))<ycenter
                objnamecell{j,i}=name{1};
            end
            if (objec(j,1))<xcenter&&(objec(j,2))>ycenter
                objnamecell{j,i}=name{2};
            end
            if (objec(j,1))>xcenter&&(objec(j,2))>ycenter
                objnamecell{j,i}=name{3};
            end
            if (objec(j,1))>xcenter&&(objec(j,2))<ycenter
                objnamecell{j,i}=name{4};
            end
         else
            objnamecell{j,i}='null';
        end
        end

        end
     end

     for i=1:size(objnamecell,1)
        for j=1:size(objnamecell,2)
            if isempty(objnamecell{i,j})
            objnamecell{i,j}='null';
            end
        end
     end
     
     count=1;
    for i=1:length(numparts)
         if numparts(i)<=1
         objnamecell1(:,i)=objnamecell(:,count);
         count=count+1;
         end
         if numparts(i)>1
         objnamecell1(:,i)=objnamecell(:,count);
         count=count+numparts(i);
         end
     end