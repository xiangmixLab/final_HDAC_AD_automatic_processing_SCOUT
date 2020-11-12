function [folderName,condName,namePartst,behavName,timestampName,msCamid,behavCamid,numpartsall]=file_info_generation(orilocation,destination,timestamp_name,vname,reshape_sign,behavfile_list)
    
    timestampnameallt1=timestamp_move(orilocation,destination,timestamp_name);
    behavname=behavfile_move(orilocation,destination,vname,behavfile_list);

    folderName=unique(destination);
    condName=unique(vname);

    if reshape_sign==1
        namePartst=reshape(vname,length(unique(destination)),length(destination)/length(unique(destination)));
        behavName=reshape(behavname,length(folderName),size(namePartst,2));
        timestampName=reshape(timestampnameallt1,length(unique(destination)),length(destination)/length(unique(destination)));
    else
        namepartst=reshape(vname,length(destination)/length(unique(destination)),length(unique(destination)))';
        behavName=reshape(behavname,size(namepartst,2),length(folderName))';
        timestampName=reshape(timestampnameallt1,length(destination)/length(unique(destination)),length(unique(destination)))';
    end
    % before make the next move, check namepartst and behavname for item order
    % issues
    msCamid=cell(1,length(folderName));
    behavCamid=cell(1,length(folderName));
    numpartsall=cell(1,length(folderName));
    for i=1:size(behavName,1)
        for j=1:size(behavName,2)
            if ~isempty(behavName{i,j})&&exist(behavName{i,j})
                load(behavName{i,j});
                try
                    msCamid{1,i}=[msCamid{1,i},behav.msCam_num];
                catch
                    if behav.camNumber==0
                        msCamid{1,i}=[msCamid{1,i},1];
                    else
                        msCamid{1,i}=[msCamid{1,i},0];
                    end
                end
                behavCamid{1,i}=[behavCamid{1,i},behav.camNumber];
                numpartsall{1,i}=[numpartsall{1,i},~isempty(behavName{i,j})];
            end
        end
    end
