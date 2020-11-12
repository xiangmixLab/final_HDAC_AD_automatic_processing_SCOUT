function proj=max_projection_from_video(vidname,method)

postfix=vidname(findstr(vidname,'.'):end);

switch postfix
    case '.avi'
        v=VideoReader(vidname);
        Vid=[];

        ctt=1;
        while hasFrame(v)
            Vid(:,:,ctt)=rgb2gray(readFrame(v));
            ctt=ctt+1;
            disp(num2str(ctt));
        end
    case '.mat'
        load(vidname);
        Vid=Y;
    otherwise
end

switch method
    case 'avg'
        proj=mean(Vid,3);
    case 'max'
        proj=max(Vid,[],3);
    case 'std'
        proj=std(Vid,[],3);
    otherwise
end



