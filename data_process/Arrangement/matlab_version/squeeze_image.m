function newpic = squeeze_image(pic,thres)
newpic = pic(:,sum(pic)>thres); %eliminate the low energy frame
newpic = newpic(sum(pic,2)>thres,:); %eliminate the low energy frequency band
newpic = imresize(newpic,size(pic)); %resize to the original picture size
end