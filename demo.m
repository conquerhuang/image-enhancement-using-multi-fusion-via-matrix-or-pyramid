f=imread('1.jpg');

%采用矩阵融合方法
g=improved_mult_fusion(f);

%采用图像金字塔方法
g1=improved_mult_fusion(f,1);

figure

imshow(f);

figure

imshow([g,g1]);