f=imread('1.jpg');

%���þ����ںϷ���
g=improved_mult_fusion(f);

%����ͼ�����������
g1=improved_mult_fusion(f,1);

figure

imshow(f);

figure

imshow([g,g1]);