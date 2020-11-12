%% Generate behav.m
behav = msGenerateVideoObj(pwd,'behavCam1_');

%% Select ROI and HSV for tracking
behav = msSelectPropsForTracking(behav); 

%% TRACK LENGTH
trackLength = 210;%cm  % box experiments
% trackLength = 536;%cm  % linear track experiments %% used scaled track length
% trackLength = 315;%cm  % FN box experiments


%% Select Objects
display('Select Object');
userInput = upper(input('Select Object? (Y/N)','s'));
if (strcmp(userInput,'Y'))
    behav = SelectObject(behav,trackLength);
else
    behav.object=[0,0];
end
 
%%% new code from Tristan 10/06/2016%%%%
%% Extract position
% important variable, which is set according to the video trace
 
%correct time variable  %%05/2017 modification 
d=diff(behav.time);
t=find(d<=0);
while ~isempty(t)
behav.time(t+1)=behav.time(t)+1;
d=diff(behav.time);
t=find(d<=0);
end
behav = msExtractBehavoir_adapted(behav, trackLength); 
% 
% if ~isempty(isnan(behav.position))
%     nanind1=find(isnan(behav.position(:,1)));
%     behav.position(nanind1,1)=behav.position(max(nanind1)+1,1);
%     nanind2=find(isnan(behav.position(:,2)));
%     behav.position(nanind2,2)=behav.position(max(nanind2)+1,2);
% end
% if ~isempty(isnan(behav.positionblue))
%     nanind1=find(isnan(behav.positionblue(:,1)));
%     behav.positionblue(nanind1,1)=behav.positionblue(max(nanind1)+1,1);
%     nanind2=find(isnan(behav.positionblue(:,2)));
%     behav.positionblue(nanind2,2)=behav.positionblue(max(nanind2)+1,2);
% end

%% Check behav trace using the lines below. Include figures into your notes
figure; hist(diff(behav.time))
figure; plot(behav.position(:,1),behav.position(:,2))
axis image
figure; plot(behav.positionblue(:,1),behav.positionblue(:,2))
axis image

%% velocity calculation to see stationary points
velocityx=velocity_kevin_cal(behav.time,behav.position(:,1));
velocityy=velocity_kevin_cal(behav.time,behav.position(:,2));
velocity=(velocityx.^2+velocityy.^2).^0.5;
velosmallthan3=velocity<(3*behav.ROI(1,3)/behav.trackLength);
% behav.time(velosmallthan3)=[];
% behav.position(velosmallthan3)=[];

%% mouse head orientation
% mouseheading=[behav.position(:,1)-behav.positionblue(:,1),behav.position(:,2)-behav.positionblue(:,2)];
% mouse_object_dirction={};
% for i=1:size(behav.object,1)
%     mouse_object_dirction{i}=[repmat(behav.object(i,1),length(behav.positionblue(:,1)),1)-behav.positionblue(:,1),repmat(behav.object(i,2),length(behav.positionblue(:,2)),1)-behav.positionblue(:,2)];
% end
% if_mouse_head_toward_object=zeros(size(mouseheading,1),length(mouse_object_dirction));
% mouse_head_toward_object_angle=zeros(size(mouseheading,1),length(mouse_object_dirction));
% for i=1:size(behav.object,1)
%     for j=1:size(mouseheading,1)
%         ThetaInDegrees = atan2d(norm(cross([mouseheading(j,:) 0],[mouse_object_dirction{i}(j,:) 0])),dot([mouseheading(j,:) 0],[mouse_object_dirction{i}(j,:) 0]));
%         mouse_head_toward_object_angle(j,i)=ThetaInDegrees;
%     end 
% end
% for i=1:size(behav.object,1)
%     for j=1:size(mouseheading,1)-15
%         if abs(mean(mouse_head_toward_object_angle(j:j+14,i)))<=30
%             if_mouse_head_toward_object(j,i)=1;
%         end
%     end 
% end
% if size(if_mouse_head_toward_object,2)>1
% for j=1:size(mouseheading,1)
%         if if_mouse_head_toward_object(j,1)==1&&if_mouse_head_toward_object(j,2)==1
%             L1=((behav.object(1,1)-behav.position(j,1))^2+(behav.object(1,2)-behav.position(j,2))^2)^0.5;
%             L2=((behav.object(2,1)-behav.position(j,2))^2+(behav.object(2,2)-behav.position(j,2))^2)^0.5;
%             if L1>L2
%                 if_mouse_head_toward_object(j,2)=0;
%             end
%             if L1<L2
%                 if_mouse_head_toward_object(j,1)=0;
%             end                
%         end
% end 
% end
% 
% mouse_head_object_cal.mouseheading=mouseheading;
% mouse_head_object_cal.mouse_object_dirction=mouse_object_dirction;
% mouse_head_object_cal.mouse_head_toward_object_angle=mouse_head_toward_object_angle;
% mouse_head_object_cal.if_mouse_head_toward_object=if_mouse_head_toward_object;

% filename=dir();
% for i=1:10
%     if ~isempty(strfind(filename(i).name,'NormCorre'))
%         filename1=filename(i).name(11:end-4);
%     end
% end

filename1='result_L1R2_test_Behav';

save([filename1,'_','Behav.mat'], 'behav', 'mouse_head_object_cal','velosmallthan3')
figure(3);
saveas(gcf,'behavtimeinterval.png');
saveas(gcf,'behavtimeinterval.fig');
figure(4);
saveas(gcf,'behavtrack.png');
saveas(gcf,'behavtrack.fig');
figure(5);
saveas(gcf,'behavtrack2.png');
saveas(gcf,'behavtrack2.fig');
close all;