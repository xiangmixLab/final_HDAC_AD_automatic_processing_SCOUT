%move timestamp
function timestampnameallt1=timestamp_move(ori,des,tsname)
timestampnameallt1={};
count=1;
for i=1:size(ori,1)
    if ~isempty(ori{i,1})
        try
            filenamet=[ori{i,1},'\timestamp.dat'];
            savedir=[des{i,1},'\',tsname{i}];        
            copyfile(filenamet,savedir);
            timestampnameallt1{i,1}=tsname{i};
        catch
            timestampnameallt1{i,1}=tsname{i};
        end
    end
end