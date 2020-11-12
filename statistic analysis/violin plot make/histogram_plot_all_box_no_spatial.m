
function histogram_plot_all_box_no_spatial(group,groupname,savedir,foldernamet,conditionname,exp,temp)

if exp==10
%     group={[2 3 9 14 22 23 19],[1 4 11 12 17 18 20]};
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
            conditionfilename=[foldernamet{j},'\neuronIndividuals_new.mat'];
            neuronIndividuals_new=importdata(conditionfilename);

            if isequal(temp,'C')
                dat_cs=neuronIndividuals_new{i}.C;
                nam='C';        
                threshss=max(dat_cs,[],2)*0.1;
                dat_cs_sig=[];
                dat_cs_sig_peak=[];
                for klkl=1:size(dat_cs,1)
                    dat_cs_sig(klkl,:)=squeeze(dat_cs(klkl,:)).*double((dat_cs(klkl,:)>threshss(klkl)));
                    dat_cs_sig_peak(klkl,1)=sum(findpeaks(dat_cs_sig(klkl,:)));
                end
                a01{ct,g}=sum(dat_cs_sig>0,2);%count, obj1
                a03{ct,g}=sum(dat_cs_sig>0,2)/size(dat_cs,2);%rate
                a04{ct,g}=sum(dat_cs_sig,2)/size(dat_cs,2);%intergrated peaks                
                a05{ct,g}=dat_cs_sig_peak/size(dat_cs,2);%peaks
            end
            if isequal(temp,'S')
                dat_cs=neuronIndividuals_new{i}.C*0;
                for klkl=1:size(dat_cs,1)
                    [pks,loc]=findpeaks(neuronIndividuals_new{i}.C(klkl,:));
                    dat_cs(klkl,loc)=pks;
                end
                nam='S';        
                threshss=max(dat_cs,[],2)*0.1;
                dat_cs_sig=[];
                for klkl=1:size(dat_cs,1)
                    dat_cs_sig(klkl,:)=squeeze(dat_cs(klkl,:)).*double((dat_cs(klkl,:)>threshss(klkl)));
                    dat_cs_sig_peak(klkl,1)=sum(findpeaks(dat_cs_sig(klkl,:)));
                end
                a01{ct,g}=sum(dat_cs_sig>0,2);%count, obj1
                a03{ct,g}=sum(dat_cs_sig>0,2)/size(dat_cs,2);%rate
                a04{ct,g}=dat_cs_sig_peak/size(dat_cs,2);%peaks             
            end
            ct=ct+1;
        end
         
         sname1=[conditionname{i},'_count_events'];
         sname2=[conditionname{i},'_firing_rate'];
         sname3=[conditionname{i},'_int_amplitude'];
         sname4=[conditionname{i},'_amplitude'];
         sheetcol={'A','B','C','D','E'};

        if isequal(temp,'C')
            exname=[savedir,'\',groupname{g},' C all box no spatial.xlsx'];
            a011=cell2mat(a01(:,g));
            xlswrite(exname,a011,sname1,sheetcol{1});
            a031=cell2mat(a03(:,g));
            xlswrite(exname,a031,sname2,sheetcol{1});
            a041=cell2mat(a04(:,g));
            xlswrite(exname,a041,sname3,sheetcol{1});   
            a051=cell2mat(a05(:,g));
            xlswrite(exname,a051,sname4,sheetcol{1});   
            current_group_data={a011,a031,a041,a051};
            save([savedir,'\',groupname{g},conditionname{i},' C all box no spatial.mat'],'current_group_data');
        end
        if isequal(temp,'S')
            exname=[savedir,'\',groupname{g},' S all box no spatial.xlsx'];
            a011=cell2mat(a01(:,g));
            xlswrite(exname,a011,sname1,sheetcol{1});
            a031=cell2mat(a03(:,g));
            xlswrite(exname,a031,sname2,sheetcol{1});
            a041=cell2mat(a04(:,g));
            xlswrite(exname,a041,sname4,sheetcol{1});   
            current_group_data={a011,a031,a041};
            save([savedir,'\',groupname{g},conditionname{i},' S all box no spatial.mat'],'current_group_data');
        end
    end
end
%% violin plot
for i=1:3
    if exp==10
        if isequal(temp,'C')
            c1=importdata([savedir,'\',groupname{1},conditionname{i},' C all box no spatial.mat']);
            c2=importdata([savedir,'\',groupname{2},conditionname{i},' C all box no spatial.mat']);
            violin_plot_with_sig({c1{1},c2{1}},groupname,savedir,conditionname,'Events old',i);  
            violin_plot_with_sig({c1{2},c2{2}},groupname,savedir,conditionname,'Rates old',i);  
            violin_plot_with_sig({c1{3},c2{3}},groupname,savedir,conditionname,'Integrated Amplitudes old C',i);  
            violin_plot_with_sig({c1{4},c2{4}},groupname,savedir,conditionname,'Amplitudes old C',i); 
        end
        if isequal(temp,'S')
            c1=importdata([savedir,'\',groupname{1},conditionname{i},' S all box no spatial.mat']);
            c2=importdata([savedir,'\',groupname{2},conditionname{i},' S all box no spatial.mat']);
            violin_plot_with_sig({c1{1},c2{1}},groupname,savedir,conditionname,'Events old S',i);  
            violin_plot_with_sig({c1{2},c2{2}},groupname,savedir,conditionname,'Rates old S',i);  
            violin_plot_with_sig({c1{3},c2{3}},groupname,savedir,conditionname,'Amplitudes old C',i);
        end
    end
    if exp==12
        if isequal(temp,'C')
            c1=importdata([savedir,'\',groupname{1},conditionname{i},' C all box no spatial.mat']);
            c2=importdata([savedir,'\',groupname{2},conditionname{i},' C all box no spatial.mat']);
            c3=importdata([savedir,'\',groupname{3},conditionname{i},' C all box no spatial.mat']);
            violin_plot_with_sig({c1{1},c2{1},c3{1}},groupname,savedir,conditionname,'Events old cyoung C',i);  
            violin_plot_with_sig({c1{2},c2{2},c3{2}},groupname,savedir,conditionname,'Rates old cyoung C',i);  
            violin_plot_with_sig({c1{3},c2{3},c3{3}},groupname,savedir,conditionname,'Integ Amplitudes old cyoung C',i);  
            violin_plot_with_sig({c1{4},c2{4},c3{4}},groupname,savedir,conditionname,'Amplitudes old cyoung C',i);  
        end
        if isequal(temp,'S')
            c1=importdata([savedir,'\',groupname{1},conditionname{i},' S all box no spatial.mat']);
            c2=importdata([savedir,'\',groupname{2},conditionname{i},' S all box no spatial.mat']);
            c3=importdata([savedir,'\',groupname{3},conditionname{i},' S all box no spatial.mat']);
            violin_plot_with_sig({c1{1},c2{1},c3{1}},groupname,savedir,conditionname,'Events old cyoung S',i);  
            violin_plot_with_sig({c1{2},c2{2},c3{2}},groupname,savedir,conditionname,'Rates old cyoung S',i);  
            violin_plot_with_sig({c1{3},c2{3},c3{3}},groupname,savedir,conditionname,'Amplitudes old cyoung S',i);          
        end
    end
end
