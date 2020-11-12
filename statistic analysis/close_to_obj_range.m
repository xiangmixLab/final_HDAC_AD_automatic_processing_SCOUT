function idx=close_to_obj_range(behavpos,object,range)


dis2obj=sum((behavpos-object).^2,2).^0.5;
idx=dis2obj<=range;

