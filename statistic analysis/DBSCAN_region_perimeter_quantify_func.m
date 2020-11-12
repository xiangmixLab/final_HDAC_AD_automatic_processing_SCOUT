function [avg_max_region,avg_max_peri,avg_max_region_95,avg_max_peri_95,area_thresh_all,max_region]=DBSCAN_region_perimeter_quantify_func(region_all,imageSize)

avg_max_region=[];
avg_max_peri=[];
area_thresh_all={};
max_region={};

d1=imageSize(1);
d2=imageSize(2);

for i=1:size(region_all,1)
    for j=1:size(region_all,2)
        regiont=region_all{i,j};
        
        avg_area=[];
        avg_peri=[];
        area_thresh_t=[];
        for k=1:size(regiont,1)
            regiont_all=zeros(d1,d2);
            for l=1:size(regiont,2)
                if ~isempty(regiont{k,l})
                    regiont_all=regiont_all+regiont{k,l};
                end
            end
             regiont_all=regiont_all>0;
            stats=regionprops(regiont_all,'Area','Perimeter');
            if ~isempty(stats)
                area_all=[stats.Area];
                peri_all=[stats.Perimeter];
                area_all_thres=max(area_all)*0.1; % 95% max 122019 % change back to 0.1 012720
                area_idx=area_all>area_all_thres;
                area_thresh_t(k)=area_all_thres;
                avg_area(k)=mean(area_all(area_idx));
                avg_peri(k)=mean(peri_all(area_idx));
            else
                avg_area(k)=1;
                avg_peri(k)=1;
                area_thresh_t(k)=0; % no regions actually...
            end
        end
        area_thresh_t(isnan(area_thresh_t))=0;
        area_thresh_t(area_thresh_t==inf)=0;
        area_thresh_all{i,j}=area_thresh_t;
        avg_max_region(i,j)=mean(avg_area);
        max_region{i,j}=avg_area;
        avg_max_region_95(i,j)=quantile(avg_area,.95);
        avg_max_peri(i,j)=mean(avg_peri);
        avg_max_peri_95(i,j)= quantile(avg_peri,.95);
    end
end
