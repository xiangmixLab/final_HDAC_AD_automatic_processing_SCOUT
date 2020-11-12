%move timestamp
function behavname=behavfile_move(ori,des,vn,behavfile_list)

for i=1:size(ori,1)
    if ~isempty(ori{i,1})
%         try 
            filenamet=[ori{i,1},'\',behavfile_list{i,1}];
            load(filenamet);
            savedir=[des{i,1},'\',vn{i},'_Behav.mat'];
            copyfile(filenamet,savedir);
            disp(num2str(i));
            behavname{i}=[savedir];
%         catch
%             try
%                 filenamet=[ori{i,1},'\',vn{i},'_Behav.mat'];
%                 load(filenamet);
%                 savedir=[des{i,1},'\',filenamet(max(findstr(filenamet,'\'))+1:end)];
%                 copyfile(filenamet,savedir);
%                 disp(num2str(i));
%                 behavname{i}=[des{i,1},'\',filenamet(max(findstr(filenamet,'\'))+1:end)];
%             catch
%                 try
%                     cd(ori{i,1});
%                     filenametstruct=dir('*_Behav.mat');
%                     filenamet=filenametstruct(1).name;
%                     savedir=[des{i,1},'\',vn{i},'_Behav.mat'];
%                     copyfile(filenamet,savedir);
%                     disp(num2str(i));
%                     behavname{i}=savedir;
%                 catch
%                     filenamet=[ori{i,1},'\',vn{i},'_Behav.mat'];
%                     behavname{i}=[des{i,1},'\',filenamet(max(findstr(filenamet,'\'))+1:end)];
%                     disp(['Lack ',ori{i}]);
%                 end
%             end
%         end
    end
end