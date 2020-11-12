%hdac_ad_auto parameter set
function [mscamidt,behavcamidt,numparts,nameparts,timestampname,num2readt,baseinfoScoreThreshold,colorscale1,colorscale2,colorscale3]=HDAC_AD_paramset(mscamid,behavcamid,numpartsall,timestampnameallt,num2readall,nameparts1,ikk)

mscamidt=mscamid{1,ikk};
behavcamidt=behavcamid{1,ikk};

numparts=numpartsall{1,ikk};
        
timestampnameall=timestampnameallt(ikk,:);
timestampname={};
countt=1;

for itt=1:length(timestampnameall)
        timestampname{1,countt}=timestampnameall{1,itt};
        countt=countt+1;
end

% numparts(1)=numparts(1);
% numparts(2)=numparts(2);
% numparts(3)=numparts(3);
% 
num2readt=num2readall{1,ikk};

nameparts=nameparts1(ikk,:);

baseinfoScoreThreshold=0;
colorscale1=[0,0];
colorscale2=[0,0];
colorscale3=[0,0];