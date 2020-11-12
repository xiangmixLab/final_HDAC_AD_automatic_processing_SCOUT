function sem_res=sem(dat)

sem_res=std(dat(:))/(size(dat,1)*size(dat,2))^0.5;