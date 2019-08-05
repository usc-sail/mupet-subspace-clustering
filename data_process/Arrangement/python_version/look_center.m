data_file = 'segmented_data.mat';

m = load(data_file);
V = m.inlier_newV; 
label_file = 'C57_label_tem.mat';
l = load(label_file);
label = l.label;
inliers = l.inliers;
data = V(:,inliers);
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

