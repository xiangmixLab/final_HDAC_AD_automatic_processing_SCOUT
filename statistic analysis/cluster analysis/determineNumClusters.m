function [eigenvalues,numCluster0,numCluster] = determineNumClusters(CM)
% Estimation of the number of clusters from the consensus matrix
%
% Input:
%   -- CM: consensus matrix constructed from a cluster range, e,g. 2-30
% Output:
%   -- eigenvalues: eigenvalues of the graph Laplacian of the truncated consensus matrix.
%   -- numCluster0: the minimum number of clusters inferred
%   -- numCluster: Number of clusters inferred
%
tol = 0.01;
numEigs = min(100,size(CM,1));
n=size(CM,2);
D = diag(CM*ones(n,1));
Prw = eye(n) - D^(-1/2)*CM*D^(-1/2);
all_eigs = real(eigs(Prw,numEigs,'sm'));
ZZ = sort(abs(real(all_eigs)));
numCluster0 = length(find(ZZ<=tol));

if numCluster0 <= 5
    tau = 0.3;
elseif numCluster0 <= 10
    tau = 0.4;
else
    tau = 0.5;
end

CM(CM <= tau) = 0;

D = diag(CM*ones(n,1));
Prw = eye(n) - D^(-1/2)*CM*D^(-1/2);
all_eigs = real(eigs(Prw,numEigs,'sm'));

zz = sort(abs(real(all_eigs)));

gap = zz(2:end) - zz(1:end-1);
[~,numCluster] = max(gap);


numCluster0 = length(find(zz<=tol));
display('Number of cluster based on zero eigenvalues & Largest gap ');
display([numCluster0 numCluster]);

eigenvalues = zz;

figure;
scatter(1:min([30 size(eigenvalues,1)]),eigenvalues(1:min([30 size(eigenvalues,1)])),20,'filled');
box on;
set(gca,'LineWidth',1.5);
xlabel('Number of clusters');
ylabel('Eigenvalue of graph Laplacian \lambda_i');
set(gca,'FontName','Arial');
set(gca,'FontSize',12);
