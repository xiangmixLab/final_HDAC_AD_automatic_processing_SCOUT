if exp==1
namepartst=nameparts_ad_old;
foldernamet=foldernamead;
behavnamet=behavnamead;
timestampnameallt=timestampnamead;
mscamid=mscamidad;
behavcamid=behavcamidad;
numpartsall=numpartad;
num2readall=num2readad;
end

if exp==2
namepartst=namepartsall_sc;
foldernamet=foldernamead_sc;
behavnamet=behavnamead3batch_sc;
timestampnameallt=timestampnamead3batch_sc;
mscamid=mscamidad3batch_sc;
behavcamid=behavcamidad3batch_sc;
numpartsall=numpartad3batch_sc;
num2readall=num2readad3batch_sc;
end

if exp==3
namepartst=namepartsall;
foldernamet=foldernamead3batch;
behavnamet=behavnamead3batch;
timestampnameallt=timestampnamead3batch;
mscamid=mscamidad3batch;
behavcamid=behavcamidad3batch;
numpartsall=numpartad3batch2;
num2readall=num2readad3batch;
end
% 
if exp==4
namepartst=nameparts_hdac;
foldernamet=foldernamehdac_virus_b1;
behavnamet=behavnamehdac_virus_b1;
timestampnameallt=timestampnamehdac_virus_b1;
mscamid=mscamidhdac_virus_b1;
behavcamid=behavcamidhdac_virus_b1;
numpartsall=numparthdac_virus_b1;
num2readall=num2readhdac_virus_b1;
end

if exp==5
namepartst=nameparts_hdac;
foldernamet=foldernamehdac_virus_b2;
behavnamet=behavnamehdac_virus_b2;
timestampnameallt=timestampnamehdac_virus_b2;
mscamid=mscamidhdac_virus_b2;
behavcamid=behavcamidhdac_virus_b2;
numpartsall=numparthdac_virus_b2;
num2readall=num2readhdac_virus_b2;
end

if exp==6
namepartst=nameparts_FN;
foldernamet=foldernamead_FN;
behavnamet=behavnamead_FN;
timestampnameallt=timestampnamead_FN;
mscamid=mscamidad_FN;
behavcamid=behavcamidad_FN;
numpartsall=numpartad_FN;
num2readall=num2readad_FN;
end

if exp==7
namepartst=namepartsall_sc2;
foldernamet=foldernamead_sc2;
behavnamet=behavnamead_sc2;
timestampnameallt=timestampnamead_sc2;
mscamid=mscamidad3batch_sc2;
behavcamid=behavcamidad3batch_sc2;
numpartsall=numpartad3batch_sc2;
num2readall=num2readad3batch_sc2;
end

if exp==8
namepartst={'baseline','training','test'};
foldernamet={pwd};
behavnamet={'8_11_17_OLM_HDAC_Baseline_mouse2_Behav.mat','8_15_17_ObjectLocationMemory_training_mouse2_3min_Behav.mat','8_16_17_ObjectLocationMemory_test_mouse2_5min_Behav.mat'};
timestampnameallt=timestampnamehdac;
mscamid={[0,0,0]};
behavcamid={[1,1,1]};
numpartsall={[1,1,1]};
num2readall={[11678,4554,2692,4432]};
end

if exp==9
namepartst=nameparts_hdac_old;
foldernamet=foldernamehdac;
behavnamet=behavnamehdac;
timestampnameallt=timestampnamehdac;
mscamid=mscamidhdac;
behavcamid=behavcamidhdac;
numpartsall=numparthdac;
num2readall=num2readhdac;
end

if exp==10
namepartst=nameparts_hdac_old;
foldernamet=foldernamehdac_new;
behavnamet=behavnamehdac;
timestampnameallt=timestampnamehdac;
mscamid=mscamidhdac;
behavcamid=behavcamidhdac;
numpartsall=numparthdac;
num2readall=num2readhdac;
end

if exp==11
namepartst=nameparts_mut_m6_training_separate;
foldernamet=foldername_mut_m6_training_separate;
behavnamet=behavname_mut_m6;
timestampnameallt=timestampname_mut_m6;
mscamid=mscamid_mut_m6;
behavcamid=behavcamid_mut_m6;
numpartsall=numpart_mut_m6_training_separate;
num2readall=num2read_mut_m6;
end

if exp==12
namepartst=nameparts_hdac_inject_virus_control_young;
foldernamet=foldernamehdac_inject_virus_control_young;
behavnamet=behavnamehdac_inject_virus_control_young;
timestampnameallt=timestampnamehdac_inject_virus_control_young;
mscamid=mscamidhdac_inject_virus_control_young;
behavcamid=behavcamidhdac_inject_virus_control_young;
numpartsall=numparthdac_inject_virus_control_young;
num2readall=num2readhdac_inject_virus_control_young;
end