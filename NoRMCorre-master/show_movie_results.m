%video show
filenamestruct=dir('*.avi');
lengk=sum(~cellfun(@isempty,{filenamestruct.name})); 
row=5;
col=7;

for i=1:lengk
    Yfc{i}=read_file([filenamestruct(i).folder,'\',filenamestruct(i).name]);
end

figure;

for i1=1:size(Yf,3)
for i=1:lengk
    subplot(row,col,i);
    imshow(Yfc{i}(:,:,i1));
    drawnow;
end
end
    