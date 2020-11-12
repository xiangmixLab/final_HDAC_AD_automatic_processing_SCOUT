%write conclusion excel sheet
function final_data_collection_ad_new_streamlined_func(foldernamet,namepartst,excelFileName,binsize)
% foldername_hdac_ad;
% % foldernamet=foldernamead3batch;
% % foldernamet=foldernamead_FN;
% % foldernamet=foldernamehdac_virus_b1;
% % foldernamet=foldernamehdac_virus_b2;
% % basicinfo_cell;
% % foldernamet=foldernamead_sc2;
% % foldernamet=foldernamead_sc;
% 
% % foldernamet=foldernamehdac;
% foldernamet=foldernamehdac_new;


resultcell=cell(600,600);

resultcell{2,1}='index';
resultcell{2,2}='batch';
resultcell{2,3}='Injection/Control';
resultcell{2,4}='Mouse';
resultcell{2,5}='DOB';
resultcell{2,6}='Test Date';
resultcell{2,7}='Age';
resultcell{2,8}='Moved Object2';
resultcell{2,9}='Original Object1';
resultcell{2,10}='Total Time';
resultcell{2,11}='Moved-Unmoved';
resultcell{2,12}='Neuron Activitation';
resultcell{2,13}='Behavior';
resultcell{2,14}='Cell';

% conditions={'baseline','training1','training2','training3','update','test'};
% conditions={'circle1','square1','circle2','square2','circle3','square3','circle4','square4'};
% conditions={'baseline','training','test'};
% conditions={'baseline1','baseline2','baseline3','test1_F','test1_FN','test2_F','test2_FN'};
% conditions={'training','update','test'};
conditions=namepartst(1,:);

count=[0,0];  
minn=1;
maxx=length(foldernamet);
sheet_width=116;

lookatobj_con=0;

tic;
for j=minn:maxx
    
    if j==-1
        continue;
    end

    conditionfilename=[foldernamet{j},'\','neuron_comparingFiringRate_averageinfo_placecell_data_binsize',num2str(binsize),'.xlsx'];
    
    for i=1:length(conditions)
        
        resultcell{1,14+(i-1)*sheet_width+1}=conditions{i};
        resultcell{2,14+(i-1)*sheet_width+1}='Firing Events';
        resultcell{2,14+(i-1)*sheet_width+2}=[];
        resultcell{2,14+(i-1)*sheet_width+3}=[];
        resultcell{2,14+(i-1)*sheet_width+4}=[];
        resultcell{3,14+(i-1)*sheet_width+1}='ori';
        resultcell{3,14+(i-1)*sheet_width+2}='mov';
        resultcell{3,14+(i-1)*sheet_width+3}='upd';
        resultcell{3,14+(i-1)*sheet_width+4}='nov';
        
        resultcell{2,14+(i-1)*sheet_width+5}='Sum CountTime';
        resultcell{2,14+(i-1)*sheet_width+6}=[];
        resultcell{2,14+(i-1)*sheet_width+7}=[];
        resultcell{2,14+(i-1)*sheet_width+8}=[];
        resultcell{3,14+(i-1)*sheet_width+5}='ori';
        resultcell{3,14+(i-1)*sheet_width+6}='mov';
        resultcell{3,14+(i-1)*sheet_width+7}='upd';
        resultcell{3,14+(i-1)*sheet_width+8}='nov';
            
        resultcell{2,14+(i-1)*sheet_width+9}='Sum FiringRate';
        resultcell{2,14+(i-1)*sheet_width+10}=[];
        resultcell{2,14+(i-1)*sheet_width+11}=[];
        resultcell{2,14+(i-1)*sheet_width+12}=[];
        resultcell{3,14+(i-1)*sheet_width+9}='ori';
        resultcell{3,14+(i-1)*sheet_width+10}='mov';
        resultcell{3,14+(i-1)*sheet_width+11}='upd';
        resultcell{3,14+(i-1)*sheet_width+12}='nov';
        
        resultcell{2,14+(i-1)*sheet_width+13}='Sum activity';
        resultcell{2,14+(i-1)*sheet_width+14}='Frame Number';
        resultcell{2,14+(i-1)*sheet_width+15}='Total activity/Frame';
        
        resultcell{2,14+(i-1)*sheet_width+16}='Pairwise';
        
        resultcell{2,14+(i-1)*sheet_width+17}='Angle_firing_count_average_by_cell';
        resultcell{2,14+(i-1)*sheet_width+18}=[];
        resultcell{2,14+(i-1)*sheet_width+19}=[];
        resultcell{2,14+(i-1)*sheet_width+20}=[];
        resultcell{3,14+(i-1)*sheet_width+17}='ori';
        resultcell{3,14+(i-1)*sheet_width+18}='mov';
        resultcell{3,14+(i-1)*sheet_width+19}='upd';
        resultcell{3,14+(i-1)*sheet_width+20}='nov';
        
        resultcell{2,14+(i-1)*sheet_width+21}='Angle_firing_rate_average_by_cell';
        resultcell{2,14+(i-1)*sheet_width+22}=[];
        resultcell{2,14+(i-1)*sheet_width+23}=[];
        resultcell{2,14+(i-1)*sheet_width+24}=[];
        resultcell{3,14+(i-1)*sheet_width+21}='ori';
        resultcell{3,14+(i-1)*sheet_width+22}='mov';
        resultcell{3,14+(i-1)*sheet_width+23}='upd';
        resultcell{3,14+(i-1)*sheet_width+24}='nov';
        
        resultcell{2,14+(i-1)*sheet_width+25}='amplitude Data';
        resultcell{3,14+(i-1)*sheet_width+25}='ori';
        resultcell{3,14+(i-1)*sheet_width+26}='mov';
        resultcell{3,14+(i-1)*sheet_width+27}='upd';
        resultcell{3,14+(i-1)*sheet_width+sheet_width}='nov';

        resultcell{2,14+(i-1)*sheet_width+29}='amplitude norm Data';
        resultcell{3,14+(i-1)*sheet_width+30}='ori';
        resultcell{3,14+(i-1)*sheet_width+31}='mov';
        resultcell{3,14+(i-1)*sheet_width+32}='upd';
        resultcell{3,14+(i-1)*sheet_width+sheet_width}='nov';

        resultcell{2,14+(i-1)*sheet_width+33}='Angle_firing_amp_average_by_cell';
        resultcell{2,14+(i-1)*sheet_width+34}=[];
        resultcell{2,14+(i-1)*sheet_width+35}=[];
        resultcell{2,14+(i-1)*sheet_width+36}=[];
        resultcell{3,14+(i-1)*sheet_width+33}='ori';
        resultcell{3,14+(i-1)*sheet_width+34}='mov';
        resultcell{3,14+(i-1)*sheet_width+35}='upd';
        resultcell{3,14+(i-1)*sheet_width+36}='nov';           
        
        resultcell{2,14+(i-1)*sheet_width+37}='Angle_firing_amp_norm_average_by_cell';
        resultcell{2,14+(i-1)*sheet_width+38}=[];
        resultcell{2,14+(i-1)*sheet_width+39}=[];
        resultcell{2,14+(i-1)*sheet_width+40}=[];
        resultcell{3,14+(i-1)*sheet_width+37}='ori';
        resultcell{3,14+(i-1)*sheet_width+38}='mov';
        resultcell{3,14+(i-1)*sheet_width+39}='upd';
        resultcell{3,14+(i-1)*sheet_width+40}='nov';        
        
        resultcell{2,14+(i-1)*sheet_width+41}='Angle_count_time_average_by_cell';
        resultcell{2,14+(i-1)*sheet_width+42}=[];
        resultcell{2,14+(i-1)*sheet_width+43}=[];
        resultcell{2,14+(i-1)*sheet_width+44}=[];
        resultcell{3,14+(i-1)*sheet_width+41}='ori';
        resultcell{3,14+(i-1)*sheet_width+42}='mov';
        resultcell{3,14+(i-1)*sheet_width+43}='upd';
        resultcell{3,14+(i-1)*sheet_width+44}='nov';      
        
        resultcell{2,14+(i-1)*sheet_width+45}='max num of cluster';
        resultcell{2,14+(i-1)*sheet_width+46}='correlation cleanness (KL distance)';
        resultcell{2,14+(i-1)*sheet_width+47}='correlation cleanness (suoqin)';
        
        resultcell{2,14+(i-1)*sheet_width+48}='Angle_not_look_obj_firing_count_average_by_cell';
        resultcell{2,14+(i-1)*sheet_width+49}=[];
        resultcell{2,14+(i-1)*sheet_width+50}=[];
        resultcell{2,14+(i-1)*sheet_width+51}=[];
        resultcell{3,14+(i-1)*sheet_width+48}='ori';
        resultcell{3,14+(i-1)*sheet_width+49}='mov';
        resultcell{3,14+(i-1)*sheet_width+50}='upd';
        resultcell{3,14+(i-1)*sheet_width+51}='nov';

        resultcell{2,14+(i-1)*sheet_width+52}='Angle_not_look_obj_firing_rate_average_by_cell';
        resultcell{2,14+(i-1)*sheet_width+53}=[];
        resultcell{2,14+(i-1)*sheet_width+54}=[];
        resultcell{2,14+(i-1)*sheet_width+55}=[];
        resultcell{3,14+(i-1)*sheet_width+52}='ori';
        resultcell{3,14+(i-1)*sheet_width+53}='mov';
        resultcell{3,14+(i-1)*sheet_width+54}='upd';
        resultcell{3,14+(i-1)*sheet_width+55}='nov';        
        
        resultcell{2,14+(i-1)*sheet_width+56}='Angle_not_look_obj_firing_amp_average_by_cell';
        resultcell{2,14+(i-1)*sheet_width+57}=[];
        resultcell{2,14+(i-1)*sheet_width+58}=[];
        resultcell{2,14+(i-1)*sheet_width+59}=[];
        resultcell{3,14+(i-1)*sheet_width+56}='ori';
        resultcell{3,14+(i-1)*sheet_width+57}='mov';
        resultcell{3,14+(i-1)*sheet_width+58}='upd';
        resultcell{3,14+(i-1)*sheet_width+59}='nov';        
        
        resultcell{2,14+(i-1)*sheet_width+60}='Angle_not_look_obj_firing_amp_norm_average_by_cell';
        resultcell{2,14+(i-1)*sheet_width+61}=[];
        resultcell{2,14+(i-1)*sheet_width+62}=[];
        resultcell{2,14+(i-1)*sheet_width+63}=[];
        resultcell{3,14+(i-1)*sheet_width+60}='ori';
        resultcell{3,14+(i-1)*sheet_width+61}='mov';
        resultcell{3,14+(i-1)*sheet_width+62}='upd';
        resultcell{3,14+(i-1)*sheet_width+63}='nov';        
        
        resultcell{2,14+(i-1)*sheet_width+64}='Angle_not_look_obj_count_time_average_by_cell';
        resultcell{2,14+(i-1)*sheet_width+65}=[];
        resultcell{2,14+(i-1)*sheet_width+66}=[];
        resultcell{2,14+(i-1)*sheet_width+67}=[];
        resultcell{3,14+(i-1)*sheet_width+64}='ori';
        resultcell{3,14+(i-1)*sheet_width+65}='mov';
        resultcell{3,14+(i-1)*sheet_width+66}='upd';
        resultcell{3,14+(i-1)*sheet_width+67}='nov';        

        resultcell{2,14+(i-1)*sheet_width+68}='Travel path length';
        
        resultcell{2,14+(i-1)*sheet_width+69}='Firing Events S';
        resultcell{2,14+(i-1)*sheet_width+70}=[];
        resultcell{2,14+(i-1)*sheet_width+71}=[];
        resultcell{2,14+(i-1)*sheet_width+72}=[];
        resultcell{3,14+(i-1)*sheet_width+69}='ori';
        resultcell{3,14+(i-1)*sheet_width+70}='mov';
        resultcell{3,14+(i-1)*sheet_width+71}='upd';
        resultcell{3,14+(i-1)*sheet_width+72}='nov';
        
        resultcell{2,14+(i-1)*sheet_width+73}='Sum FiringRate S';
        resultcell{2,14+(i-1)*sheet_width+74}=[];
        resultcell{2,14+(i-1)*sheet_width+75}=[];
        resultcell{2,14+(i-1)*sheet_width+76}=[];
        resultcell{3,14+(i-1)*sheet_width+73}='ori';
        resultcell{3,14+(i-1)*sheet_width+74}='mov';
        resultcell{3,14+(i-1)*sheet_width+75}='upd';
        resultcell{3,14+(i-1)*sheet_width+76}='nov';
        
        resultcell{2,14+(i-1)*sheet_width+77}='amplitude Data S';
        resultcell{3,14+(i-1)*sheet_width+77}='ori';
        resultcell{3,14+(i-1)*sheet_width+78}='mov';
        resultcell{3,14+(i-1)*sheet_width+79}='upd';
        resultcell{3,14+(i-1)*sheet_width+80}='nov';
        
        resultcell{3,14+(i-1)*sheet_width+81}='intra';
        resultcell{3,14+(i-1)*sheet_width+82}='inter';

        resultcell{3,14+(i-1)*sheet_width+83}='obj1';
        resultcell{3,14+(i-1)*sheet_width+84}='obj2tr';
        resultcell{3,14+(i-1)*sheet_width+85}='obj2ts';
        
        resultcell{2,14+(i-1)*sheet_width+93}='Sum count events surround';
        resultcell{2,14+(i-1)*sheet_width+94}=[];
        resultcell{2,14+(i-1)*sheet_width+95}=[];
        resultcell{2,14+(i-1)*sheet_width+96}=[];
        resultcell{3,14+(i-1)*sheet_width+93}='ori';
        resultcell{3,14+(i-1)*sheet_width+94}='mov';
        resultcell{3,14+(i-1)*sheet_width+95}='upd';
        resultcell{3,14+(i-1)*sheet_width+96}='nov';
        
        resultcell{2,14+(i-1)*sheet_width+86}='Sum FiringRate surround';
        resultcell{2,14+(i-1)*sheet_width+87}=[];
        resultcell{2,14+(i-1)*sheet_width+88}=[];
        resultcell{2,14+(i-1)*sheet_width+89}=[];
        resultcell{3,14+(i-1)*sheet_width+86}='ori';
        resultcell{3,14+(i-1)*sheet_width+87}='mov';
        resultcell{3,14+(i-1)*sheet_width+88}='upd';
        resultcell{3,14+(i-1)*sheet_width+89}='nov';
        
        resultcell{2,14+(i-1)*sheet_width+97}='Sum amplitudes surround';
        resultcell{2,14+(i-1)*sheet_width+98}=[];
        resultcell{2,14+(i-1)*sheet_width+99}=[];
        resultcell{2,14+(i-1)*sheet_width+100}=[];
        resultcell{3,14+(i-1)*sheet_width+97}='ori';
        resultcell{3,14+(i-1)*sheet_width+98}='mov';
        resultcell{3,14+(i-1)*sheet_width+99}='upd';
        resultcell{3,14+(i-1)*sheet_width+100}='nov';

        resultcell{3,14+(i-1)*sheet_width+90}='obj1total';
        resultcell{3,14+(i-1)*sheet_width+91}='obj2trtotal';
        resultcell{3,14+(i-1)*sheet_width+92}='obj2tstotal';

        resultcell{3,14+(i-1)*sheet_width+83}='obj1';
        resultcell{3,14+(i-1)*sheet_width+84}='obj2tr';
        resultcell{3,14+(i-1)*sheet_width+85}='obj2ts';

        resultcell{2,14+(i-1)*sheet_width+101}='Sum count events S surround';
        resultcell{2,14+(i-1)*sheet_width+102}=[];
        resultcell{2,14+(i-1)*sheet_width+103}=[];
        resultcell{2,14+(i-1)*sheet_width+104}=[];
        resultcell{3,14+(i-1)*sheet_width+101}='ori';
        resultcell{3,14+(i-1)*sheet_width+102}='mov';
        resultcell{3,14+(i-1)*sheet_width+103}='upd';
        resultcell{3,14+(i-1)*sheet_width+104}='nov';
        
        resultcell{2,14+(i-1)*sheet_width+105}='Sum FiringRate S surround';
        resultcell{2,14+(i-1)*sheet_width+106}=[];
        resultcell{2,14+(i-1)*sheet_width+107}=[];
        resultcell{2,14+(i-1)*sheet_width+108}=[];
        resultcell{3,14+(i-1)*sheet_width+105}='ori';
        resultcell{3,14+(i-1)*sheet_width+106}='mov';
        resultcell{3,14+(i-1)*sheet_width+107}='upd';
        resultcell{3,14+(i-1)*sheet_width+108}='nov';
        
        resultcell{2,14+(i-1)*sheet_width+109}='Sum amplitudes S surround';
        resultcell{2,14+(i-1)*sheet_width+110}=[];
        resultcell{2,14+(i-1)*sheet_width+111}=[];
        resultcell{2,14+(i-1)*sheet_width+112}=[];
        resultcell{3,14+(i-1)*sheet_width+109}='ori';
        resultcell{3,14+(i-1)*sheet_width+110}='mov';
        resultcell{3,14+(i-1)*sheet_width+111}='upd';
        resultcell{3,14+(i-1)*sheet_width+112}='nov';

        resultcell{2,14+(i-1)*sheet_width+113}='amplitude norm Data S';
        resultcell{3,14+(i-1)*sheet_width+113}='ori';
        resultcell{3,14+(i-1)*sheet_width+114}='mov';
        resultcell{3,14+(i-1)*sheet_width+115}='upd';
        resultcell{3,14+(i-1)*sheet_width+116}='nov';
        [A,B] = xlsfinfo(conditionfilename);
        
        if any(strcmp(B, 'comparsion_objects'))
            num=xlsread(conditionfilename,'comparsion_objects');

             %cell num
            resultcell{j+3,14}=num(49,15);
            cellnum=num(49,15);
            
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+1}=num(1+(i-1)*3,1);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+2}=num(1+(i-1)*3,2);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+3}=num(1+(i-1)*3,3);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+4}=num(1+(i-1)*3,4);

            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+5}=num(2+(i-1)*3,1);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+6}=num(2+(i-1)*3,2);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+7}=num(2+(i-1)*3,3);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+8}=num(2+(i-1)*3,4);

            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+9}=num(3+(i-1)*3,1);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+10}=num(3+(i-1)*3,2);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+11}=num(3+(i-1)*3,3);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+12}=num(3+(i-1)*3,4);

            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+13}=num(1+(i-1)*3,5);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+14}=num(1+(i-1)*3,6);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+15}=num(1+(i-1)*3,7);
        end
        
        if any(strcmp(B, 'pairwise_correlation'))
            num=xlsread(conditionfilename,'pairwise_correlation');
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+16}=num(i);
        end
        
        
        if any(strcmp(B, 'mouselookobject_firing_count'))      
            num=xlsread(conditionfilename,'mouselookobject_firing_count');
            if ~isempty(num)&&lookatobj_con==1
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+17}=sum(num(:,3+5*(i-1)))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+18}=sum(num(:,4+5*(i-1)))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+19}=sum(num(:,5+5*(i-1)))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+20}=sum(num(:,6+5*(i-1)))/cellnum;
            end
        end
        
        
        if any(strcmp(B, 'mouselookobject_firing_rate'))         
            num=xlsread(conditionfilename,'mouselookobject_firing_rate');
            if ~isempty(num)&&lookatobj_con==1
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+21}=sum(num(:,3+5*(i-1)))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+22}=sum(num(:,4+5*(i-1)))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+23}=sum(num(:,5+5*(i-1)))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+24}=sum(num(:,6+5*(i-1)))/cellnum;
            end
        end
%         num=xlsread(conditionfilename,'comparsion_objects_cells'); 
        
        if any(strcmp(B, 'amplitude_comparsion_objects'))         
            num=xlsread(conditionfilename,'amplitude_comparsion_objects'); 
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+25}=num(1+(i-1)*3,1);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+26}=num(1+(i-1)*3,2);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+27}=num(1+(i-1)*3,3);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+28}=num(1+(i-1)*3,4);
        
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+29}=num(2+(i-1)*3,1);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+30}=num(2+(i-1)*3,2);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+31}=num(2+(i-1)*3,3);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+32}=num(2+(i-1)*3,4);
        end
%         resultcell{3,14+(3-1)*24+60}='test cluster num';
%         num=xlsread(conditionfilename,'cell_cluster'); 
%         resultcell{j-(minn-1)+3,14+(3-1)*24+60}=max(num(:,2));
%         resultcell{j-(minn-1)+3,14+(3-1)*24+61}=max(num(:,3));
%         resultcell{j-(minn-1)+3,14+(3-1)*24+62}=max(num(:,4));
        if any(strcmp(B, 'mouselookobject_firing_amp')) 
            num=xlsread(conditionfilename,'mouselookobject_firing_amp');              
            if ~isempty(num)&&lookatobj_con==1
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+33}=sum(num(:,3+5*(i-1)))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+34}=sum(num(:,4+5*(i-1)))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+35}=sum(num(:,5+5*(i-1)))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+36}=sum(num(:,6+5*(i-1)))/cellnum;
            end
        end
        
        if any(strcmp(B, 'mouselookobject_firing_amp_norm'))
            num=xlsread(conditionfilename,'mouselookobject_firing_amp_norm');         
            if ~isempty(num)&&lookatobj_con==1
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+37}=sum(num(:,3+5*(i-1)))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+38}=sum(num(:,4+5*(i-1)))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+39}=sum(num(:,5+5*(i-1)))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+40}=sum(num(:,6+5*(i-1)))/cellnum;
            end
        end


        if any(strcmp(B, 'mouselookobject_firing_amp_norm'))
            num=xlsread(conditionfilename,'mouselookobject_count_time'); 
            if ~isempty(num)&&lookatobj_con==1
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+41}=sum(num(:,3+5*(i-1)))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+42}=sum(num(:,4+5*(i-1)))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+43}=sum(num(:,5+5*(i-1)))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+44}=sum(num(:,6+5*(i-1)))/cellnum;
            end
        end
        
        
        if any(strcmp(B, 'cell_cluster'))
            num=xlsread(conditionfilename,'cell_cluster'); 
            if ~isempty(num)
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+45}=max(num(:,2+(i-1)));
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+46}=num(end,2+length(conditions)*3+(i-1));
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+47}=num(end,2+length(conditions)*3+3+(i-1));
            end
        end
        

        if any(strcmp(B, 'mouselookobject_firing_count'))        
            num=xlsread(conditionfilename,'mouselookobject_firing_count');
            if ~isempty(num)&&lookatobj_con==1
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+48}=sum(num(:,3+5*(i-1)+20))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+49}=sum(num(:,4+5*(i-1)+20))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+50}=sum(num(:,5+5*(i-1)+20))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+51}=sum(num(:,6+5*(i-1)+20))/cellnum;
            end
        end
%         

        if any(strcmp(B, 'mouselookobject_firing_rate'))        
            num=xlsread(conditionfilename,'mouselookobject_firing_rate'); 
            if ~isempty(num)&&lookatobj_con==1
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+52}=sum(num(:,3+5*(i-1)+20))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+53}=sum(num(:,4+5*(i-1)+20))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+54}=sum(num(:,5+5*(i-1)+20))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+55}=sum(num(:,6+5*(i-1)+20))/cellnum;
            end
        end
%         

        if any(strcmp(B, 'mouselookobject_firing_rate'))        
            num=xlsread(conditionfilename,'mouselookobject_firing_amp');        
            if ~isempty(num)&&lookatobj_con==1
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+56}=sum(num(:,3+5*(i-1)+20))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+57}=sum(num(:,4+5*(i-1)+20))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+58}=sum(num(:,5+5*(i-1)+20))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+59}=sum(num(:,6+5*(i-1)+20))/cellnum;
            end
        end
%         

        if any(strcmp(B, 'mouselookobject_firing_amp_norm'))        
            num=xlsread(conditionfilename,'mouselookobject_firing_amp_norm');        
            if ~isempty(num)&&lookatobj_con==1
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+60}=sum(num(:,3+5*(i-1)+20))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+61}=sum(num(:,4+5*(i-1)+20))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+62}=sum(num(:,5+5*(i-1)+20))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+63}=sum(num(:,6+5*(i-1)+20))/cellnum;
            end
        end
%         

        if any(strcmp(B, 'mouselookobject_count_time'))    
            num=xlsread(conditionfilename,'mouselookobject_count_time');        
            if ~isempty(num)&&lookatobj_con==1
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+64}=sum(num(:,3+5*(i-1)+20))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+65}=sum(num(:,4+5*(i-1)+20))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+66}=sum(num(:,5+5*(i-1)+20))/cellnum;
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+67}=sum(num(:,6+5*(i-1)+20))/cellnum;
            end
        end
        %% travel distance

        if any(strcmp(B, 'comparsion_objects'))    
            num=xlsread(conditionfilename,'comparsion_objects');       
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+68}=num(1+(i-1)*3,8);
        end        
        %% single spike        
        if any(strcmp(B, 'comparsion_objects_single_spike'))    
            num=xlsread(conditionfilename,'comparsion_objects_single_spike');
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+69}=num(1+(i-1)*3,1);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+70}=num(1+(i-1)*3,2);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+71}=num(1+(i-1)*3,3);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+72}=num(1+(i-1)*3,4);

            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+73}=num(3+(i-1)*3,1);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+74}=num(3+(i-1)*3,2);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+75}=num(3+(i-1)*3,3);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+76}=num(3+(i-1)*3,4);
        end
        
        if any(strcmp(B, 'amplitude_comparsion_spike'))    
            num=xlsread(conditionfilename,'amplitude_comparsion_spike');
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+77}=num(1+(i-1)*3,1);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+78}=num(1+(i-1)*3,2);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+79}=num(1+(i-1)*3,3);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+80}=num(1+(i-1)*3,4);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+113}=num(2+(i-1)*3,1);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+114}=num(2+(i-1)*3,2);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+115}=num(2+(i-1)*3,3);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+116}=num(2+(i-1)*3,4);
        end
        
        if any(strcmp(B, 'cell_cluster'))               
            num=xlsread(conditionfilename,'cell_cluster');
            if ~isempty(num)
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+81}=num(end,2+length(conditions)*3+6+(i-1));
                resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+82}=num(end,2+length(conditions)*3+9+(i-1));
            end
        end

        if any(strcmp(B, 'time_close_to_obj'))    
            num=xlsread(conditionfilename,'time_close_to_obj');
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+83}=num(i,1);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+84}=num(i,2);        
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+85}=num(i,3);
        end
        
        if any(strcmp(B, 'time_close_to_obj'))
            num=xlsread(conditionfilename,'time_close_to_obj');
%             resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+90}=num(i,4);
%             resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+91}=num(i,5);        
%             resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+92}=num(i,6);
        end

        if any(strcmp(B, 'comparsion_objects'))            
            num=xlsread(conditionfilename,'comparsion_objects');
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+86}=num(length(conditions)*3+4+(i-1)*3,1);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+87}=num(length(conditions)*3+4+(i-1)*3,2);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+88}=num(length(conditions)*3+4+(i-1)*3,3);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+89}=num(length(conditions)*3+4+(i-1)*3,4);

            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+93}=num(length(conditions)*3+2+(i-1)*3,1);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+94}=num(length(conditions)*3+2+(i-1)*3,2);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+95}=num(length(conditions)*3+2+(i-1)*3,3);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+96}=num(length(conditions)*3+2+(i-1)*3,4);
        end

        if any(strcmp(B, 'amplitude_comparsion_objects'))    
            num=xlsread(conditionfilename,'amplitude_comparsion_objects');
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+97}=num(3+(i-1)*3,1);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+98}=num(3+(i-1)*3,2);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+99}=num(3+(i-1)*3,3);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+100}=num(3+(i-1)*3,4);
        end

        if any(strcmp(B, 'comparsion_objects_single_spike'))    
            num=xlsread(conditionfilename,'comparsion_objects_single_spike');
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+101}=num(length(conditions)*3+2+(i-1)*3,1);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+102}=num(length(conditions)*3+2+(i-1)*3,2);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+103}=num(length(conditions)*3+2+(i-1)*3,3);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+104}=num(length(conditions)*3+2+(i-1)*3,4);

            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+105}=num(length(conditions)*3+4+(i-1)*3,1);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+106}=num(length(conditions)*3+4+(i-1)*3,2);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+107}=num(length(conditions)*3+4+(i-1)*3,3);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+108}=num(length(conditions)*3+4+(i-1)*3,4);
        end
        
        if any(strcmp(B, 'amplitude_comparsion_spike'))    
            num=xlsread(conditionfilename,'amplitude_comparsion_spike');
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+109}=num(3+(i-1)*3,1);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+110}=num(3+(i-1)*3,2);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+111}=num(3+(i-1)*3,3);
            resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+112}=num(3+(i-1)*3,4);
        end

    end
end

xlswrite([excelFileName],resultcell,'sheet1');

toc;