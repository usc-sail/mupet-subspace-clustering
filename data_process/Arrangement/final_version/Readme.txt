1. Generate the data
1.1 use mupet to create a dataset
1.2 load workplace/datasets/~.mat and run prepare_data.m to collect the syllables detected by mupet
after 1.2, C57_all_RUs.mat is generated(note: for DBA dataset, we only use first 9000 syllables)
1.3 run segment_whole_dataset.m to separate the whole dataset into inlier dataset and outlier dataset

2.Do clustering
you can use jupyter notebook "main" to get result step by step

3.Plot centers and cluster outliers
run look_center.m to depict the cluster centers
