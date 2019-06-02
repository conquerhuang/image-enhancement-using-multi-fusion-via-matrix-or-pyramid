function [ g ] = improved_mult_fusion( f,using_pyr,varargin )
%code for paper a fusion-based enhancing method for weakly illuminated
%images
%   fΪ����ͼ��
%   using_pyr,Ϊ1ʱ���ý�������ʽ�����ںϣ�Ϊ0ʱ���þ����ںϷ�ʽ�����ں�
%   window_1Ϊ��̬ѧ������Բ�̴�С
%   alphaΪ����ڶ��Ź���ͼʱ��Ҫ�õ��Ĳ���used to preserve the color opponency
%   fai�Աȶ�Ȩ�ؽ�ֹ�ǣ����û����ƣ�
%   layer���ý������任ʱ�Ľ���������
%   ����ͼ�񾭴��������0-1��������ʽ
    if nargin==1
        using_pyr=0;
    end
    [window_1,alpha,fai,layer]=processinputs(varargin{:});
    f=mat2gray(f);
    f_hsv=rgb2hsv(f); %���ԭͼ��HSV���ͼ��
    %��ù���ͼ
    [I1,I2,I3]=illumination_map_get(f_hsv(:,:,3),window_1);
    reflect=f./I1;
    %����Ȩ��
    [w1_final,w2_final,w3_final]=weight_cal(I1,I2,I3,f_hsv,alpha,fai);
    %���������ں�
    if using_pyr
        I_final=layer_fusion (w1_final,w2_final,w3_final,I1,I2,I3,layer);
        figure
        I_final=I_final.*1.6;
        I_final=I_final+0.6;
%        imhist(I_final);
        g=reflect.*I_final;
    else
        I_fusion=I1.*w1_final+I2.*w2_final+I3.*w3_final;
%        I_fusion=imadjust(I_fusion,[0,1],[0,1],0.75);
        g=reflect.*I_fusion; 
    end
    
end

%--------------------------------------------------------------------------
%����������ֱ�����˹�任�͸���Ҷ�任��������������ı任����Լ�����������һ��
function [F] = layer_fusion (w1,w2,w3,i1,i2,i3,layer)
   %���ɸ�˹�˲�����������˹�˲�����

   %����Ȩ��ͼ��˹������
    w1n=impyr_gau(w1,layer);
    w2n=impyr_gau(w2,layer);
    w3n=impyr_gau(w3,layer);
    %���ɹ���ͼ������˹������
    i1n=impyr_lapcian(i1,layer);
    i2n=impyr_lapcian(i2,layer);
    i3n=impyr_lapcian(i3,layer);
    %��ÿһ������� ����������˹���Ȩ�ظ�˹��ֱ���˵õ�ÿһ����ںϹ���ͼF
    Fn=cell(layer,1);
    for i=1:layer
        Fn{i}=w1n{i}.*i1n{i}+w2n{i}.*i2n{i}+w3n{i}.*i3n{i};
    end
    %����Ӧ����ںϹ���ͼ�����������㣬�õ����յ��ںϹ���ͼ
    for i=layer-1:1
        Fn{i}=impyramid(Fn{i+1},'expand');+Fn{i};
    end
    F=Fn{1};
end

function [g]=impyr_lapcian(f,layer)
    %�����ɸ�˹������������ɸ�˹����������lapcian������
    g=impyr_gau(f,layer);
    for i=layer-1:-1:1
        temp=impyramid(g{i+1},'expand');
        [m,n]=size(temp);
        [m1,n1]=size(g{i});
        if (m1>m)||(n1>n)
            temp=padarray(temp,[m1-m,n1-n],'replicate','post');
        end
        g{i}=g{i}-temp;
    end
end

function [g]=impyr_gau(f,layer)
    g=cell(layer,1);
    g{1}=f;
    for i=2:1:layer
        g{i}=impyramid(g{i-1},'reduce');
    end
end


%--------------------------------------------------------------------------
function [w1_final,w2_final,w3_final]=weight_cal(I1,I2,I3,f_hsv,alpha,fai)
    sigma=0.7;
    w1_b=exp(-(I1-sigma).^2/(2*0.3^2));
    w1_c=I1.*(1+cos(alpha*f_hsv(:,:,1)+fai).*f_hsv(:,:,2));
    w1=w1_b.*w1_c;
    
    w2_b=exp(-(I2-sigma).^2/(2*0.25^2));
    w2_c=I2.*(1+cos(alpha*f_hsv(:,:,1)+fai).*f_hsv(:,:,2));
    w2=w2_b.*w2_c;
    
    w3_b=exp(-(I3-sigma).^2/(2*0.25^2));
    w3_c=I3.*(1+cos(alpha*f_hsv(:,:,1)+fai).*f_hsv(:,:,2));
    w3=w3_b.*w3_c;
    
    w_sum=w1+w2+w3;
    w_sum(w_sum==0)=0.005;%��ֹ���ֳ�������
    w1_final=w1./w_sum;
    w2_final=w2./w_sum;
    w3_final=w3./w_sum; 
end
%--------------------------------------------------------------------------
function [I1,I2,I3]=illumination_map_get(V,window_1)
    %��ȡ����ͼI1
    mode=generate_circle(window_1);
    I=imerode(  imdilate(V,mode)  ,mode);
%    I1=imguidedfilter(I,V);
    I1=guidedfilter(V,I,window_1*2,10.^(-6));
    %��ȡ����ͼI2
    I_mean=mean(I(:));
    lamuda=10+(1-I_mean)/I_mean;
    I2=2/pi*(atan(lamuda*I));
    %��ȡ����ͼI3
    I3=adapthisteq(I1,'NumTiles',[8,8],'ClipLimit',0.02);%�о�����ֲ��Աȶ�û�еõ���ֵ���ǿ
   
    
end
%--------------------------------------------------------------------------
function [window_1,alpha,fai,layer]=processinputs(varargin)
    %Ĭ�ϲ�����ʼ��
    window_1=7;
    alpha=2;
    fai=250/360*2*pi;
    layer=8;
    if nargin>0
        window_1=varargin{1};
    end
    if nargin>1
        alpha=varargin{2};
    end
    if nargin>2
        fai=varargin{3};
    end
    if nargin>3
        layer=varargin{4};
    end
end





