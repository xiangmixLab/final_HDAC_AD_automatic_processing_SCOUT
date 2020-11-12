function treemap(Z,ncp,flag)

% Treemap plot for Agglomerative Clustering Output Only
%
%	TREEMAP(Z,NC,Flag)
%
% This plots NC clusters based on the cluster scheme given by Z
% in a treemap plot. Each rectangle corrresponds to a cluster
% of observations. 
%
% The optional argument FLAG determines whether or not the labels
% are added to the rectangles. The default is to display the labels.
% Any value for flag will cause them to NOT be displayed.
%
% NOTE: This does not implement the general case for treemap plots. This
% only does the case where each level is a binary split, as in
% agglomerative clustering. 
%
% NOTE: The matrix Z is generated by LINKAGE (MATLAB Statistics Toolbox)
% or MBCLUST, AMDEMCLUST (coming soon) or AGMBCLUST (Model-Based Clustering functions).

%   EDA Toolbox, April 2004

if nargin == 2
    % Then display the labels. 
    flag = 1;
elseif nargin ==3
    % Then do not display the labels.
    flag = 0;
end

% get the cases according to the clusters as in dendrogram.
% Tcd = cluster(Z,ncp);
figure
[H,Tcd] = dendrogram(Z,ncp);
cla

% Z is the output from the clustering in matlab.
Z = transz(Z);
Z(:,3) = [];   % already had this stripped - need it though.

clus = clus2struc(Z);
nc = length(Z(:,1))+1;	% Total number of cases.
plotpts = zeros(nc,2);	% Use these to store the points for plotting.
 
% We now need to get the rectangles by looping
% through the nodes in clus.
n = nc-1;	
% n represents the number of rows in the Z matrix.
% We have 2*n+1 records in the clus structure.
% Set the first one to the parent rectangle
clus(1).x = 0;
clus(1).y = 0;
clus(1).w = 100;
clus(1).h = 50;
clus(1).ctr = [clus(1).w/2, clus(1).h/2];
clus(1).split = 0;
% Now find all of the rectangles.
for i = 2:2:2*n
	% node number to the parent
	% use to get the information for the parent rectangle.
	par = clus(i).parent;
    split = clus(par).split;
	% Find the dimensions of the parent rectangle.
	xp = clus(par).x;
	yp = clus(par).y;
	wp = clus(par).w;
	hp = clus(par).h;
	nump = clus(par).numcases;
	% Get the proportions.
	propleft = clus(i).numcases/nump;
	propright = clus(i+1).numcases/nump;
    clus(i).split = 1-split;    
    clus(i+1).split = 1-split;
	if clus(i).split ~= 0
		% Then split on the x dimension.
		% Get the left child.
		% Lower left corner is the same.
		% Height is the same.
		clus(i).x = xp;
		clus(i).y = yp;
		clus(i).h = hp;
		% width is proportional to the size
		clus(i).w = wp*propleft;
		% Get the right child.
		% Lower left corner is offset in x from parent.
		% Height is the same. Y coordinate is the same.
		clus(i+1).x = xp+wp*propleft;
		clus(i+1).y = yp;
		clus(i+1).h = hp;
		% width is proportional to the size
		clus(i+1).w = wp*propright;
    else
		% Then split on the y dimension.
		% Get the left child.
		% Lower left corner is the same.
		% Width is the same.
		clus(i).x = xp;
		clus(i).y = yp;
		clus(i).w = wp;
		% Height is proportional to the size
		clus(i).h = hp*propleft;
		% Get the right child.
		% x coordinate is the same.
		clus(i+1).x = xp;
		% y is offset from left child.
		clus(i+1).y = yp + hp*propleft;
		% height is proportional to size
		clus(i+1).h = hp*propright;
		% width is the same
		clus(i+1).w = wp;
    end
end


rectangle('Position',[clus(1).x clus(1).y clus(1).w clus(1).h])
axis([0 100 0 50])
set(gca,'ticklength',[0 0],'xticklabel','','yticklabel','')

for i = 1:2*ncp-1
	rectangle('Position',[clus(i).x clus(i).y clus(i).w clus(i).h])
end
if flag == 1
    % Then display the labels
    for i = 1:(2*ncp-1)
        % Find all of the dendrogram labels from the cases in this 
        % cluster. They should all be the same - if it is a leaf. 
        tmp = unique(Tcd(clus(i).cases));
        % Now find it's group label in the dendrogram representation.
        if length(tmp) == 1
            txtlab = int2str(tmp);
            xc = clus(i).x + clus(i).w/2;
            yc = clus(i).y + clus(i).h/2;
            text(xc,yc,txtlab);
            
        end
    end
end
title(['Number of Clusters = ' int2str(ncp)])



%%%%%%%%%%%%%%%  FUNCTION CLUS2STRUC %%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% This function will convert a cluster structure that is obtained from
% the following commands:
% 	Y = pdist(X);
%	Z = linkage(Y);
%	Z = transz(Z);
%	Z(:,3) = [];
% This can be used in the cluster plotting procedure, where 
% rectangles are drawn for each cluster.
%
% function clus = clus2truc(Z)

function node = clus2struc(Z)

n = length(Z(:,1));	
% Get the information from numclus that is needed for the
% parent/child relationship.
numc = zeros(size(Z));
cases = cell(size(Z));
for i = n:-1:1
    [numc(i,1), cases{i,1}] = numclus(Z(1:i-1,:),Z(i,1));
    [numc(i,2), cases{i,2}] = numclus(Z(1:i-1,:),Z(i,2));  
end

cases = flipud(cases);
numc = flipud(numc);

% Set the first node.
node(1).numcases = n+1;	% has all of the cases
node(1).cases = 1:(n+1);	% These indices to the cases that are in this cluster.
node(1).parent = [];	% This is the parent of all.
node(1).left = 2;	
node(1).right = 3;
node(2).parent = 1;
node(3).parent = 1;

% this is for tracking purpose to find the children
inds = [(2:n);(2:n)];
inds = [0;inds(:)];
%inds = zeros(1,2*(n-1));
%inds(2:2:2*(n-1)) = 2:9;
for i = 2:2:2*(n-1)
	node(i).cases = cases{i/2,1};
	node(i+1).cases = cases{i/2,2};
	node(i).numcases = numc(i/2,1);
	node(i+1).numcases = numc(i/2,2);
	% Now find all of the children
	nc = node(i).numcases;
	j = inds(i);
	if nc > 1	% Then it has children
		t1 = node(i).cases;
		flag = 1;
		while flag
			% check j-th row of cases to see if matches
			test = cat(1,cases{j,:});
			if isempty(setxor(test,t1))
				% then these are the children
				node(i).left = 2*j;
				node(i).right = 2*j+1;
				% set their parent fields to i.
				node(2*j).parent = i;
				node(2*j+1).parent = i;
				flag = 0;
			end
			j = j+1;
		end
	end
	% Now find all of the children
	j = inds(i+1);
	nc = node(i+1).numcases;
	if nc > 1	% Then it has children
		t1 = node(i+1).cases;
		flag = 1;
		while flag
			% check j-th row of cases to see if matches
			test = cat(1,cases{j,:});
			if isempty(setxor(test,t1))
				% then these are the children
				node(i+1).left = 2*j;
				node(i+1).right = 2*j + 1;
				% then set their parent fields to i+1
				node(2*j).parent = i+1;
				node(2*j+1).parent = i+1;
				flag = 0;
			end
			j = j+1;
		end
	end
end
% Set the last two records to the right number of cases
% and fill in the observations that are in those records.
node(2*n).numcases = numc(n,1);
node(2*n+1).numcases = numc(n,2);
node(2*n).cases = cases{n,1};
node(2*n+1).cases = cases{n,2};


%%%%%%%%%%%%%%%%%   FUNCTION NUMCLUS %%%%%%%%%%%%%%%%
function [nclus, cases] = numclus(Z,k)

ind = find(Z(:,1)==k);
clus = Z(ind,:);
clus = clus(:);
clus = unique(clus);
tol = clus;
newclus = clus;
while ~isempty(tol)
    clus = newclus;
    observ = [];
    for i = 1:length(tol)
        j = tol(i);
        ind2 = find(Z(:,1)==j);
        obs = Z(ind2,:);
        observ = [obs(:); observ];
    end
    observ = [clus; observ];
    newclus = unique(observ);
    tol = setxor(clus, newclus);
end
nclus = length(newclus);
if nclus == 0
    nclus = 1;
    cases = k;
else
    cases = newclus;
end	
	
function Z = transz(Z)
%TRANSZ Translate output of LINKAGE into another format.
%   This is a helper function used by DENDROGRAM and COPHENET.  

%   In LINKAGE, when a new cluster is formed from cluster i & j, it is
%   easier for the latter computation to name the newly formed cluster
%   min(i,j). However, this definition makes it hard to understand
%   the linkage information. We choose to give the newly formed
%   cluster a cluster index M+k, where M is the number of original
%   observation, and k means that this new cluster is the kth cluster
%   to be formmed. This helper function converts the M+k indexing into
%   min(i,j) indexing.

m = size(Z,1)+1;

for i = 1:(m-1)
    if Z(i,1) > m
        Z(i,1) = traceback(Z,Z(i,1));
    end
    if Z(i,2) > m
        Z(i,2) = traceback(Z,Z(i,2));
    end
    if Z(i,1) > Z(i,2)
        Z(i,1:2) = Z(i,[2 1]);
    end
end


function a = traceback(Z,b)

m = size(Z,1)+1;

if Z(b-m,1) > m
    a = traceback(Z,Z(b-m,1));
else
    a = Z(b-m,1);
end
if Z(b-m,2) > m
    c = traceback(Z,Z(b-m,2));
else
    c = Z(b-m,2);
end

a = min(a,c);


