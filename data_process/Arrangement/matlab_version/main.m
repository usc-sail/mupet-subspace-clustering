rng default %set random seed

data_file = 'segmented_data.mat';

if exist(data_file,'file')==0  %build dataset first if we do not have it
    run segmented_data
end

data = load(data_file);
X = data.inlier_newV; %do sparse subspace clustering on inlier dataset
lambda = 0.1*100; %set lambda for lasso
lambda = lambda/(size(X,1)-1);
X = X./sqrt(sum(X.^2)); %normalize to unit vector
%note: normalize the data will speed up the lasso 
%with three times acceleration
CMat = sparse_regression(X,lambda); %build coefficient matrix using sparse_regression
CMat(CMat<0) = 0; %negative coefficients are illegal

thres = 0.001; %set a small threshold 
CKSym = CMat+CMat';
CKSym(CKSym<thres) = 0;
DN = diag(1./sqrt(sum(CKSym)));
LapN = DN*CKSym*DN; %build normalized laplacian matrix
[V,D] = eig(LapN); %solve eigenvalue
D = diag(D); % in descent order

K = 40;
Embed = V(:,1:K); 
Embed = Embed./sqrt(sum(Embed.^2)); %normalize the eigenvecter
[label,C] = kmeans(Embed,K,'Distance','sqeuclidean','Replicates',20);

label = arrange_label(label);

NbRows = 5;
[center,category_data,category_num] = look_center_fun(X,label,NbRows);

%visualize the result using t-sne
Y = tsne(Embed);
figure
gscatter(Y(:,10),Y(:,2),label)
