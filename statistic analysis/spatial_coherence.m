%spatial coherence (zhang et al. 2014 https://doi.org/10.3389/fnbeh.2014.00222)
%The spatial coherence for each firing-rate map was
%computed as follows:
%1: average smoothing every 3x3 bins
%2: r=corrcoef(smoothed_ratemap,ratemap)
%3: sc=0.5*ln(1+r/1-r)

function sp_c=spatial_coherence(firingrate)

% original_bin_rate=[];
% aggrated_neighborhood_rate=[];
% 
% ctt=1;
% for i=3:size(firingrate,1)-2
%     for j=3:size(firingrate,2)-2
%         original_bin_rate(ctt,1)=firingrate(i,j);
%         
%         patch=firingrate(i-2:i+2,j-2:j+2);
%         patch(3,3)=nan;
%         patch=reshape(patch,25,1);
%         patch(isnan(patch))=[];
%         
%         aggrated_neighborhood_rate(ctt,1)=mean(patch);
%         ctt=ctt+1;
%     end
% end
% 
% sp_c=corrcoef(original_bin_rate,aggrated_neighborhood_rate);
% sp_c=sp_c(2);
        
h=fspecial('average',3);
sm_firingrate=imfilter(firingrate,h);

fr_reshape=reshape(firingrate,size(firingrate,1)*size(firingrate,2),1);
sm_fr_reshape=reshape(sm_firingrate,size(sm_firingrate,1)*size(sm_firingrate,2),1);

rt=corrcoef(fr_reshape,sm_fr_reshape);
r=rt(2);

sp_c=0.5*log((1+r)/(1-r));