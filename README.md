# MUPET: Sparse subspace clustering
This repo contains code to cluster mice vocalizations using sparse subspace clustering.

## Instructions
1. Download a sample dataset from [here](https://github.com/mvansegbroeck/mupet/wiki/MUPET-wiki).
1. Preprocess the data
    - Use [MUPET](https://github.com/mvansegbroeck/mupet) to create a dataset
    - Load `workplace/datasets/~.mat` and run `prepare_data.m` to collect the syllables detected by MUPET
    -  A file such as `C57_all_RUs.mat` is generated
    -  **Note**: for the DBA dataset, we only use the first 9000 syllables
    - Run `segment_whole_dataset.m` to separate the whole dataset into inlier dataset and outlier dataset

2. Do clustering
you can use jupyter notebook "main" to get result step by step

3. Plot centers and cluster outliers
run `look_center.m` to depict the cluster centers
