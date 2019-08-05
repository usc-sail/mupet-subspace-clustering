function [center,category_data,category_num] = look_center_fun(data,label,NbRows)
%this is a functional version of look_center.m
%input: the data and corresponding label
%NbRows : number of rows when drawing the picture, 
%typically you can set NbRows=5

%output: center: the mean of each cluster
%category_data(a tuple): the syllables of each cluster
%category_num: the number of cluster


feature = 64;
T = size(data,1)/feature;
mode = 1;
label = arrange_label(label);
[center,category_data,category_num] = get_center(data,label,K,feature,T,mode,NbRows);
end


