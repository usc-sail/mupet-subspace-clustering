%first load workplace/datasets/....mat
NbChannels = 64;
NbPatternFrames = 125;
folder = dataset_dir;
V = [];
L = [];
for i=1:length(dataset_content)
    file = strcat(folder,'/',dataset_content{i});
    syllable_data = load(file);
    filestats =  syllable_data.filestats;
    syllable_stats = syllable_data.syllable_stats;
    syllable_data = syllable_data.syllable_data;
    Vi = mk_input_repertoire_learning(syllable_data(2,:), NbChannels, NbPatternFrames, filestats.TotNbFrames);
    V=[V Vi];
    L(i) = size(Vi,2);
end
savefile = 'C57_all_RUs.mat';
save(savefile,'V')