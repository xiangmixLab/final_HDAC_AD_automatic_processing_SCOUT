function nS_smooth=gaussian_smooth_nS(nS,tleng,Fs)

gaussian_win=gausswin(round(tleng*Fs));

nS_smooth=nS*0;
for i=1:size(nS,1)
    t=nS(i,:);
    t(t<3*std(t,[],2))=0;
    [pks,loc]=findpeaks(t);

    t_pad=zeros(1,length(t)+2*round(length(gaussian_win)/2));
    t_pad(round(length(gaussian_win)/2):round(length(gaussian_win)/2)+length(t)-1)=t;
    
    loc_range={};
    for j=1:length(loc)
        loc_pk=loc(j)+round(length(gaussian_win)/2)-1;
        loc_range{j}=loc_pk-floor(length(gaussian_win)/2)+1:loc_pk+round(length(gaussian_win)/2);
    end
    
    loc_range1=loc_range;
    for j=2:length(loc)
        intersect_value=intersect(loc_range{j-1},loc_range{j});
        if ~isempty(intersect_value)
            unintersect_1=loc_range{j-1}(ismember(loc_range{j-1},intersect_value)==0);
            unintersect_2=loc_range{j}(ismember(loc_range{j},intersect_value)==0);
            p1=[unintersect_1,intersect_value(1:round(length(intersect_value)/2))];
            p2=[intersect_value(round(length(intersect_value)/2)+1:length(intersect_value)),unintersect_2];
            loc_range1{j-1}=intersect(loc_range1{j-1},p1);
            loc_range1{j}=intersect(loc_range1{j},p2);
        else
        end
    end
    
    for j=1:length(loc)      
        g_win=gaussian_win*pks(j)/max(gaussian_win);
        g_win=g_win-min(g_win);
        t_pad(loc_range1{j})=g_win(ismember(loc_range{j},loc_range1{j}))';
    end
    tt=t_pad(round(length(gaussian_win)/2):round(length(gaussian_win)/2)+length(t)-1);
%     t=conv(t,gaussian_win,'same');
    nS_smooth(i,:)=tt;
end
        