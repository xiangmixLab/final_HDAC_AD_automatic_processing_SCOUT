function behavpos_trans=to_circle_shape_behavpos_change(cir_behavpos,behavpos,shape_sign)

% shape_sign:
% 1: square
% 2: triangle
l_cir=max(cir_behavpos(:,1))-min(cir_behavpos(:,1));
h_cir=max(cir_behavpos(:,2))-min(cir_behavpos(:,2));

l=max(behavpos(:,1))-min(behavpos(:,1));
h=max(behavpos(:,2))-min(behavpos(:,2));

kc=max([max(l_cir) max(h_cir)])/2;

k=max([max(l) max(h)])/2;

angle_range=[-180:180];

for i=1:length(angle_range)
    Rc(i)=kc;
    
    switch shape_sign
        case 1
            theta=angle_range(i)*2*pi/360;    
            if (theta>-pi/4&&theta<pi/4)||(theta>3*pi/4||theta<-3*pi/4)
                R(i)=abs(k*(1+tan(theta)^2)^0.5);
            else
                R(i)=abs(k*(1+1/tan(theta)^2)^0.5);
            end
        case 2
            angle_range_adj=[-160:180,-180:1:-160]; % we find the triangle is a little bit rotated
            theta=angle_range_adj(i)*2*pi/360;    
            if theta>0&&theta<=pi/6
                R(i)=(2*k)/(3*cos(theta)-3^0.5*sin(theta));
            end
            if theta>pi/6&&theta<=pi/2
                R(i)=3^0.5*k/(3*sin(theta));
            end
            if theta>pi/2&&theta<=5*pi/6
                R(i)=abs(3^0.5*k/(3*cos(theta+pi/2)));
            end
            if theta>5*pi/6&&theta<=pi
                R(i)=abs(((2*k)/(-3*cos(theta)-3^0.5*sin(theta))));
            end
            if theta<=0&&theta>-pi/2
                R(i)=abs(2*k/((-3^0.5*sin(theta)+3*cos(theta))));
            end
            if theta>=-pi&&theta<=-pi/2
                R(i)=abs(2*k/((-3^0.5*sin(theta)-3*cos(theta))));
            end            
        otherwise
    end
end

behavpos_trans=[];
rp=zeros(1,361);
vecp=zeros(1,361);
for i=1:length(behavpos)
    if sum(isnan(behavpos(i,:)))==0
        vec=behavpos(i,:)-([min(min(behavpos(:,1)))+k min(min(behavpos(:,2)))+k]);
        theta=atan2d(vec(2),vec(1)); % in degree -180 - 180
        ang_diff=abs(theta-angle_range);
        theta_adj=angle_range(find(ang_diff==min(ang_diff)));
        r=norm(vec)*Rc(angle_range==theta_adj)/R(angle_range==theta_adj);
        rp(theta_adj+181)=Rc(angle_range==theta_adj)/R(angle_range==theta_adj);
        vecp(theta_adj+181)=vecp(theta_adj+181)+norm(vec);
        behavpos_trans(i,:)=[r*cos(theta*2*pi/360) r*sin(theta*2*pi/360)]+([min(min(behavpos(:,1)))+k min(min(behavpos(:,2)))+k]);
    else
        behavpos_trans(i,:)=[nan,nan];
    end
end


    
    