function [mouselookobjectfiringexcel,mouselookobjectfiringrateexcel,mouselookobjectamplitudeexcel,mouselookobjectamplituderateexcel,mouselookobjectcounttimeexcel]=mouse_head_to_obj_cal(objects,numparts,timeindex,binsize,behavcell,countTime,neuronIndividuals_new,behavpos,behavtime,maxbehavROI,thresh,temp,if_mouse_head_toward_object,countTimeThresh,nameparts,nameset,colorscale3,objname,conditionfolder,i,mouselookobjectfiringexcel,mouselookobjectfiringrateexcel,mouselookobjectamplitudeexcel,mouselookobjectamplituderateexcel,mouselookobjectcounttimeexcel)

radius=3;

if numparts(1)==0
kk=0;
else
kk=0;
end
              
for i001=1:size(objects,1)                    
    [firingratemouob,countmouob1,countTimemouob1] = calculatingCellSpatialForSingleData_adapted_mouob(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.trace,1),thresh,temp,if_mouse_head_toward_object(:,i001),[],[],[],countTimeThresh);  %%%bin size suggests to be 15
    [firingratemouob_amp,countmouob1_amp,countTimemouob1_amp] = calculatingCellSpatialForSingleData_adapted_mouob_amp(neuronIndividuals_new{i},behavpos,behavtime,maxbehavROI,binsize,1:size(neuronIndividuals_new{i}.trace,1),thresh,temp,if_mouse_head_toward_object(:,i001),[],[],[],countTimeThresh);
    save([conditionfolder{i},'/','single_cell_firing_profile_look_at_obj.mat'],'firingratemouob','countmouob1','countTimemouob1','objects');
    save([conditionfolder{i},'/','single_cell_amp_profile_look_at_obj.mat'],'firingratemouob_amp','countmouob1_amp','countTimemouob1_amp','objects');

    if sum(objects)~=0 
            range1=zeros(size(countTimemouob1));
            posObjects=ceil(behavcell{1,timeindex(i)+1}.object./binsize);
            %082918 doug's comment: just look for those activities
            %that mouse look at obj, while stay in a range of obj
            h1=size(countTimemouob1,1)-posObjects(i001,2)+1-2;
            h2=size(countTimemouob1,1)-posObjects(i001,2)+1+2;
            w1=posObjects(i001,1)-2;
            w2=posObjects(i001,1)+2;
            if h1<=0
                h1=h1+1;
            end
            if w1<=0
                w1=w1+1;
            end
            if w2>=size(countTimemouob1,2)
                w2=w2-1;
            end
            range1(h1:h2,w1:w2)=1;
            range2=~range1;
            
            %% count time
            for iiiii=1:length(countmouob1)
                mouselookobjectfiringexcel{iiiii+1,1}=iiiii;
                mouselookobjectfiringexcel{iiiii+1,5*(i-1+kk)+3-1}=nameparts{i};
                [~,~,~,~,~,~,~,ct]=comparingFiringRateSingleConditionMultiObjects({countmouob1{iiiii}},binsize,countTime, objects,'firing rate',colorscale3,0,1,objname);
                ct=ct.*range1;
                if isequal(objname{i001,1},nameset{1})
                     mouselookobjectfiringexcel{iiiii+1,5*(i-1+kk)+3+1-1}=sum(sum(ct));
                end
                if isequal(objname{i001,1},nameset{2})
                     mouselookobjectfiringexcel{iiiii+1,5*(i-1+kk)+3+2-1}=sum(sum(ct));
                end
                if isequal(objname{i001,1},nameset{3})
                     mouselookobjectfiringexcel{iiiii+1,5*(i-1+kk)+3+3-1}=sum(sum(ct));
                end
                if isequal(objname{i001,1},nameset{4})
                     mouselookobjectfiringexcel{iiiii+1,5*(i-1+kk)+3+4-1}=sum(sum(ct));
                end                      

                mouselookobjectfiringrateexcel{iiiii+1,1}=iiiii;
                mouselookobjectfiringrateexcel{iiiii+1,5*(i-1+kk)+3-1}=nameparts{i};

                %% rate
                rateobj1=countmouob1{iiiii}./countTimemouob1;
                [~,~,~,~,~,~,~,ct2]=comparingFiringRateSingleConditionMultiObjects({rateobj1},binsize,countTime, objects,'firing rate',colorscale3,0,1,objname);
                ct2=ct2.*range1;
                if isequal(objname{i001,1},nameset{1})
                    mouselookobjectfiringrateexcel{iiiii+1,5*(i-1+kk)+3+1-1}=sum(sum(ct2));%we already indicate the obj nearby points in behav files so no need to add them again
                end
                if isequal(objname{i001,1},nameset{2})
                    mouselookobjectfiringrateexcel{iiiii+1,5*(i-1+kk)+3+2-1}=sum(sum(ct2));%we already indicate the obj nearby points in behav files so no need to add them again
                end
                if isequal(objname{i001,1},nameset{3})
                    mouselookobjectfiringrateexcel{iiiii+1,5*(i-1+kk)+3+3-1}=sum(sum(ct2));%we already indicate the obj nearby points in behav files so no need to add them again
                end
                if isequal(objname{i001,1},nameset{4})
                    mouselookobjectfiringrateexcel{iiiii+1,5*(i-1+kk)+3+4-1}=sum(sum(ct2));%we already indicate the obj nearby points in behav files so no need to add them again
                end   

                %% amplitude
                mouselookobjectamplitudeexcel{iiiii+1,1}=iiiii;
                mouselookobjectamplitudeexcel{iiiii+1,5*(i-1+kk)+3-1}=nameparts{i};
                [~,~,~,~,~,~,~,ct3]=comparingFiringRateSingleConditionMultiObjects({countmouob1_amp{iiiii}},binsize,countTime, objects,'firing rate',colorscale3,0,1,objname);
                ct3=ct3.*range1;
                if isequal(objname{i001,1},nameset{1})
                    mouselookobjectamplitudeexcel{iiiii+1,5*(i-1+kk)+3+1-1}=sum(sum(ct3));%we already indicate the obj nearby points in behav files so no need to add them again
                end
                if isequal(objname{i001,1},nameset{2})
                    mouselookobjectamplitudeexcel{iiiii+1,5*(i-1+kk)+3+2-1}=sum(sum(ct3));%we already indicate the obj nearby points in behav files so no need to add them again
                end
                if isequal(objname{i001,1},nameset{3})
                    mouselookobjectamplitudeexcel{iiiii+1,5*(i-1+kk)+3+3-1}=sum(sum(ct3));%we already indicate the obj nearby points in behav files so no need to add them again
                end
                if isequal(objname{i001,1},nameset{4})
                    mouselookobjectamplitudeexcel{iiiii+1,5*(i-1+kk)+3+4-1}=sum(sum(ct3));%we already indicate the obj nearby points in behav files so no need to add them again
                end  

                %% amplitude norm
                mouselookobjectamplituderateexcel{iiiii+1,1}=iiiii;
                mouselookobjectamplituderateexcel{iiiii+1,5*(i-1+kk)+3-1}=nameparts{i};

                amprateobj1=firingratemouob_amp{iiiii};
                [~,~,~,~,~,~,~,ct4]=comparingFiringRateSingleConditionMultiObjects({amprateobj1},binsize,countTime, objects,'firing rate',colorscale3,0,1,objname);
                ct4=ct4.*range1;
                if isequal(objname{i001,1},nameset{1})
                    mouselookobjectamplituderateexcel{iiiii+1,5*(i-1+kk)+3+1-1}=sum(sum(ct4));%we already indicate the obj nearby points in behav files so no need to add them again
                end
                if isequal(objname{i001,1},nameset{2})
                    mouselookobjectamplituderateexcel{iiiii+1,5*(i-1+kk)+3+2-1}=sum(sum(ct4));%we already indicate the obj nearby points in behav files so no need to add them again
                end
                if isequal(objname{i001,1},nameset{3})
                    mouselookobjectamplituderateexcel{iiiii+1,5*(i-1+kk)+3+3-1}=sum(sum(ct4));%we already indicate the obj nearby points in behav files so no need to add them again
                end
                if isequal(objname{i001,1},nameset{4})
                    mouselookobjectamplituderateexcel{iiiii+1,5*(i-1+kk)+3+4-1}=sum(sum(ct4));%we already indicate the obj nearby points in behav files so no need to add them again
                end  

                %% count time
                mouselookobjectcounttimeexcel{iiiii+1,1}=iiiii;
                mouselookobjectcounttimeexcel{iiiii+1,5*(i-1+kk)+3-1}=nameparts{i};
                ct5=countTimemouob1;
                ct5=ct5.*range1;
                if isequal(objname{i001,1},nameset{1})
                     mouselookobjectcounttimeexcel{iiiii+1,5*(i-1+kk)+3+1-1}=sum(sum(ct5));
                end
                if isequal(objname{i001,1},nameset{2})
                     mouselookobjectcounttimeexcel{iiiii+1,5*(i-1+kk)+3+2-1}=sum(sum(ct5));
                end
                if isequal(objname{i001,1},nameset{3})
                     mouselookobjectcounttimeexcel{iiiii+1,5*(i-1+kk)+3+3-1}=sum(sum(ct5));
                end
                if isequal(objname{i001,1},nameset{4})
                     mouselookobjectcounttimeexcel{iiiii+1,5*(i-1+kk)+3+4-1}=sum(sum(ct5));
                end                
            end
        end
end
            %% show mouse head direction to object points
            if sum(objects)~=0
                tempname=temp;
                idxall=zeros(1,size(neuronIndividuals_new{i}.C,2));
                for id=1:size(thresh,1)
                    thresh1=thresh(id);
                    idx = neuronIndividuals_new{i}.C(id,:)>thresh1;
                    if isequal(tempname,'S')||isempty(tempname)
                       idx = neuronIndividuals_new{i}.S(id,:)>thresh1;
                    end
                    if isequal(tempname,'trace')
                       idx = neuronIndividuals_new{i}.trace(id,:)>thresh1;
                    end
                    if isequal(tempname,'C')
                       idx = neuronIndividuals_new{i}.C(id,:)>thresh1;
                    end
                    idxall=idxall+idx;
                end
                idxall=idxall>0;
                idxall=interp1(neuronIndividuals_new{i}.time,double(idxall),behavtime,'nearest');
                idxall(isnan(idxall))=0;
                idxall=logical(idxall);
                
                figure;
                plot(behavpos(:,1),behavpos(:,2));
                hold on 
                color1={'.r','.b','.g','.m'};
                axis image;
                axis ij;
                for i001=1:size(objects,1)
%                     plot(behavpos(if_mouse_head_toward_object(:,i001)==1,1),behavpos(if_mouse_head_toward_object(:,i001)==1,2),color1{i001},'MarkerSize',15);
                    posObjects=ceil(behavcell{1,timeindex(i)+1}.object./binsize)*binsize;
                    posObjects(:,2)=repmat(max(max(behavpos(:,2))),size(posObjects,1),1)-posObjects(:,2)+1;
%                      neuronCactivity=sum(neuronIndividuals_new{i}.C>thresh,1)>0;
                    if sum(posObjects)~=0
%                         objectrange=((behavpos(:,1)-posObjects(i001,1)).^2+(behavpos(:,2)-posObjects(i001,2)).^2).^0.5<37.5; % 2.5 bin
                        plot(behavpos(if_mouse_head_toward_object(:,i001)==1.*idxall,1),behavpos(if_mouse_head_toward_object(:,i001)==1.*idxall,2),color1{i001},'MarkerSize',15);
%                         plot(behavpos(objectrange,1),behavpos(objectrange,2),color1{i001},'MarkerSize',75);
                        scatter(posObjects(i001,1),posObjects(i001,2),binsize*5,'k','filled')
%                         text(posObjects(i001,1),posObjects(i001,2)-5,[num2str(i001)]);
                    end

                    plot(0,0);
                    title('Positions mouse look at objects');
                    saveas(gcf,[conditionfolder{i},'/','mouse_head_to_object_loc',num2str(binsize),'.fig'],'fig');
                    saveas(gcf,[conditionfolder{i},'/','mouse_head_to_object_loc',num2str(binsize),'.tif'],'tif');
                    saveas(gcf,[conditionfolder{i},'/','mouse_head_to_object_loc',num2str(binsize),'.eps'],'epsc');                  
                end
                
                    figure;
                    plot(behavpos(:,1),behavpos(:,2));
                    hold on 
                    color1={'.r','.b','.g','.m'};
                    axis image;
                    axis ij;
                    for i001=1:size(objects,1)      
                        if sum(posObjects)~=0
                            objectrange=((behavpos(:,1)-posObjects(i001,1)).^2+(behavpos(:,2)-posObjects(i001,2)).^2).^0.5<=37.5; % 2.5 bin
                            plot(behavpos((if_mouse_head_toward_object(:,i001).*double(objectrange)).*idxall==1,1),behavpos((if_mouse_head_toward_object(:,i001).*double(objectrange)).*idxall==1,2),color1{i001},'MarkerSize',15);
    %                         plot(behavpos(objectrange,1),behavpos(objectrange,2),color1{i001},'MarkerSize',15);
    %                         scatter(posObjects(i001,1),max(max(behavpos(:,2)))-posObjects(i001,2)+1,binsize*5,'k','filled')
                            scatter(posObjects(i001,1),posObjects(i001,2),binsize*5,'k','filled')
    %                         text(posObjects(i001,1),posObjects(i001,2)-5,[num2str(i001)]);
                        end

                        plot(0,0);
                        title('Positions mouse look at objects (nearby objects)');
                        saveas(gcf,[conditionfolder{i},'/','mouse_head_to_object_loc_nearby',num2str(binsize),'.fig'],'fig');
                        saveas(gcf,[conditionfolder{i},'/','mouse_head_to_object_loc_nearby',num2str(binsize),'.tif'],'tif');
                        saveas(gcf,[conditionfolder{i},'/','mouse_head_to_object_loc_nearby',num2str(binsize),'.eps'],'epsc');
                    end
            end

