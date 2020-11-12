
%% shape conversion follows Long-term plasticity in hippocampal place-cell representation of environmental geometry, nature 2002 okeefe's lab
function [behav2c]=align_behav_shape(behav_non_circle,behav_circle)

behav_non_cir_pos=behav_non_circle.position;
behav_non_cir_time=behav_non_circle.time;

behav_cir_pos=behav_circle.position;
behav_cir_time=behav_circle.time;

behav_cir_pos(:,1)=fillmissing(behav_cir_pos(:,1),'linear');
behav_cir_pos(:,2)=fillmissing(behav_cir_pos(:,2),'linear');
behav_non_cir_pos(:,1)=fillmissing(behav_non_cir_pos(:,1),'linear');
behav_non_cir_pos(:,2)=fillmissing(behav_non_cir_pos(:,2),'linear');

behav_non_cir_pos=behav_non_cir_pos-mean(behav_non_cir_pos,1);
behav_cir_pos=behav_cir_pos-mean(behav_cir_pos,1);

%% convert cartisan to polar
[theta_cir,rho_cir] = cart2pol(behav_cir_pos(:,1),behav_cir_pos(:,2));
[theta_ncir,rho_ncir] = cart2pol(behav_non_cir_pos(:,1),behav_non_cir_pos(:,2));

%% convert radian to deg
theta_cird=round(rad2deg(theta_cir));
theta_ncird=round(rad2deg(theta_ncir));

%% find boundary


bd_cir=boundary(behav_cir_pos(:,1),behav_cir_pos(:,2));
bd_ncir=boundary(behav_non_cir_pos(:,1),behav_non_cir_pos(:,2));

%% find boundary points corresponding to unique theta
[bd_cir_pol_rho]=duplicate_idx_processing(rho_cir(bd_cir),theta_cird(bd_cir),'max');
[bd_ncir_pol_rho]=duplicate_idx_processing(rho_ncir(bd_ncir),theta_ncird(bd_ncir),'max');

bd_cir_pol=[unique(theta_cird(bd_cir)),bd_cir_pol_rho];
bd_ncir_pol=[unique(theta_ncird(bd_ncir)),bd_ncir_pol_rho];

% polarplot(theta_cir(bd_cir),rho_cir(bd_cir),'.');
% polarplot(deg2rad(bd_cir_pol(:,1)),bd_cir_pol(:,2))
% polarplot(deg2rad(bd_ncir_pol(:,1)),bd_ncir_pol(:,2));

bd_cir_pol_interp=[[-180:180]',interp1(bd_cir_pol(:,1),bd_cir_pol(:,2),[-180:180])'];
bd_ncir_pol_interp=[[-180:180]',interp1(bd_ncir_pol(:,1),bd_ncir_pol(:,2),[-180:180])'];

% polarplot(deg2rad(bd_cir_pol_interp(:,1)),bd_cir_pol_interp(:,2))



rho_ncir_trans=[];

for i=1:length(theta_ncird)
    rho_ncir_trans(i,1)=rho_ncir(i,1)*bd_cir_pol_interp(bd_cir_pol_interp(:,1)==theta_ncird(i),2)/bd_ncir_pol_interp(bd_ncir_pol_interp(:,1)==theta_ncird(i),2);
end

% polarplot(theta_ncir,rho_ncir_trans)

[behav_non_cir_pos_trans(:,1),behav_non_cir_pos_trans(:,2)]=pol2cart(theta_ncir,rho_ncir_trans);

behav_non_cir_pos_trans(:,1)=fillmissing(behav_non_cir_pos_trans(:,1),'linear');
behav_non_cir_pos_trans(:,2)=fillmissing(behav_non_cir_pos_trans(:,2),'linear');

behav2c=behav_non_circle;
behav2c.position=behav_non_cir_pos_trans-min(behav_non_cir_pos_trans,[],1);
