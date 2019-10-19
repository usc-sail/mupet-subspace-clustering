file = 'C57_all_RUs.mat';
V = load(file);
V = V.V;
% parameter of syllables extracted by mupet
feature = 64;
T = 126;

nb_syllables = size(V,2);
V = reshape(V,[feature,T,nb_syllables]);

%standard picture shape
rx = 64;
ry = 64;

newV = zeros(rx,ry,nb_syllables); %store the denoised and normalized syllables
for i=1:nb_syllables
    pic = V(:,:,i); %get a certain syllable
    newpic= denoise_image(pic,rx,ry); % denoise and normalize it
    newV(:,:,i) = newpic; % save the denoised and normalized syllable
    
    %you can check the denoised and normalized syllables here
    %remember to set a break point or use pause
    
%     figure(1); imagesc(pic); axis xy;
%     figure(2); imagesc(newpic); axis xy;
%     pause
end


%correlation_similarity_1_without_move = @(pic1,pic2)sum(sum(pic1.*pic2))/norm(pic1,'fro')/norm(pic2,'fro');

%newS = Inner_similarity(newV,correlation_similarity_1_without_move);
%newS = newS-eye(nb_syllables);

temdata = reshape(newV,[rx*ry,nb_syllables]);
%S means similarity here
newS = pdist2(temdata',temdata','cosine');
newS = newS+eye(nb_syllables);
minS = min(newS);

S = minS<0.2; %index of cc smaller than 0.2

count_inlier = sum(S);
disp(strcat('inlier nb: ',num2str(count_inlier)))
count_outlier = nb_syllables-count_inlier;
disp(strcat('outlier nb: ',num2str(count_outlier)))

V = reshape(V,[feature*T,nb_syllables]);
newV = reshape(newV,[rx*ry,nb_syllables]);

inlier_V = V(:,S);
outlier_V = V(:,~S);
inlier_newV = newV(:,S);
outlier_newV = newV(:,~S);
file = 'C57_segmented_data.mat';
save(file,'inlier_V','outlier_V','inlier_newV','outlier_newV');

