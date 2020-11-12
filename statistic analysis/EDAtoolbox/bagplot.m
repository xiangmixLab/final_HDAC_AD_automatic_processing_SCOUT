function bagplot

% BAGPLOT A bivariate box-and-whisker plot
%
%   NOTE!!
%   You must run bagmat.exe in the current directory. See the HELP file on
%   bagmat.exe for more information.
%
%   You call BAGPLOT to get a default bagplot with
%   shading, no fence and all points displayed. 


% Converted original .m script file to a function. Updated for newer
% version of Matlab, where delauney and convhull functions no longer take
% the third argument.

% Obtained from:
% Rousseeuw, P, J., I. Ruts, and J. W. Tukey. 1999. “The bagplot: A bivariate boxplot,” 
% The American Statistician, 53:382-387.

try
    bag=load('interpol.dat');
catch
    error('interpol.dat must be in the current directory')
end
try
    datatyp=load('datatyp.dat');
catch
    error('datatyp.dat must be in the current directory')
end
try
    tukm=load('tukmed.dat');
catch
    error('tukmed.dat must be in the current directory')
end

bag=load('interpol.dat');
datatyp=load('datatyp.dat');
tukm=load('tukmed.dat');
hold off
%Use the following 4 lines to draw the fence
%fence=bag;
%fence(:,1)=(3*(bag(:,1)-tukm(1)))+tukm(1);
%fence(:,2)=(3*(bag(:,2)-tukm(2)))+tukm(2);
%fill(fence(:,1),fence(:,2),'w','LineStyle','- -')
hold on
i=find(datatyp(:,3)<3);
data=datatyp(i,1:2);
i=find(datatyp(:,3)>=3);
outl=datatyp(i,1:2);
plak=[data;bag];
tri=delaunay(plak(:,1),plak(:,2));
k=convhull(plak(:,1),plak(:,2));
whisk=plak(k,1:2);
fill(whisk(:,1),whisk(:,2),[0.8 0.8 1],'LineStyle','none')
%text(whisk(:,1),whisk(:,2),num2str(k));
%fill(bag(:,1),bag(:,2),'w') (Use this line to omit the shading of the bag)
fill(bag(:,1),bag(:,2),[0.6 0.6 1])%This line should be placed after the command plot(data...) to only plot the data outside the bag
axis square
plot(data(:,1),data(:,2),'o','MarkerFaceColor','k','MarkerEdgeColor','k','Markersize',4)
plot(outl(:,1),outl(:,2),'hk','MarkerFaceColor','k','Markersize',8)
plot(tukm(1),tukm(2),'o','MarkerFaceColor','w','MarkerEdgeColor','w','MarkerSize',10);
plot(tukm(1),tukm(2),'+k','Markersize',8)
xmin=min(datatyp(:,1));
xmax=max(datatyp(:,1));
small=0.05*(xmax-xmin);
xaxis1=xmin-small;
xaxis2=xmax+small;
ymin=min(datatyp(:,2));
ymax=max(datatyp(:,2));
small=0.05*(ymax-ymin);
xaxis3=ymin-small;
xaxis4=ymax+small;
axis([xaxis1 xaxis2 xaxis3 xaxis4]);
box on;