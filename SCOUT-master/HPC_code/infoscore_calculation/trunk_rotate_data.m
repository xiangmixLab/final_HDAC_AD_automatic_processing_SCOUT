function dat1=trunk_rotate_data(dat,rotate_leng,dir)


if rotate_leng>size(dat,2)
    rotate_leng=rotate_leng-floor(rotate_leng/size(dat,2))*size(dat,2);
end


if isequal(dir,'left')
    dat_part1=dat(:,1:rotate_leng-1);
    dat_part2=dat(:,rotate_leng:end);
    dat1=[dat_part2,dat_part1];
end
if isequal(dir,'right')
    dat_part1=dat(:,1:end-rotate_leng);
    dat_part2=dat(:,end-rotate_leng+1:end);
    dat1=[dat_part2,dat_part1];
end