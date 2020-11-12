function [dist,mass_rem]=KLDiv_ori(P,Q)

%2Dimensional


P=P/sum(sum(P));
Q=Q/sum(sum(Q));

%Find mutual support
supp_P=find(P>0);
supp_Q=find(Q>0);
inter=intersect(supp_P,supp_Q);
out=setdiff(1:size(P,1)*size(P,2),inter);

% if sum(Q(out))>.1
% disp(horzcat('warning: removed mass Q', num2str(sum(Q(out)))));
% end
% if sum(P(out))>.1
%     disp(horzcat('warning: removed mass P', num2str(sum(P(out)))));
% end
mass_rem=max(sum(Q(out)),sum(P(out)));
P=P/sum(sum(P));
Q=Q/sum(sum(Q));
    dist=0;

for i=squeeze(inter')
    dist=dist+P(i)*log2(P(i)/Q(i))+Q(i)*log2(Q(i)/P(i));
end
dist=dist/2;


