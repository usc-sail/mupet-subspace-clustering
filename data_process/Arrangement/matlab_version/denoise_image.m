function repic = denoise_image(pic,rx,ry)
% this function denoise and normalize the picture of raw syllable
% [rx,ry] is the standard size of picture
% pic is the input syllable picture
[K,T] = size(pic);

%remove the zeros at left and right side
begin_t = 1;
end_t = T;
energy = sum(pic.^2);
thres = 0.0001;
while energy(begin_t)<thres
    begin_t = begin_t+1;
end
while energy(end_t)<thres
    end_t = end_t-1;
end
repic = pic(:,begin_t:end_t);

band_energy = sum(repic.^2,2);
repic = repic(band_energy>mean(band_energy),:);  %eliminate low energy band

%resize the picture to the standard size
repic = imresize(repic,[rx,ry]);

repic = repic-min(min(repic));  %let the smallest bin to be zero
repic(repic<1.5*mean(mean(repic))) = 0; % eliminate low energy frequency bin

thres = 10;
repic = squeeze_image(repic,thres); % eliminate the low energy band an frame

repic(repic<1.5*mean(mean(repic))) = 0;  % eliminate low energy frequency bin again
repic = imresize(repic,[rx,ry]);  %resize to standard size
end