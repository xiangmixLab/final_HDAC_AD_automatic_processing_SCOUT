function head_direction_visualizer(behavfld,behav)

    pos_red=(behav.position+behav.ROI(1:2))*behav.ROI3/behav.trackLength;
    pos_blue=(behav.positionblue+behav.ROI(1:2))*behav.ROI3/behav.trackLength;

    obj1=round(behav.object(1,:));
    obj2=round(behav.object(2,:));

    vec_b2r=pos_red-pos_blue;
    vec_b2o1=obj1-pos_blue;
    vec_b2o2=obj2-pos_blue;
    
    framee=general_avi_read([behavfld,'\','behavCam1_1.avi']);
    
    for i=1:length(framee)
        imagesc(framee{i});
        hold on;
        quiver(pos_blue(i,1),pos_blue(i,2),vec_b2r(i,1),vec_b2r(i,2),10,'Color','r');
        quiver(pos_blue(i,1),pos_blue(i,2),vec_b2o1(1),vec_b2o1(2),10,'Color','g');
        quiver(pos_blue(i,1),pos_blue(i,2),vec_b2o2(1),vec_b2o2(2),10,'Color','b');
        title(num2str(i));
        drawnow;
        pause(0.2);
        clf
    end
