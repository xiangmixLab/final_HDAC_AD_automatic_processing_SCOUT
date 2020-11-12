            
function [count,firingrate,amplitude,amplitude_normalized,countTime,objects]=reversedir(count,firingrate,amplitude,amplitude_normalized,countTime,objects,boxlength,ikk,exp)

%% modify count,counttime,amplitude,normalized amp
if ikk<=4&&exp==10
    for pp=1:length(count)
        countt=count{pp};
        countt=rot90(countt);
        countt=flipud(countt);
        count{pp}=countt;
        firingratet=firingrate{pp};
        firingratet=rot90(firingratet);
        firingratet=flipud(firingratet);
        firingrate{pp}=firingratet;
        amplitudet=amplitude{pp};
        amplitudet=rot90(amplitudet);
        amplitudet=flipud(amplitudet);
        amplitude{pp}=amplitudet;                    
        amplitude_normalizedt= amplitude_normalized{pp};
         amplitude_normalizedt=rot90( amplitude_normalizedt);
         amplitude_normalizedt=flipud( amplitude_normalizedt);
         amplitude_normalized{pp}= amplitude_normalizedt;
    end
end
if exp==10&&(ikk==16||ikk==17)&&i==2
       for pp=1:length(count)
            countt=count{pp};
            countt=fliplr(countt);
            count{pp}=countt;
            firingratet=firingrate{pp};
            firingratet=fliplr(firingratet);
            firingrate{pp}=firingratet;
            amplitudet=amplitude{pp};
            amplitudet=fliplr(amplitudet);
            amplitude{pp}=amplitudet;
            amplitude_normalizedt=amplitude_normalized{pp};
            amplitude_normalizedt=fliplr(amplitude_normalizedt);
            amplitude_normalized{pp}=amplitude_normalizedt;
       end
end
if exp==12&&(ikk==6||ikk==7)&&(i==2||i==3)
       for pp=1:length(count)
            countt=count{pp};
            countt=fliplr(countt);
            count{pp}=countt;
            firingratet=firingrate{pp};
            firingratet=fliplr(firingratet);
            firingrate{pp}=firingratet;
            amplitudet=amplitude{pp};
            amplitudet=fliplr(amplitudet);
            amplitude{pp}=amplitudet;
            amplitude_normalizedt=amplitude_normalized{pp};
            amplitude_normalizedt=fliplr(amplitude_normalizedt);
            amplitude_normalized{pp}=amplitude_normalizedt;                        
       end
end

% if exp==13&&(ikk==2||ikk==4||ikk==6||ikk==8||ikk==10||ikk==12)
%        for pp=1:length(count)
%             countt=count{pp};
%             countt=fliplr(countt);
%             count{pp}=countt;
%             firingratet=firingrate{pp};
%             firingratet=fliplr(firingratet);
%             firingrate{pp}=firingratet;
%             amplitudet=amplitude{pp};
%             amplitudet=fliplr(amplitudet);
%             amplitude{pp}=amplitudet;
%             amplitude_normalizedt=amplitude_normalized{pp};
%             amplitude_normalizedt=fliplr(amplitude_normalizedt);
%             amplitude_normalized{pp}=amplitude_normalizedt;                        
%        end
% end


%% modify counttime
if ikk<=4&&exp==10
    countTime=rot90(countTime);
    countTime=flipud(countTime);
end
if exp==10&&(ikk==16||ikk==17)&&i==2
    countTime=fliplr(countTime);
end
if exp==12&&(ikk==6||ikk==7)&&(i==2||i==3)
    countTime=fliplr(countTime);
end
% if exp==13&&(ikk==2||ikk==4||ikk==6||ikk==8||ikk==10||ikk==12)
%     countTime=fliplr(countTime);
% end


%% modify object
if sum(objects)>0
if ikk<=4&&exp==10
        theta = 90; % to rotate 90 counterclockwise
        R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
        % Rotate your point(s)
        objects = (R*objects')'; % arbitrarily selected
        objects(:,1)=objects(:,1)+boxlength/size(countTime,1)*size(countTime,2);% countTime already flipped
        objects(:,2)=boxlength-objects(:,2);
end

if exp==10&&(ikk==16||ikk==17)&&i==2
        objects(:,1)=boxlength-objects(:,1);
end
if exp==12&&(ikk==6||ikk==7)&&(i==2||i==3)
        objects(:,1)=boxlength-objects(:,1);
end
% if exp==13&&(ikk==2||ikk==4||ikk==6||ikk==8||ikk==10||ikk==12)
%     objects(:,1)=280-objects(:,1);
% end
end