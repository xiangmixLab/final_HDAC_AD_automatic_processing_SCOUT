function [max_inds,peak_rates,PF_radius,PF_radius_sum]=find_max_response_loc(firingRate)    
    rate_mat0 = firingRate; % rate map of place cell i
    PF_radius=nan;
    peak_rates=nan;
    max_inds=nan;
    
    if ~isempty(rate_mat0)
        peakRate = max(rate_mat0(:));
        rate_mat = filter2DMatrices(rate_mat0, 1); % smoooth it
        % Create AutoCorr
        autocorr=Cross_Correlation(rate_mat, rate_mat);

        %Find AutoMaxInds
        auto_max_inds = FindAutoMaxInds(autocorr);
        if ~isnan(auto_max_inds)
            % Find PF_radius
            [PF_radius,PF_radius_sum] = findPlaceFieldRadius(autocorr, auto_max_inds);

            % Find Max_Inds of smoothed rate mat
            max_inds= FindMaxIndsRateMap(rate_mat);% each row is the coordinates of one place field
            strength= 1.9;
            max_inds= RemoveTooCloseMaxInds(max_inds, PF_radius, rate_mat, strength);

            max_inds_delete = []; % delete the fields with peak rate less than 25% of maximum of rate map
            for ii = 1:size(max_inds)
                if rate_mat(max_inds(ii,1), max_inds(ii,2)) < 0.25*max(rate_mat(:))
                    max_inds_delete = [max_inds_delete,ii];
                end
            end
            max_inds(max_inds_delete,:) = []; % final result: the coordinates of peak of each field (each row)

                % Find peak firing rate at max_inds
            peak_rates = findPeakRates(max_inds,rate_mat);
        else
            PF_radius=nan;
            peak_rates=nan;
            max_inds=nan;
        end
   else
        PF_radius=nan;
        peak_rates=nan;
        max_inds=nan;
    end
