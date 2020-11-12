v=VideoReader('06242019_Mutant2 Post PTZ.wmv')

k=1;
V={};
while hasFrame(v)
    V{k}=readFrame(v);k=k+1;
end

% sav=['vid','.avi'];
% aviobj = VideoWriter(sav,'Uncompressed AVI');
% aviobj.FrameRate=10;
% 
% open(aviobj);
% for it=1:length(V)
%     frame=V{it};
%     writeVideo(aviobj,frame);
% end
mkdir('vid')
for i=1:length(V)
    imwrite(V{i},['vid\',num2str(i),'.tif'],'tif');
end