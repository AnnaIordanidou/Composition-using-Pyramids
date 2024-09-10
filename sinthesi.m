clear all; clc; 

img1 = im2double(imread('cat.jpg'));
img2 = im2double(imread('dog1.jpg'));
img3 = im2double(imread('dog2.jpg'));
img4 = im2double(imread('P200.jpg'));
img5 = im2double(imread('bench.jpg'));
img6 = im2double(imread('imaret.jpg'));

[M, N, ~] = size(img1);
img2 = imresize(img2, [M N]);
img3 = imresize(img3, [M N]);
img4 = imresize(img4, [M N]);
img5 = imresize(img5, [M N]);
img6 = imresize(img6, [M N]);


level = 5;

centerX = M / 2;
centerY = N / 2;

angle = 2 * pi / 6; 
masks = zeros(M, N, 6);

blurh = fspecial('gauss',30,15); 

for k = 1:6
    [Y, X] = ndgrid(1:M, 1:N);
    angles = atan2(Y - centerY, X - centerX) + pi; 
    minAngle = (k-1) * angle;
    maxAngle = k * angle;
    masks(:,:,k) = (angles > minAngle) & (angles <= maxAngle);
    masks(:,:,k) = imfilter(masks(:,:,k),blurh,'replicate');
end

limg = cell(1,6);
limg{1} = genPyr(img1,'lap',level);
limg{2} = genPyr(img2,'lap',level);
limg{3} = genPyr(img3,'lap',level);
limg{4} = genPyr(img4,'lap',level);
limg{5} = genPyr(img5,'lap',level);
limg{6} = genPyr(img6,'lap',level);

limgo = cell(1, level);
for p = 1:level
    blendedLevel = zeros(size(limg{1}{p}));
    for k = 1:6
        maskResized = imresize(masks(:,:,k), 'OutputSize', [size(limg{k}{p}, 1), size(limg{k}{p}, 2)]);
        blendedLevel = blendedLevel + limg{k}{p} .* maskResized;
    end
    limgo{p} = blendedLevel;
end

imgo = pyrReconstruct(limgo);
figure, imshow(imgo);
title('Final image');


