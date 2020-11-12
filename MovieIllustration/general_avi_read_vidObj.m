function V=general_avi_read_vidObj(vid)

i=1;
V={};
while hasFrame(vid)
    t=readFrame(vid);
    if length(size(t))>=3&&sum(sum(t(:,:,1)-t(:,:,2)))==0&&sum(sum(t(:,:,2)-t(:,:,3)))==0
        V{i}=uint8(rgb2gray(t));
    else
        V{i}=uint8(t);
    end
    disp(num2str(i))
    i=i+1;
end