function h=circular_connection_plot(CM_all)

h=figure;
hold on;

min_interval=50;
        

for tk=1:length(CM_all)
    subplot(ceil(length(CM_all)/4),4,tk)
    hold on;

    CM=CM_all{tk};
    radius=min_interval*size(CM,1)/(2*pi);

    for i=1:size(CM,1)
        x_cor(i,1)=radius*cos(deg2rad((i-1)*360/size(CM,1)));
        y_cor(i,1)=radius*sin(deg2rad((i-1)*360/size(CM,1)));
        plot(x_cor(i,1),y_cor(i,1),'.','color','k','MarkerSize',30)
    end

    CM_norm=abs(CM*1/max(CM(:)));

    for i=1:size(CM,1)-1
        for j=i+1:size(CM,1)
            if CM_norm(i,j)>0.3
                plot([x_cor(i,1),x_cor(j,1)],[y_cor(i,1),y_cor(j,1)],'-','color',[0 0 CM_norm(i,j)],'lineWidth',4*CM_norm(i,j));
            end
        end
    end
end

    