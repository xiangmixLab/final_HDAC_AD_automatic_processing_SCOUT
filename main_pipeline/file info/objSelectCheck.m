function obj=objSelectCheck(orilocation,behavprefix,objlist,range)

if isempty(range)
    range=[1:length(objlist)];
end

for i=range
    cd(orilocation{i})
    V=VideoReader([behavprefix,'1.avi']);
    obj=objlist{i};
    for p=1:2
      frame=readFrame(V);
    end
    frame=imadjust(rgb2gray(frame));
    imagesc(frame);
    hold on;
    color_table={'r','g','b','y'};
    for j=1:size(obj,1)
        plot(obj(:,1),obj(:,2),'.','MarkerSize',30,'color',color_table{j});
    end
   
    title(num2str(i));
    drawnow;
    pause(1);
end

