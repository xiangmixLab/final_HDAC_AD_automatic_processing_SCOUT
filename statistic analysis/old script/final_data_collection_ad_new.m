%write conclusion excel sheet

foldername_hdac_ad;
% foldernamet=foldernamead3batch;
% foldernamet=foldernamead_FN;
% foldernamet=foldernamehdac_virus_b1;
% foldernamet=foldernamehdac_virus_b2;
% basicinfo_cell;
% foldernamet=foldernamead_sc2;
% foldernamet=foldernamead_sc;

% foldernamet=foldernamehdac;
foldernamet=foldernamehdac_new;
% foldernamet=foldernamead;


resultcell=cell(100,100);

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
conditions={'baseline','training','test'};
% conditions={'baseline1','baseline2','baseline3','test1_F','test1_FN','test2_F','test2_FN'};
% conditions={'training','update','test'};


count=[0,0];  
minn=1;
maxx=length(foldernamet);
sheet_width=68;
for j=minn:maxx
    
    if j==-1 || j==10
        continue;
    end

    conditionfilename=[foldernamet{j},'\','neuron_comparingFiringRate_averageinfo_placecell_data_binsize15.xlsx'];
    
    for i=1:length(conditions)
        
        
        num=xlsread(conditionfilename,'comparsion_objects');
        
         %cell num
        resultcell{j+3,14}=num(11,1);
        cellnum=num(11,1);
        
        resultcell{1,14+(i-1)*sheet_width+1}=conditions{i};
        resultcell{2,14+(i-1)*sheet_width+1}='Firing Events';
        resultcell{2,14+(i-1)*sheet_width+2}=[];
        resultcell{2,14+(i-1)*sheet_width+3}=[];
        resultcell{2,14+(i-1)*sheet_width+4}=[];
        resultcell{3,14+(i-1)*sheet_width+1}='ori';
        resultcell{3,14+(i-1)*sheet_width+2}='mov';
        resultcell{3,14+(i-1)*sheet_width+3}='upd';
        resultcell{3,14+(i-1)*sheet_width+4}='nov';
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+1}=num(1+(i-1)*3,1);
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+2}=num(1+(i-1)*3,2);
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+3}=num(1+(i-1)*3,3);
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+4}=num(1+(i-1)*3,4);
        
        resultcell{2,14+(i-1)*sheet_width+5}='Sum CountTime';
        resultcell{2,14+(i-1)*sheet_width+6}=[];
        resultcell{2,14+(i-1)*sheet_width+7}=[];
        resultcell{2,14+(i-1)*sheet_width+8}=[];
        resultcell{3,14+(i-1)*sheet_width+5}='ori';
        resultcell{3,14+(i-1)*sheet_width+6}='mov';
        resultcell{3,14+(i-1)*sheet_width+7}='upd';
        resultcell{3,14+(i-1)*sheet_width+8}='nov';
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+5}=num(2+(i-1)*3,1);
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+6}=num(2+(i-1)*3,2);
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+7}=num(2+(i-1)*3,3);
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+8}=num(2+(i-1)*3,4);
        
        resultcell{2,14+(i-1)*sheet_width+9}='Sum FiringRate';
        resultcell{2,14+(i-1)*sheet_width+10}=[];
        resultcell{2,14+(i-1)*sheet_width+11}=[];
        resultcell{2,14+(i-1)*sheet_width+12}=[];
        resultcell{3,14+(i-1)*sheet_width+9}='ori';
        resultcell{3,14+(i-1)*sheet_width+10}='mov';
        resultcell{3,14+(i-1)*sheet_width+11}='upd';
        resultcell{3,14+(i-1)*sheet_width+12}='nov';
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+9}=num(3+(i-1)*3,1);
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+10}=num(3+(i-1)*3,2);
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+11}=num(3+(i-1)*3,3);
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+12}=num(3+(i-1)*3,4);
        
        resultcell{2,14+(i-1)*sheet_width+13}='Sum activity';
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+13}=num(1+(i-1)*3,5);
        resultcell{2,14+(i-1)*sheet_width+14}='Frame Number';
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+14}=num(1+(i-1)*3,6);
        resultcell{2,14+(i-1)*sheet_width+15}='Total activity/Frame';
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+15}=num(1+(i-1)*3,7);
        
        try
        num=xlsread(conditionfilename,'pairwise_correlation');
        resultcell{2,14+(i-1)*sheet_width+16}='Pairwise';
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+16}=num(i);
        catch
        end
        
        
        num=xlsread(conditionfilename,'mouselookobject_firing_count');
        
        if ~isempty(num)
        resultcell{2,14+(i-1)*sheet_width+17}='Angle_firing_count_average_by_cell';
        resultcell{2,14+(i-1)*sheet_width+18}=[];
        resultcell{2,14+(i-1)*sheet_width+19}=[];
        resultcell{2,14+(i-1)*sheet_width+20}=[];
        resultcell{3,14+(i-1)*sheet_width+17}='ori';
        resultcell{3,14+(i-1)*sheet_width+18}='mov';
        resultcell{3,14+(i-1)*sheet_width+19}='upd';
        resultcell{3,14+(i-1)*sheet_width+20}='nov';
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+17}=sum(num(:,3+5*(i-1)))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+18}=sum(num(:,4+5*(i-1)))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+19}=sum(num(:,5+5*(i-1)))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+20}=sum(num(:,6+5*(i-1)))/cellnum;
        end
        
        num=xlsread(conditionfilename,'mouselookobject_firing_rate'); 
        if ~isempty(num)
        resultcell{2,14+(i-1)*sheet_width+21}='Angle_firing_rate_average_by_cell';
        resultcell{2,14+(i-1)*sheet_width+22}=[];
        resultcell{2,14+(i-1)*sheet_width+23}=[];
        resultcell{2,14+(i-1)*sheet_width+24}=[];
        resultcell{3,14+(i-1)*sheet_width+21}='ori';
        resultcell{3,14+(i-1)*sheet_width+22}='mov';
        resultcell{3,14+(i-1)*sheet_width+23}='upd';
        resultcell{3,14+(i-1)*sheet_width+24}='nov';
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+21}=sum(num(:,3+5*(i-1)))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+22}=sum(num(:,4+5*(i-1)))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+23}=sum(num(:,5+5*(i-1)))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+24}=sum(num(:,6+5*(i-1)))/cellnum;
        end

%         num=xlsread(conditionfilename,'comparsion_objects_cells'); 
        
        num=xlsread(conditionfilename,'amplitude_comparsion_objects'); 
        resultcell{2,14+(i-1)*sheet_width+25}='amplitude Data';
        resultcell{3,14+(i-1)*sheet_width+25}='ori';
        resultcell{3,14+(i-1)*sheet_width+26}='mov';
        resultcell{3,14+(i-1)*sheet_width+27}='upd';
        resultcell{3,14+(i-1)*sheet_width+sheet_width}='nov';
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+25}=num(1+(i-1)*3,1);
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+26}=num(1+(i-1)*3,2);
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+27}=num(1+(i-1)*3,3);
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+28}=num(1+(i-1)*3,4);
        
        resultcell{2,14+(i-1)*sheet_width+29}='amplitude norm Data';
        resultcell{3,14+(i-1)*sheet_width+30}='ori';
        resultcell{3,14+(i-1)*sheet_width+31}='mov';
        resultcell{3,14+(i-1)*sheet_width+32}='upd';
        resultcell{3,14+(i-1)*sheet_width+sheet_width}='nov';
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+29}=num(2+(i-1)*3,1);
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+30}=num(2+(i-1)*3,2);
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+31}=num(2+(i-1)*3,3);
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+32}=num(2+(i-1)*3,4);
%         resultcell{3,14+(3-1)*24+60}='test cluster num';
%         num=xlsread(conditionfilename,'cell_cluster'); 
%         resultcell{j-(minn-1)+3,14+(3-1)*24+60}=max(num(:,2));
%         resultcell{j-(minn-1)+3,14+(3-1)*24+61}=max(num(:,3));
%         resultcell{j-(minn-1)+3,14+(3-1)*24+62}=max(num(:,4));
        num=xlsread(conditionfilename,'mouselookobject_firing_amp');
        
        if ~isempty(num)
        resultcell{2,14+(i-1)*sheet_width+33}='Angle_firing_amp_average_by_cell';
        resultcell{2,14+(i-1)*sheet_width+34}=[];
        resultcell{2,14+(i-1)*sheet_width+35}=[];
        resultcell{2,14+(i-1)*sheet_width+36}=[];
        resultcell{3,14+(i-1)*sheet_width+33}='ori';
        resultcell{3,14+(i-1)*sheet_width+34}='mov';
        resultcell{3,14+(i-1)*sheet_width+35}='upd';
        resultcell{3,14+(i-1)*sheet_width+36}='nov';
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+33}=sum(num(:,3+5*(i-1)))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+34}=sum(num(:,4+5*(i-1)))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+35}=sum(num(:,5+5*(i-1)))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+36}=sum(num(:,6+5*(i-1)))/cellnum;
        end
        
        num=xlsread(conditionfilename,'mouselookobject_firing_amp_norm'); 
        if ~isempty(num)
        resultcell{2,14+(i-1)*sheet_width+37}='Angle_firing_amp_norm_average_by_cell';
        resultcell{2,14+(i-1)*sheet_width+38}=[];
        resultcell{2,14+(i-1)*sheet_width+39}=[];
        resultcell{2,14+(i-1)*sheet_width+40}=[];
        resultcell{3,14+(i-1)*sheet_width+37}='ori';
        resultcell{3,14+(i-1)*sheet_width+38}='mov';
        resultcell{3,14+(i-1)*sheet_width+39}='upd';
        resultcell{3,14+(i-1)*sheet_width+40}='nov';
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+37}=sum(num(:,3+5*(i-1)))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+38}=sum(num(:,4+5*(i-1)))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+39}=sum(num(:,5+5*(i-1)))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+40}=sum(num(:,6+5*(i-1)))/cellnum;
        end
 
        num=xlsread(conditionfilename,'mouselookobject_count_time'); 
        if ~isempty(num)
        resultcell{2,14+(i-1)*sheet_width+41}='Angle_count_time_average_by_cell';
        resultcell{2,14+(i-1)*sheet_width+42}=[];
        resultcell{2,14+(i-1)*sheet_width+43}=[];
        resultcell{2,14+(i-1)*sheet_width+44}=[];
        resultcell{3,14+(i-1)*sheet_width+41}='ori';
        resultcell{3,14+(i-1)*sheet_width+42}='mov';
        resultcell{3,14+(i-1)*sheet_width+43}='upd';
        resultcell{3,14+(i-1)*sheet_width+44}='nov';
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+41}=sum(num(:,3+5*(i-1)))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+42}=sum(num(:,4+5*(i-1)))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+43}=sum(num(:,5+5*(i-1)))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+44}=sum(num(:,6+5*(i-1)))/cellnum;
        end
        
        num=xlsread(conditionfilename,'cell_cluster'); 
        if ~isempty(num)
        resultcell{2,14+(i-1)*sheet_width+45}='max num of cluster';
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+45}=max(num(:,2+(i-1)));
        resultcell{2,14+(i-1)*sheet_width+46}='correlation cleanness (KL distance)';
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+46}=num(end,11+(i-1));
        resultcell{2,14+(i-1)*sheet_width+47}='correlation cleanness (suoqin)';
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+47}=num(end,14+(i-1));
        end
        
        num=xlsread(conditionfilename,'mouselookobject_firing_count');
        if ~isempty(num)
        resultcell{2,14+(i-1)*sheet_width+48}='Angle_not_look_obj_firing_count_average_by_cell';
        resultcell{2,14+(i-1)*sheet_width+49}=[];
        resultcell{2,14+(i-1)*sheet_width+50}=[];
        resultcell{2,14+(i-1)*sheet_width+51}=[];
        resultcell{3,14+(i-1)*sheet_width+48}='ori';
        resultcell{3,14+(i-1)*sheet_width+49}='mov';
        resultcell{3,14+(i-1)*sheet_width+50}='upd';
        resultcell{3,14+(i-1)*sheet_width+51}='nov';
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+48}=sum(num(:,3+5*(i-1)+20))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+49}=sum(num(:,4+5*(i-1)+20))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+50}=sum(num(:,5+5*(i-1)+20))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+51}=sum(num(:,6+5*(i-1)+20))/cellnum;
        end
        
        num=xlsread(conditionfilename,'mouselookobject_firing_rate'); 
        if ~isempty(num)
        resultcell{2,14+(i-1)*sheet_width+52}='Angle_not_look_obj_firing_rate_average_by_cell';
        resultcell{2,14+(i-1)*sheet_width+53}=[];
        resultcell{2,14+(i-1)*sheet_width+54}=[];
        resultcell{2,14+(i-1)*sheet_width+55}=[];
        resultcell{3,14+(i-1)*sheet_width+52}='ori';
        resultcell{3,14+(i-1)*sheet_width+53}='mov';
        resultcell{3,14+(i-1)*sheet_width+54}='upd';
        resultcell{3,14+(i-1)*sheet_width+55}='nov';
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+52}=sum(num(:,3+5*(i-1)+20))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+53}=sum(num(:,4+5*(i-1)+20))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+54}=sum(num(:,5+5*(i-1)+20))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+55}=sum(num(:,6+5*(i-1)+20))/cellnum;
        end
        
        num=xlsread(conditionfilename,'mouselookobject_firing_amp');
        if ~isempty(num)
        resultcell{2,14+(i-1)*sheet_width+56}='Angle_not_look_obj_firing_amp_average_by_cell';
        resultcell{2,14+(i-1)*sheet_width+57}=[];
        resultcell{2,14+(i-1)*sheet_width+58}=[];
        resultcell{2,14+(i-1)*sheet_width+59}=[];
        resultcell{3,14+(i-1)*sheet_width+56}='ori';
        resultcell{3,14+(i-1)*sheet_width+57}='mov';
        resultcell{3,14+(i-1)*sheet_width+58}='upd';
        resultcell{3,14+(i-1)*sheet_width+59}='nov';
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+56}=sum(num(:,3+5*(i-1)+20))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+57}=sum(num(:,4+5*(i-1)+20))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+58}=sum(num(:,5+5*(i-1)+20))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+59}=sum(num(:,6+5*(i-1)+20))/cellnum;
        end
        
        num=xlsread(conditionfilename,'mouselookobject_firing_amp_norm'); 
        if ~isempty(num)
        resultcell{2,14+(i-1)*sheet_width+60}='Angle_not_look_obj_firing_amp_norm_average_by_cell';
        resultcell{2,14+(i-1)*sheet_width+61}=[];
        resultcell{2,14+(i-1)*sheet_width+62}=[];
        resultcell{2,14+(i-1)*sheet_width+63}=[];
        resultcell{3,14+(i-1)*sheet_width+60}='ori';
        resultcell{3,14+(i-1)*sheet_width+61}='mov';
        resultcell{3,14+(i-1)*sheet_width+62}='upd';
        resultcell{3,14+(i-1)*sheet_width+63}='nov';
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+60}=sum(num(:,3+5*(i-1)+20))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+61}=sum(num(:,4+5*(i-1)+20))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+62}=sum(num(:,5+5*(i-1)+20))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+63}=sum(num(:,6+5*(i-1)+20))/cellnum;
        end
        
        num=xlsread(conditionfilename,'mouselookobject_count_time'); 
        if ~isempty(num)
        resultcell{2,14+(i-1)*sheet_width+64}='Angle_not_look_obj_count_time_average_by_cell';
        resultcell{2,14+(i-1)*sheet_width+65}=[];
        resultcell{2,14+(i-1)*sheet_width+66}=[];
        resultcell{2,14+(i-1)*sheet_width+67}=[];
        resultcell{3,14+(i-1)*sheet_width+64}='ori';
        resultcell{3,14+(i-1)*sheet_width+65}='mov';
        resultcell{3,14+(i-1)*sheet_width+66}='upd';
        resultcell{3,14+(i-1)*sheet_width+67}='nov';
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+64}=sum(num(:,3+5*(i-1)+20))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+65}=sum(num(:,4+5*(i-1)+20))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+66}=sum(num(:,5+5*(i-1)+20))/cellnum;
        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+67}=sum(num(:,6+5*(i-1)+20))/cellnum;
        end
        
        num=xlsread(conditionfilename,'comparsion_objects');
        
        resultcell{2,14+(i-1)*sheet_width+68}='Travel path length';

        resultcell{j-(minn-1)+3,14+(i-1)*sheet_width+68}=num(1+(i-1)*3,8);

    end


%     resultcell{1,14+(maxx-1)*sheet_width+56}='Neuron Assemble Data';
% %         resultcell{j-(minn-1)+3,111}=resultcell{j-(minn-1)+3,64}/resultcell{j-(minn-1)+3,63};
% %         resultcell{j-(minn-1)+3,112}=resultcell{j-(minn-1)+3,68}/resultcell{j-(minn-1)+3,67};%neuron assemble 2
% %         resultcell{j-(minn-1)+3,113}=resultcell{j-(minn-1)+3,36}/resultcell{j-(minn-1)+3,35};%neuron assemble 3
% %         resultcell{j-(minn-1)+3,114}= (resultcell{j-(minn-1)+3,11}/resultcell{j-(minn-1)+3,10})*100;
%     resultcell{1,14+(maxx-1)*sheet_width+57}='Behavior Data';
%     resultcell{3,14+(maxx-1)*sheet_width+57}='Obj2/Obj1';
%     resultcell{3,14+(maxx-1)*sheet_width+58}='Obj2/Obj1';
%     resultcell{3,14+(maxx-1)*sheet_width+59}='Obj2/Obj1';
%     resultcell{3,14+(maxx-1)*sheet_width+60}='Discrimination Index';
 


    
%     if i==10
%         continue;
%     end
        
       %neuron assemble 1
%         resultcell{k+countk,89}=resultcell{k+countk,36}/resultcell{k+countk,35};%neuron assemble 3
        
%         resultcell{k+countk,90}= (resultcell{k+countk,11}/resultcell{k+countk,10})*100;

end

% xlswrite('H:\Xiaoxiao\data_conclusion.xlsx',resultcell,'sheet1');
% xlswrite('E:\20180521_square_circle_ADdata\data_conclusion.xlsx',resultcell,'sheet1');
% xlswrite('D:\HDAC_virus\HDAC_virus_result\batch1\data_conclusion.xlsx',resultcell,'sheet1');
% xlswrite('D:\Familiar and Novel box\\Familiar and Novel box result\data_conclusion.xlsx',resultcell,'sheet1');
% xlswrite('H:\AD_MUT_matlab result_123batch\data_conclusion_101418.xlsx',resultcell,'sheet1');
% xlswrite('Y:\Lujia\HDAC paper figures\data_conclusion\hdac_injection_data_conclusion_102718_5x5.xlsx',resultcell,'sheet1');
xlswrite('Y:\Lujia\HDAC paper figures\data_conclusion\hdac_injection_data_conclusion_110818_5x5.xlsx',resultcell,'sheet1');

% resultcell1=cell(size(resultcell));
% rearrangeid=[2 11 7 8 9 13 18 19 1 4 5 6 11 12 17 18]
% count=1;
% resultcell1(1:16,:)=resultcell([2 3 7 8 9 13 14 19 1 4 5 6 11 12 17 18],:);

