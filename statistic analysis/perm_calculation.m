function perm=perm_calculation(group)
 perm=[];
 for p = 1:length(unique(group))
     perm = [perm;find(group == p)];
 end
