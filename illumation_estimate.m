function [ g_r,g_i ] = illumation_estimate( f )
%������ͼ��ֽ�Ϊ����ͼ�ͷ���ͼ
%   ����ͼ��f g_rΪ����ͼ  g_iΪ����ͼ
f=mat2gray(f);

%������ͨ���л�ȡ����ֵ��Ϊ��������ͼ
V=max(f,[],3);
%�Գ�������ͼ��������õ�ƽ������ͼ
I=bwmorph(V,'close');

%��ƽ������ͼ��HSV���Vͨ����Ϊ�����˲�������ͼ����е����˲��õ�����ͼI1
I1=imguidedfilter(I,V);
end





