    % exp settings for overall analysis
    boxlength=280;
    if exp==10
        group={[2 3 9 14 22 23 19],[7 8],[1 4 11 12 17 18 20]};
        groupname={'inject_RGFP_old','inject_RGFP_young','inject_control_old'};
        cfolder1='D:\HDAC_matlab_result\across mouse analysis';
        cfolder2='D:\HDAC_matlab_result\across mouse analysis look at obj';
        cfolder3='D:\HDAC_matlab_result\across mouse analysis distance orientation';
        cfolder4='D:\HDAC_matlab_result\distribution_single_cell';
        cfolder5='D:\HDAC_matlab_result\distribution_single_cell_allBox';
        cfolder6='D:\HDAC_matlab_result\distribution_single_cell_allBox_no_spatial';
        cfolder7='D:\HDAC_matlab_result\distribution_single_cell_look_at_obj';
        cfolder8='D:\HDAC_matlab_result\across mouse analysis distance activity';
        cfolder9='D:\HDAC_matlab_result\across mouse analysis all obj';
        cfolder10='D:\HDAC_matlab_result\individual mouse analysis all obj';
    end
    if exp==4
        group={[5 6 7 8 9]};
        groupname={'virus_control_young'};
        cfolder1='D:\HDAC_virus\HDAC_virus_result\batch1\across mouse analysis';
        cfolder2='D:\HDAC_virus\HDAC_virus_result\batch1\across mouse analysis look at obj';
        cfolder3='D:\HDAC_virus\HDAC_virus_result\batch1\across mouse analysis distance orientation';
        cfolder4='D:\HDAC_virus\HDAC_virus_result\batch1\distribution_single_cell';
        cfolder5='D:\HDAC_virus\HDAC_virus_result\batch1\distribution_single_cell_allBox'; 
        cfolder6='D:\HDAC_virus\HDAC_virus_result\batch1\distribution_single_cell_allBox_no_spatial';
        cfolder7='D:\HDAC_virus\HDAC_virus_result\batch1\distribution_single_cell_look_at_obj';
        cfolder8='D:\HDAC_virus\HDAC_virus_result\batch1\across mouse analysis distance activity';   
    end
    if exp==5
        group={[6 7 8 9]};
        groupname={'virus_control_young'};
        cfolder1='D:\HDAC_virus\HDAC_virus_result\batch2\across mouse analysis';
        cfolder2='D:\HDAC_virus\HDAC_virus_result\batch2\across mouse analysis look at obj';
        cfolder3='D:\HDAC_virus\HDAC_virus_result\batch2\across mouse analysis distance orientation';
        cfolder4='D:\HDAC_virus\HDAC_virus_result\batch2\distribution_single_cell';
        cfolder5='D:\HDAC_virus\HDAC_virus_result\batch2\distribution_single_cell_allBox';  
        cfolder6='D:\HDAC_virus\HDAC_virus_result\batch2\distribution_single_cell_allBox_no_spatial';
        cfolder7='D:\HDAC_virus\HDAC_virus_result\batch2\distribution_single_cell_look_at_obj';
        cfolder8='D:\HDAC_virus\HDAC_virus_result\batch2\across mouse analysis distance activity';       
    end    
    if exp==12
        group={[1:11]};
        groupname={'control_inject_virus_young'};
        cfolder1='D:\HDAC_matlab_result\across mouse analysis control young inject virus';
        cfolder2='D:\HDAC_matlab_result\across mouse analysis control young inject virus look at obj';
        cfolder3='D:\HDAC_matlab_result\across mouse analysis control young inject virus distance orientation';
        cfolder4='D:\HDAC_matlab_result\distribution_single_cell';
        cfolder5='D:\HDAC_matlab_result\distribution_single_cell_allBox';  
         cfolder6='D:\HDAC_matlab_result\distribution_single_cell_allBox_no_spatial';
        cfolder7='D:\HDAC_matlab_result\distribution_single_cell_look_at_obj';
        cfolder8='D:\HDAC_matlab_result\across mouse analysis distance activity';   
        cfolder9='D:\HDAC_matlab_result\across mouse analysis all obj';
        cfolder10='D:\HDAC_matlab_result\individual mouse analysis all obj';
    end
    if exp==13
        group={[1,3,4,6,8,12],[2,5,7,9,10,11]};
        groupname={'saline','CNO'};
        cfolder1='D:\Yanjun_nn_revision_exp\across mouse analysis CNO saline';
        cfolder2='D:\Yanjun_nn_revision_exp\across mouse analysis CNO saline look at obj';
        cfolder3='D:\Yanjun_nn_revision_exp\across mouse analysis CNO saline distance orientation';
        cfolder4='D:\Yanjun_nn_revision_exp\distribution_single_cell';
        cfolder5='D:\Yanjun_nn_revision_exp\distribution_single_cell_allBox';  
        cfolder6='D:\Yanjun_nn_revision_exp\distribution_single_cell_allBox_no_spatial';
        cfolder7='D:\Yanjun_nn_revision_exp\distribution_single_cell_look_at_obj';
        cfolder8='D:\Yanjun_nn_revision_exp\across mouse analysis distance activity';   
        cfolder9='D:\Yanjun_nn_revision_exp\across mouse analysis all obj';
        cfolder10='D:\Yanjun_nn_revision_exp\individual mouse analysis all obj';
        cfolder11='D:\Yanjun_nn_revision_exp\across mouse analysis distance time';
        cfolder12='D:\Yanjun_nn_revision_exp\intra inter cluster distance plot';
        cfolder13='D:\Yanjun_nn_revision_exp\across mouse analysis distance time cdf';
    end
    if exp==14
        group={[2,3,5,9,10],[1,4,6,7,8]};
        groupname={'saline','CNO'};
        cfolder1='D:\Yanjun_nn_revision_exp\across mouse analysis CNO saline reversal';
        cfolder2='D:\Yanjun_nn_revision_exp\across mouse analysis CNO saline look at obj reversal';
        cfolder3='D:\Yanjun_nn_revision_exp\across mouse analysis CNO saline distance orientation reversal';
        cfolder4='D:\Yanjun_nn_revision_exp\distribution_single_cell reversal';
        cfolder5='D:\Yanjun_nn_revision_exp\distribution_single_cell_allBox reversal';  
        cfolder6='D:\Yanjun_nn_revision_exp\distribution_single_cell_allBox_no_spatial reversal';
        cfolder7='D:\Yanjun_nn_revision_exp\distribution_single_cell_look_at_obj reversal';
        cfolder8='D:\Yanjun_nn_revision_exp\across mouse analysis distance activity reversal';   
        cfolder9='D:\Yanjun_nn_revision_exp\across mouse analysis all obj reversal';
        cfolder10='D:\Yanjun_nn_revision_exp\individual mouse analysis all obj reversal';
        cfolder11='D:\Yanjun_nn_revision_exp\across mouse analysis distance time reversal';
        cfolder12='D:\Yanjun_nn_revision_exp\intra inter cluster distance plot reversal';
        cfolder13='D:\Yanjun_nn_revision_exp\across mouse analysis distance time cdf reversal';
    end