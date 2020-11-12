function histogram_plot_all_box(group,groupname,savedir,foldernamet,conditionname,exp,temp)

if exp==10
    group={[9 14 22 23],[11 12 20]};% delete those without baseline
    groupname={'RGFP_old','control_old'};
end
if exp==12
    groupname={'control_young','control_old','RGFP_old'};
end

mkdir(savedir);

for i=1:3
    a01={};
    a02={};
    a03={};
    a04={};
    a05={};

    for g=1:length(group)
            ct=1;
        for j=group{g}

            if j==10&&exp==10
                continue;
            end
            conditionfilename=[foldernamet{j},'\neuron_comparingFiringRate_averageinfo_placecell_data_binsize15.xlsx'];
            neuronIndividuals_new=importdata(conditionfilename);

            if isequal(temp,'C')
                [num,txt]=xlsread(conditionfilename,'comparsion_objects_cells_allBox');      
                a01{ct,g}=num(:,3+22*(i-1));%count   
                a03{ct,g}=num(:,11+22*(i-1));%rate
                a04{ct,g}=num(:,13+22*(i-1));%amp
                a05{ct,g}=num(:,15+22*(i-1));%namp
            end
            if isequal(temp,'S')
                [num,txt]=xlsread(conditionfilename,'comparsion_cells_allBox_S');      
                a01{ct,g}=num(:,3+22*(i-1));%count   
                a03{ct,g}=num(:,11+22*(i-1));%rate
                a04{ct,g}=num(:,13+22*(i-1));%rate
            end
            if isequal(temp,'trace')
                [num,txt]=xlsread(conditionfilename,'comparsion_cells_allB_1Cross');      
                a01{ct,g}=num(:,3+22*(i-1));%count   
                a03{ct,g}=num(:,11+22*(i-1));%rate
            end
            ct=ct+1;
        end

        sname1=[conditionname{i},'_count_events'];
        sname2=[conditionname{i},'_firing_rate'];
        sname3=[conditionname{i},'_integrated_amplitude'];
        sname4=[conditionname{i},'_int_amplitude_norm'];
        sname5=[conditionname{i},'_peak_amplitude'];
        sheetcol={'A','B','C','D','E'};
        if isequal(temp,'C')
            exname=[savedir,'\',groupname{g},' C all box.xlsx'];           
            a011=cell2mat(a01(:,g));
            xlswrite(exname,a011,sname1,sheetcol{1});
            a031=cell2mat(a03(:,g));
            xlswrite(exname,a031,sname2,sheetcol{1});
            a041=cell2mat(a04(:,g));
            xlswrite(exname,a041,sname3,sheetcol{1});   
            a051=cell2mat(a05(:,g));
            xlswrite(exname,a051,sname4,sheetcol{1});
            current_group_data={a011,a031,a041};
            save([savedir,'\',groupname{g},conditionname{i},' C all box.mat'],'current_group_data');
        end
        if isequal(temp,'S')
            exname=[savedir,'\',groupname{g},' S all box.xlsx'];
            a011=cell2mat(a01(:,g));
            xlswrite(exname,a011,sname1,sheetcol{1});
            a031=cell2mat(a03(:,g));
            xlswrite(exname,a031,sname2,sheetcol{1});
            a041=cell2mat(a04(:,g));
            xlswrite(exname,a041,sname5,sheetcol{1});
            current_group_data={a011,a031,a041};
            save([savedir,'\',groupname{g},conditionname{i},' S all box.mat'],'current_group_data');
        end
        if isequal(temp,'trace')
            exname=[savedir,'\',groupname{g},' tr all box.xlsx'];
            a011=cell2mat(a01(:,g));
            xlswrite(exname,a011,sname1,sheetcol{1});
            a031=cell2mat(a03(:,g));
            xlswrite(exname,a031,sname2,sheetcol{1});
            current_group_data={a011,a031};
            save([savedir,'\',groupname{g},conditionname{i},' tr all box.mat'],'current_group_data');
        end
        
    end
end

%% violin plot
for i=1:3
    if exp==10
        if isequal(temp,'C')
            c1=importdata([savedir,'\',groupname{1},conditionname{i},' C all box.mat']);
            c2=importdata([savedir,'\',groupname{2},conditionname{i},' C all box.mat']);
            violin_plot_with_sig({c1{1},c2{1}},groupname,savedir,conditionname,'Events old C',i);  
            violin_plot_with_sig({c1{2},c2{2}},groupname,savedir,conditionname,'Rates old C',i);  
            violin_plot_with_sig({c1{3},c2{3}},groupname,savedir,conditionname,'integ Amplitudes old C',i);  
        end
        if isequal(temp,'S')
            c1=importdata([savedir,'\',groupname{1},conditionname{i},' S all box.mat']);
            c2=importdata([savedir,'\',groupname{2},conditionname{i},' S all box.mat']);
            violin_plot_with_sig({c1{1},c2{1}},groupname,savedir,conditionname,'Events old S',i);  
            violin_plot_with_sig({c1{2},c2{2}},groupname,savedir,conditionname,'Rates old S',i);  
            violin_plot_with_sig({c1{2},c2{2}},groupname,savedir,conditionname,'Amplitudes old S',i);  
        end
        if isequal(temp,'trace')
            c1=importdata([savedir,'\',groupname{1},conditionname{i},' tr all box.mat']);
            c2=importdata([savedir,'\',groupname{2},conditionname{i},' tr all box.mat']);
            violin_plot_with_sig({c1{1},c2{1}},groupname,savedir,conditionname,'Events old 1cross',i);  
            violin_plot_with_sig({c1{2},c2{2}},groupname,savedir,conditionname,'Rates old 1cross',i);  
        end
    end
    if exp==12
        if isequal(temp,'C')
            c1=importdata([savedir,'\',groupname{1},conditionname{i},' C all box.mat']);
            c2=importdata([savedir,'\',groupname{2},conditionname{i},' C all box.mat']);
            c3=importdata([savedir,'\',groupname{3},conditionname{i},' C all box.mat']);
            violin_plot_with_sig({c1{1},c2{1},c3{1}},groupname,savedir,conditionname,'Events old cyoung C',i);  
            violin_plot_with_sig({c1{2},c2{2},c3{2}},groupname,savedir,conditionname,'Rates old cyoung C',i);  
            violin_plot_with_sig({c1{3},c2{3},c3{3}},groupname,savedir,conditionname,'integ Amplitudes old cyoung C',i);  
        end
        if isequal(temp,'S')
            c1=importdata([savedir,'\',groupname{1},conditionname{i},' S all box.mat']);
            c2=importdata([savedir,'\',groupname{2},conditionname{i},' S all box.mat']);
            c3=importdata([savedir,'\',groupname{3},conditionname{i},' S all box.mat']);
            violin_plot_with_sig({c1{1},c2{1},c3{1}},groupname,savedir,conditionname,'Events old cyoung S',i);  
            violin_plot_with_sig({c1{2},c2{2},c3{2}},groupname,savedir,conditionname,'Rates old cyoung S',i);  
            violin_plot_with_sig({c1{2},c2{2},c3{2}},groupname,savedir,conditionname,'Amplitudes old cyoung S',i);  
        end
        if isequal(temp,'trace')
            c1=importdata([savedir,'\',groupname{1},conditionname{i},' tr all box.mat']);
            c2=importdata([savedir,'\',groupname{2},conditionname{i},' tr all box.mat']);
            c3=importdata([savedir,'\',groupname{3},conditionname{i},' tr all box.mat']);
            violin_plot_with_sig({c1{1},c2{1},c3{1}},groupname,savedir,conditionname,'Events old cyoung 1cross',i);  
            violin_plot_with_sig({c1{2},c2{2},c3{2}},groupname,savedir,conditionname,'Rates old cyoung 1cross',i);  
        end

    end
end
