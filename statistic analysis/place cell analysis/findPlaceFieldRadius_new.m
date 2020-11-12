function [PF_radius,PF_radius_sum]= findPlaceFieldRadius_new(fs)

rate_mat = filter2DMatrices(fs, 1);

rate_mat_b=rate_mat>(max(rate_mat(:)))*0.5;

statss=regionprops(rate_mat_b,'MajorAxisLength');

if ~isempty(statss)
    for i=1:length(statss)
        radiuss(i)=statss(i).MajorAxisLength/2;
    end

    PF_radius=max(radiuss);
    PF_radius_sum=nansum(radiuss);
else
    PF_radius=nan;
    PF_radius_sum=nan;
end
