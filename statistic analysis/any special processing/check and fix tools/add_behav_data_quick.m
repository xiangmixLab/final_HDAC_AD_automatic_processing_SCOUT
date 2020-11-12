% just add datas...
for ikk=[1:8] 
    cd(foldernamet{ikk})
    for ipp=1:8
    if ~isempty(behavnamet{ikk,ipp})
    load(behavnamet{ikk,ipp});
    disp(behavnamet{ikk,ipp});
    if behav.trackLength==315
        behav.position=behav.position*210/315;
        behav.positionblue=behav.positionblue*210/315; 
        behav.trackLength=210;
    end
    velocityx=velocity_kevin_cal(behav.time,behav.position(:,1));
    velocityy=velocity_kevin_cal(behav.time,behav.position(:,2));
    velocity=(velocityx.^2+velocityy.^2).^0.5;
    velosmallthan3=velocity<(3*behav.ROI(1,3)/behav.trackLength);
    mouseheading=[behav.position(:,1)-behav.positionblue(:,1),behav.position(:,2)-behav.positionblue(:,2)];
    mouse_object_dirction={};
    for i=1:size(behav.object,1)
        mouse_object_dirction{i}=[repmat(behav.object(i,1),length(behav.positionblue(:,1)),1)-behav.positionblue(:,1),repmat(behav.object(i,2),length(behav.positionblue(:,2)),1)-behav.positionblue(:,2)];
    end
    if_mouse_head_toward_object=zeros(size(mouseheading,1),length(mouse_object_dirction));
    mouse_head_toward_object_angle=zeros(size(mouseheading,1),length(mouse_object_dirction));
    for i=1:size(behav.object,1)
        for j=1:size(mouseheading,1)
            ThetaInDegrees = atan2d(norm(cross([mouseheading(j,:) 0],[mouse_object_dirction{i}(j,:) 0])),dot([mouseheading(j,:) 0],[mouse_object_dirction{i}(j,:) 0]));
            mouse_head_toward_object_angle(j,i)=ThetaInDegrees;
        end 
    end
    for i=1:size(behav.object,1)
        for j=1:size(mouseheading,1)-15
            if abs(mean(mouse_head_toward_object_angle(j:j+14,i)))<=15
                if_mouse_head_toward_object(j,i)=1;
            end
        end 
    end
    if size(if_mouse_head_toward_object,2)>1
    for j=1:size(mouseheading,1)
            if if_mouse_head_toward_object(j,1)==1&&if_mouse_head_toward_object(j,2)==1
                L1=((behav.object(1,1)-behav.position(j,1))^2+(behav.object(1,2)-behav.position(j,2))^2)^0.5;
                L2=((behav.object(2,1)-behav.position(j,2))^2+(behav.object(2,2)-behav.position(j,2))^2)^0.5;
                if L1>L2
                    if_mouse_head_toward_object(j,2)=0;
                end
                if L1<L2
                    if_mouse_head_toward_object(j,1)=0;
                end                
            end
    end 
    end

    mouse_head_object_cal.mouseheading=mouseheading;
    mouse_head_object_cal.mouse_object_dirction=mouse_object_dirction;
    mouse_head_object_cal.mouse_head_toward_object_angle=mouse_head_toward_object_angle;
    mouse_head_object_cal.if_mouse_head_toward_object=if_mouse_head_toward_object;
    delete(behavnamet{ikk,ipp});
    save(behavnamet{ikk,ipp},'behav', 'mouse_head_object_cal','velosmallthan3');
    clear behav mouse_head_object_cal velosmallthan3
end
end
end