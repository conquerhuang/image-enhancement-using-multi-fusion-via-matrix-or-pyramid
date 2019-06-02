%Analysis of the causes of distortion
% 生成结构或纹理变换图和平滑过度图，分别在CLAHE算法进行运行
% 将得到的结果进行对比
pic_1=ones(300,400);
pic_2=ones(300,400);
for i=1:1:300
   for j=1:1:400
       pic_1(i,j)=1+0.3*sin(j*pi/20);
       pic_2(i,j)=1*(i.^2+j.^2)^(1/2)/500;
   end
end


clahe_1=adapthisteq(pic_1,'NumTiles',[10,10],'ClipLimit',0.1);
clahe_2=adapthisteq(pic_2,'NumTiles',[10,10],'ClipLimit',0.1);
figure
imshow([pic_1,pic_2;clahe_1,clahe_2]);

[pic1_grad_x,pic1_grad_y]=gradient(pic_1);
pic1_grad=(pic1_grad_x.^2+pic1_grad_y.^2).^(1/2);

[pic2_grad_x,pic2_grad_y]=gradient(pic_2);
pic2_grad=(pic2_grad_x.^2+pic2_grad_y.^2).^(1/2);

figure
subplot(121);mesh(pic1_grad);
subplot(122);mesh(pic2_grad);


