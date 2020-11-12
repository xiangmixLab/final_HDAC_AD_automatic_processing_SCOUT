    if exp==10
        group={[2 3 9 14 22 23 19],[7 8],[1 4 11 12 17 18 20]};
        groupname={'inject_RGFP_old','inject_RGFP_young','inject_control_old'};
        cfolder='D:\HDAC_matlab_result\across mouse analysis\calcium trace';
        mname={{'b1_3243','b1_3244','b3m2','b43321','b6m3','b6m4','b53323'},{'b2m4','b2m5'},{'b13241','b1christy','b3m4','b3m5','b5m1','b5m2','b6m1'}};
    end
    if exp==4
        group={[5 6 7 8 9]};
        groupname={'virus_control_young'};
        cfolder='D:\HDAC_virus\HDAC_virus_result\batch1\across mouse analysis\calcium trace';
    end
    if exp==5
        group={[6 7 8 9]};
        groupname={'virus_control_young'};
        cfolder='D:\HDAC_virus\HDAC_virus_result\batch2\across mouse analysis\calcium trace';
    end    
    if exp==12
        group={[1:11]};
        groupname={'control_inject_virus_young'};
        cfolder='D:\HDAC_matlab_result\across mouse analysis control young inject virus\calcium trace';
        mname={{'b2m3','b2m4','b1L0R0','b1L1R0','b1L1R1','b1L2R0','b1L3R0','b2L1R0','b2L1R2','b2L2R1','b2L3R0'}};        
    end
    
    mkdir(cfolder);
   for ikkk=1:length(group)
            groupr=group{ikkk};
            mnamer=mname{ikkk};
            for ikk=1:length(groupr)
                cd(foldernamet{groupr(ikk)});
                load('neuronIndividuals_new.mat');
                % code from codeforStevenUpdate.m
                dataS1 = zeros(size(neuronIndividuals_new{1}.C,1),length(neuronIndividuals_new));
                dataS2 = zeros(size(neuronIndividuals_new{1}.C,1),length(neuronIndividuals_new));
                position = zeros(1,length(neuronIndividuals_new)+1);
                for i = 1:length(neuronIndividuals_new)
                    dataS1(:,i) = sum(neuronIndividuals_new{i}.C>0.1*max(neuronIndividuals_new{i}.C,2),2)/neuronIndividuals_new{i}.num2read;
                    dataS2(:,i) = sum(neuronIndividuals_new{i}.C,2)/neuronIndividuals_new{i}.num2read;
                    position(i+1) = position(i)+1;
                end
                figure
                imagesc(dataS1)
                colormap(flipud(hot))
                colorbar
                hold on
                flag = 1;
                if flag
                    for i = 2:length(position)-1
                        line([position(i)+0.5 position(i)+0.5],get(gca,'YLim'),'LineWidth',0.5,'Color','k'); hold on;
                        hold on;
                    end
                end
                set(gca,'Xtick',1:length(neuronIndividuals_new));
                set(gca,'FontSize',8)
                xlabel('Conditions','FontSize',10)
                ylabel('Neurons','FontSize',10)
                title('Average Events dynamics')
                set(gcf,'renderer','painters');
                saveas(gcf,[cfolder,'\',groupname{ikkk},'_',mnamer{ikk},'_AverageEventsDynamic.fig'],'fig');
                saveas(gcf,[cfolder,'\',groupname{ikkk},'_',mnamer{ikk},'_AverageEventsDynamic.eps'],'epsc');
                saveas(gcf,[cfolder,'\',groupname{ikkk},'_',mnamer{ikk},'_AverageEventsDynamic.tif'],'tif');
                figure
                imagesc(dataS2)
                colormap(flipud(hot))
                colorbar
                hold on
                flag = 1;
                if flag
                    for i = 2:length(position)-1
                        line([position(i)+0.5 position(i)+0.5],get(gca,'YLim'),'LineWidth',0.5,'Color','k'); hold on;
                        hold on;
                    end
                end
                set(gca,'Xtick',1:length(neuronIndividuals_new));
                set(gca,'FontSize',8)
                xlabel('Conditions','FontSize',10)
                ylabel('Neurons','FontSize',10)
                title('Average amplitude dynamics')
                set(gcf,'renderer','painters');
                saveas(gcf,[cfolder,'\',groupname{ikkk},'_',mnamer{ikk},'_AverageAmplitudeDynamic.fig'],'fig');
                saveas(gcf,[cfolder,'\',groupname{ikkk},'_',mnamer{ikk},'_AverageAmplitudeDynamic.eps'],'epsc');
                saveas(gcf,[cfolder,'\',groupname{ikkk},'_',mnamer{ikk},'_AverageAmplitudeDynamic.tif'],'tif');
                close   
%                 dataS_all=dataS_all+dataS; AS THE CELL NUMS ARE DIFFERENT
%                 OVERALL RESULT CAN NOT BE ACHIEVED
            end
%             dataS_all=dataS_all/length(group);
%             imagesc(dataS_all)
%             colormap(flipud(hot))
%             colorbar
%             hold on
%             flag = 1;
%             if flag
%                 for i = 2:length(position)-1
%                     line([position(i)+0.5 position(i)+0.5],get(gca,'YLim'),'LineWidth',0.5,'Color','k'); hold on;
%                     hold on;
%                 end
%             end
%             set(gca,'Xtick',1:length(neuronIndividuals_new));
%             set(gca,'FontSize',8)
%             xlabel('Conditions','FontSize',10)
%             ylabel('Neurons','FontSize',10)
%             title('Average trace dynamics')
%             set(gcf,'renderer','painters');
%             saveas(gcf,[cfolder,'\',groupname{ikkk},'_allm_AverageTraceDynamic.fig'],'fig');
%             saveas(gcf,[cfolder,'\',groupname{ikkk},'_allm_AverageTraceDynamic.eps'],'epsc');
%             saveas(gcf,[cfolder,'\',groupname{ikkk},'_allm_AverageTraceDynamic.tif'],'tif');
   end
