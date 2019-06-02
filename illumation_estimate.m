function [ g_r,g_i ] = illumation_estimate( f )
%将输入图像分解为光照图和反射图
%   输入图像f g_r为反射图  g_i为光照图
f=mat2gray(f);

%从三个通道中获取最大的值作为初步光照图
V=max(f,[],3);
%对初步光照图做闭运算得到平滑光照图
I=bwmorph(V,'close');

%对平滑光照图由HSV域的V通道作为导向滤波的引导图像进行导向滤波得到光照图I1
I1=imguidedfilter(I,V);
end





