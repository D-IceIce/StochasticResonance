clc;
clear;
close all;

imgpath = 'images/seq1/';
saveDir = 'results/seq1/';
if ~exist(saveDir, 'dir'), mkdir(saveDir); end


imgDir = dir([imgpath '*.bmp']);
len = length(imgDir);
for mm = 1:len
    img(:,:,mm) = imread([imgpath num2str(mm) '.bmp']);
end
img = double(img)/255;

a = 2*std(img,0,3);
b = 0.8*4*a.^3/27;
h = 1.5;
Iter = 20;
lambda = 0.01;

for ii = 1:len
    ori = img(:,:,ii);
    aver = mean(ori);
    re = zeros(size(ori));

    for kk = 1:Iter
        % 随机共振项
        resonance = a .* re - b .* re.^3 + ori - aver;

        % TV项
        [gradX, gradY] = gradient(re);
        tv_term = divergence(gradX, gradY);

        re = re + h * (resonance - lambda * tv_term);
    end

    re = re + aver;
    imwrite(bwfunc(re-ori), [saveDir, num2str(ii),'.bmp']);
end
