function h_out=plotwithMaxMixRange(x,y,minMaxRange,colorss,symbols)

h_out=figure;
for i=1:size(x,2)
    plot(x(:,i),y(:,i),symbols{i},'color',colorss{i});
    hold on;
    boundd=[minMaxRange{i}(:,1);flipud(minMaxRange{i}(:,2))];
    boundd_x=[x(:,i);flipud(x(:,i))];
    h=fill(boundd_x, boundd, colorss{i});
    set(h,'facealpha',.5)
end