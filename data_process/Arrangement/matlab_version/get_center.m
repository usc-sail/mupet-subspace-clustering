function [center,category_data,category_num] = get_center(data,label,K,feature,T,mode,NbRows)
%mode=1 center maximize the sum of cosine between certer and data(the mean of data) 
%mode=2 center maximize the sum of cosine^2 between center and data(center = U(:,1) [U,S,V] = svd(data))
%mode1 is faster than mode2
dim = size(data,1);
center = zeros(dim,K);
category_data = cell(K,1);
category_num = zeros(K,1);
nb_of_syllables = size(data,2);
raw_data = data;
%normalize the data first
%c0 is the mean energy of syllables
%c0 = norm(data,2)/sqrt(size(data,2));
c0 = 50;
for m=1:nb_of_syllables
    data(:,m) = data(:,m)/norm(data(:,m),2);
end

for i=1:K
    temlabel = (label==i);
    temdata = data(:,temlabel);
    tem_rawdata = raw_data(:,temlabel);
    category_data{i} = reshape(tem_rawdata,[feature,T,size(tem_rawdata,2)]); %save the raw data
    if mode==1 
        center(:,i) = mean(temdata,2);
    else
        [U,~,~] = svd(temdata);
        tem_center = U(:,1);
        if sum(tem_center)<0
            tem_center = -tem_center;
        end
        center(:,i) = tem_center;
    end
    category_num(i) = size(temdata,2);
end
center = center*c0;
[category_num,Index] = sort(category_num,'descend');
center = center(:,Index);
center = reshape(center,[feature,T,K]);
% for i=1:K
%     center(:,:,i) = refine_center(center(:,:,i),64,64,2); 
% end
category_data = category_data(Index);


NbUnits = K;
NbPatternFrames = T-1;
NbChannels = feature;
NbCols=floor(NbUnits/NbRows);
linebases_mat=zeros(NbChannels*NbRows,(NbPatternFrames+1)*NbCols);
linebases = cell(K,1);
for i=1:K
    linebases{i} = center(:,:,i);
end
number_of_calls = category_num;

for kk=1:NbRows
for ll=1:NbCols
  base_unit_normalized = linebases{(NbRows-kk)*NbCols+ll}./max(max(linebases{(NbRows-kk)*NbCols+ll}));
  linebases_mat((kk-1)*NbChannels+1:kk*NbChannels,(ll-1)*(NbPatternFrames+1)+1:ll*(NbPatternFrames+1))=base_unit_normalized;
end
end
figure
imagesc(linebases_mat,[0 0.85]); axis xy; hold on;
for kk=1:NbCols-1
plot([(NbPatternFrames+1)*kk+1,(NbPatternFrames+1)*kk+1],[1 NbRows*NbChannels],'Color',[0.2 0.2 0.2],'LineWidth',1);
end
for kk=1:NbRows-1
plot([1 size(linebases_mat,2)],[kk*NbChannels+1 kk*NbChannels+1 ],'Color',[0.2 0.2 0.2],'LineWidth',1);
end
cnt=0;
for kk=NbRows-1:-1:0
  for jj=0:NbCols-1
      cnt=cnt+1;
      text(double(floor(NbPatternFrames*.05)+jj*(NbPatternFrames+1)),(kk+1)*NbChannels-10,num2str(cnt));
      text(double(jj*(NbPatternFrames+1)+floor(NbPatternFrames*.05)),(kk+1)*NbChannels-(NbChannels-10),sprintf('%i',number_of_calls(cnt)));
  end
end
set(gcf, 'Color', 'w');
set(gca,'XTick',[]);
set(gca,'YTick',[]);
colormap pink; colormap(flipud(colormap));
str = strcat('N',num2str(K),' ','mode',num2str(mode));
title(str)
% for m=1:K
%     imagesc(center(:,:,m)); axis xy; colormap pink; colormap(flipud(colormap));%colorbar;
%     str  = strcat(num2str(m),'(',num2str(category_num(m)),')');
%     title(str);
% end

end