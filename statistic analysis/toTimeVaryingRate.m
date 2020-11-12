function ratee=toTimeVaryingRate(dat,win_t,Fs,mode)

win=win_t*Fs;

switch mode
    case 'gaussian'
        for i=1:size(dat,1)
            ratee(i,:)=nanconv(dat(i,:),fspecial('gaussian',[1 win],win/10));
        end
    otherwise
        for i=1:size(dat,1)
            ratee(i,:)=nanconv(dat(i,:),ones(1,win));
        end
end

