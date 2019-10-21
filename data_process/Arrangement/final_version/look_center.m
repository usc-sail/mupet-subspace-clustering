data_file = 'C57_segmented_data.mat';
%data_file = 'DBA_segmented_data_subset.mat';
m = load(data_file);
V = m.inlier_newV; 
out_V = m.outlier_newV;
%V = m.inlier_V; 
%V = m.V;
%label_file = 'DBA_subset_label_clean_SSC_40.mat';
%label_file = 'C57_label_clean_SSC_40.mat';
l = load(label_file);
label = l.label;
inliers = l.inliers;
inliers = (inliers==1);
outliers = (~inliers);
data = V(:,inliers);
out_data = V(:,outliers);
out_V = [out_V,out_data];
%data = V;
feature = 64;
T = size(data,1)/feature;
mode = 1;

K = max(label); %labels start from 1
count_label = zeros(K,1);

for i=1:K  %count the syllables of each cluster
    count_label(i) = sum(label==i);
end
[~,I] = sort(count_label,'descend'); %sort according to number of syllables
tem_label = zeros(size(label));
for i=1:K  % let the first cluster has the most syllables
    old = I(i);
    tem_label(label==old) = i;
end
label = tem_label;
NbRows = 5;
[center,category_data,category_num] = show_center(data,label,K,feature,T,mode,NbRows);
center = reshape(center,[64*size(center,2),K]);
d = pdist(center','cosine');
mean_d = 1/mean(1./d);
std_d = std(d);
disp(mean_d)
disp(std_d)

out_V(:,sum(out_V.^2)<10) = [];

D = pdist2(center',out_V','cosine');
[~,I] = min(D);
total_data = [data,out_V];
total_label = [label,I];
[total_center,total_category_data,total_category_num] = show_center(total_data,total_label,K,feature,T,mode,NbRows);
total_center = reshape(total_center,[64*size(total_center,2),K]);
total_d = pdist(total_center','cosine');
total_mean_d = 1/mean(1./total_d);
total_std_d = std(total_d);
disp(total_mean_d)
disp(total_std_d)