% object name decide
function objnameCell=objnamedec_092719(behavcell,nameset)

    objnameCell=cell(1000,length(behavcell));
    objPosIdx=ones(1000,length(behavcell))*-1;
    
    %% determine overall center
    
    obj=[];
    ctt=1;
    for i=1:length(behavcell)       
        behav=behavcell{i};
        if sum(behav.object(:))>0
            for j=1:size(behav.object,1)
                obj(ctt,:)=behav.object(j,:);
                ctt=ctt+1;
            end
        end
    end

    if ~isempty(obj)&&size(obj,1)<=4
    
        cen_pos=mean(obj,1);

        %% determine relative position of each object
        for i=1:length(behavcell)       
            behav=behavcell{i};
            if sum(behav.object(:))>0
                for j=1:size(behav.object,1)
                    objt=behav.object(j,:);
                    if objt(1)<=cen_pos(1)&&objt(2)<=cen_pos(2)
                        objPosIdx(j,i)=1;
                    end
                    if objt(1)<=cen_pos(1)&&objt(2)>cen_pos(2)
                        objPosIdx(j,i)=2;
                    end
                    if objt(1)>cen_pos(1)&&objt(2)<=cen_pos(2)
                        objPosIdx(j,i)=3;
                    end
                    if objt(1)>cen_pos(1)&&objt(2)>cen_pos(2)
                        objPosIdx(j,i)=4;
                    end                
                end
            end
        end

%         for i=1:length(behavcell)
%             plot(behavcell{i}.object(:,1),behavcell{i}.object(:,2),'.','MarkerSize',30);
%             hold on;
%         end
%         plot(cen_pos(:,1),cen_pos(:,2),'.','MarkerSize',30);
        %% determine object identity
        objPosIdx_positive=objPosIdx(objPosIdx>0);
        num_obj=length(unique(objPosIdx_positive));
        
        ori_obj=-1;
        mov_obj=-1;
        upd_obj=-1;
        nov_obj=-1;
        
        if num_obj==3
            a = unique(objPosIdx_positive);
            out = [histc(objPosIdx_positive(:),a)];
            ori_obj=a(out==max(out));
            
            objPosIdx_positive_rdc=objPosIdx_positive(objPosIdx_positive~=ori_obj);            
            uni_objPosIdx_positive_rdc=unique(objPosIdx_positive_rdc);
            
            idx1=sum(objPosIdx_positive_rdc==uni_objPosIdx_positive_rdc(1));
            idx2=sum(objPosIdx_positive_rdc==uni_objPosIdx_positive_rdc(2));
            
            if idx1<idx2
                mov_obj=objPosIdx_positive_rdc(1);
                upd_obj=objPosIdx_positive_rdc(2);
            else
                mov_obj=objPosIdx_positive_rdc(2);
                upd_obj=objPosIdx_positive_rdc(1); 
            end
        end
        
        if num_obj==4
            
            a = unique(objPosIdx_positive);
            out = [histc(objPosIdx_positive(:),a)];
            ori_obj=a(out==max(out));
            nov_obj=a(out==min(out));
            
            objPosIdx_positive_rdc=objPosIdx_positive(objPosIdx_positive~=ori_obj);
            objPosIdx_positive_rdc=objPosIdx_positive_rdc(objPosIdx_positive_rdc~=nov_obj);
            
            uni_objPosIdx_positive_rdc=unique(objPosIdx_positive_rdc);
            idx1=sum(objPosIdx_positive_rdc==uni_objPosIdx_positive_rdc(1));
            idx2=sum(objPosIdx_positive_rdc==uni_objPosIdx_positive_rdc(2));
            
            
            
            if idx1<idx2
                mov_obj=uni_objPosIdx_positive_rdc(1);
                upd_obj=uni_objPosIdx_positive_rdc(2);
            else
                mov_obj=uni_objPosIdx_positive_rdc(2);
                upd_obj=uni_objPosIdx_positive_rdc(1); 
            end
        end    
        
        %% assign names
        for i=1:size(objPosIdx,1)
            for j=1:size(objPosIdx,2)
                if objPosIdx(i,j)==ori_obj
                    % first name to most frequent obj
                    objnameCell{i,j}=nameset{1};
                end
                if objPosIdx(i,j)==mov_obj
                    % 2nd name to second frequent but appear first obj
                    objnameCell{i,j}=nameset{2};
                end   
                if objPosIdx(i,j)==upd_obj
                    % 3rd name to second frequent but appear later obj
                    objnameCell{i,j}=nameset{3};
                end  
                if objPosIdx(i,j)==nov_obj
                    % 4th name to least frequent obj
                    objnameCell{i,j}=nameset{4};
                end  
                if objPosIdx(i,j)==-1
                    % 4th name to least frequent obj
                    objnameCell{i,j}='null';
                end
            end
        end 
       
    else
        % for experiments like dryland, lots of objs
        ctt=1;
        for j=1:size(objPosIdx,2)
            if sum(behavcell{j}.object(:))>0
                objnameCell{1,j}=num2str(ctt);
                ctt=ctt+1;
            end
        end   
    end  
    
    for i=1:size(objnameCell,1)
        for j=1:size(objnameCell,2)
            if isempty(objnameCell{i,j})
                objnameCell{i,j}='null';
            end
        end
    end
    
    
        