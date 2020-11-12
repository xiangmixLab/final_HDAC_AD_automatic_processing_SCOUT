function cir_behavpos_trans=circle_to_square_shape_behavpos_change(cir_behavpos,sqr_behavpos)

l_cir=max(cir_behavpos,[],1)-min(cir_behavpos,[],1);
h_cir=max(cir_behavpos,[],2)-min(cir_behavpos,[],2);

l_sqr=max(sqr_behavpos,[],1)-min(sqr_behavpos,[],1);
h_sqr=max(sqr_behavpos,[],2)-min(sqr_behavpos,[],2);

kc=max([max(l_cir) max(h_cir)])/2;

ks=max([max(l_sqr) max(h_sqr)])/2;

angle_range=[-180:180];

for i=1:length(angle_range)
    Rc(i)=kc;
    theta_sqr=angle_range(i)*2*pi/360;    
    if (theta_sqr>-pi/4&&theta_sqr<pi/4)||(theta_sqr>3*pi/4||theta_sqr<-3*pi/4)
        Rs(i)=real(ks*(1+tan(theta_sqr)^2)^0.5);
    else
        Rs(i)=real(ks*(1+1/tan(theta_sqr)^2)^0.5);
    end
end

cir_behavpos_trans=[];

for i=1:length(cir_behavpos)
    vec_cir=cir_behavpos(i,:)-([min(min(cir_behavpos,[],1))+kc min(min(cir_behavpos,[],2))+kc]);
    theta_cir=atan2d(vec_cir(2),vec_cir(1)); % in degree -180 - 180
    ang_diff=abs(theta_cir-angle_range);
    theta_cir_adj=angle_range(find(ang_diff==min(ang_diff)));
    rc=norm(vec_cir)*Rs(angle_range==theta_cir_adj)/Rc(angle_range==theta_cir_adj);
    cir_behavpos_trans(i,:)=[rc*cos(theta_cir*2*pi/360) rc*sin(theta_cir*2*pi/360)]+([min(min(cir_behavpos,[],1))+kc min(min(cir_behavpos,[],2))+kc]);
end


    
    