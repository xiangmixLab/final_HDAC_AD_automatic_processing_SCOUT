nameparts_hdac_ad;
foldername_hdac_ad;
behavname_hdac_ad;
timestamp_hdac_ad;
camid_hdac_ad;
numpart_hdac_ad;
num2read_hdac_ad;

% namepartst=nameparts_ad_old;
% foldernamet=foldernamead;
% behavnamet=behavnamead;
% timestampnameallt=timestampnamead;
% mscamid=mscamidad;
% behavcamid=behavcamidad;
% numpartsall=numpartad;
% num2readall=num2readad;

% 
% namepartst=namepartsall_sc;
% foldernamet=foldernamead_sc;
% behavnamet=behavnamead3batch_sc;
% timestampnameallt=timestampnamead3batch_sc;
% mscamid=mscamidad3batch_sc;
% behavcamid=behavcamidad3batch_sc;
% numpartsall=numpartad3batch_sc;
% num2readall=num2readad3batch_sc;

% namepartst=namepartsall;
% foldernamet=foldernamead3batch;
% behavnamet=behavnamead3batch;
% timestampnameallt=timestampnamead3batch;
% mscamid=mscamidad3batch;
% behavcamid=behavcamidad3batch;
% numpartsall=numpartad3batch2;
% num2readall=num2readad3batch;
% % 
% namepartst=nameparts_hdac;
% foldernamet=foldernamehdac_virus_b1;
% behavnamet=behavnamehdac_virus_b1;
% timestampnameallt=timestampnamehdac_virus_b1;
% mscamid=mscamidhdac_virus_b1;
% behavcamid=behavcamidhdac_virus_b1;
% numpartsall=numparthdac_virus_b1;
% num2readall=num2readhdac_virus_b1;

% namepartst=nameparts_hdac;
% foldernamet=foldernamehdac_virus_b2;
% behavnamet=behavnamehdac_virus_b2;
% timestampnameallt=timestampnamehdac_virus_b2;
% mscamid=mscamidhdac_virus_b2;
% behavcamid=behavcamidhdac_virus_b2;
% numpartsall=numparthdac_virus_b2;
% num2readall=num2readhdac_virus_b2;
% 

% namepartst=nameparts_FN;
% foldernamet=foldernamead_FN;
% behavnamet=behavnamead_FN;
% timestampnameallt=timestampnamead_FN;
% mscamid=mscamidad_FN;
% behavcamid=behavcamidad_FN;
% numpartsall=numpartad_FN;
% num2readall=num2readad_FN;

% namepartst=namepartsall_sc2;
% foldernamet=foldernamead_sc2;
% behavnamet=behavnamead_sc2;
% timestampnameallt=timestampnamead_sc2;
% mscamid=mscamidad3batch_sc2;
% behavcamid=behavcamidad3batch_sc2;
% numpartsall=numpartad3batch_sc2;
% num2readall=num2readad3batch_sc2;

% namepartst={'baseline','training','test'};
% foldernamet={pwd};
% behavnamet={'8_11_17_OLM_HDAC_Baseline_mouse2_Behav.mat','8_15_17_ObjectLocationMemory_training_mouse2_3min_Behav.mat','8_16_17_ObjectLocationMemory_test_mouse2_5min_Behav.mat'};
% timestampnameallt=timestampnamehdac;
% mscamid={[0,0,0]};
% behavcamid={[1,1,1]};
% numpartsall={[1,1,1]};
% num2readall={[11678,4554,2692,4432]};

% namepartst=nameparts_hdac_old;
% foldernamet=foldernamehdac;
% behavnamet=behavnamehdac;
% timestampnameallt=timestampnamehdac;
% mscamid=mscamidhdac;
% behavcamid=behavcamidhdac;
% numpartsall=numparthdac;
% num2readall=num2readhdac;

namepartst=nameparts_hdac_old;
foldernamet=foldernamehdac_new;
behavnamet=behavnamehdac;
timestampnameallt=timestampnamehdac;
mscamid=mscamidhdac;
behavcamid=behavcamidhdac;
numpartsall=numparthdac;
num2readall=num2readhdac;

threshSpatial=10; %when plotting using neuron.S, 1 is enough; using trace, 5 maybe
threshSpatial_2=10;
threshSpatial_3=10;
behavled='red';

for ikk=[1:length(foldernamet)]  
    if exist([foldernamet{ikk},'\baseline_results'])
    cd([foldernamet{ikk},'\baseline_results'])
    radius_filename_struct=dir('*radius*');
    lengk=sum(~cellfun(@isempty,{radius_filename_struct.name}));
    for j=1:lengk
        fnt=radius_filename_struct(j).name;
        delete(fnt);
    end
    end
    
    if exist([foldernamet{ikk},'\training_results'])
    cd([foldernamet{ikk},'\training_results'])
    radius_filename_struct=dir('*radius*');
    lengk=sum(~cellfun(@isempty,{radius_filename_struct.name}));
    for j=1:lengk
        fnt=radius_filename_struct(j).name;
        delete(fnt);
    end
    end
    
    if exist([foldernamet{ikk},'\testing_results'])
    cd([foldernamet{ikk},'\testing_results'])
    radius_filename_struct=dir('*radius*');
    lengk=sum(~cellfun(@isempty,{radius_filename_struct.name}));
    for j=1:lengk
        fnt=radius_filename_struct(j).name;
        delete(fnt);
    end
    end
end