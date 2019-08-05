function new_label = arrange_label(label)
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
new_label = tem_label;
end