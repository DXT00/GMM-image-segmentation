%预处理彩色图像，将分割目标弄得明显一点
% I = imread('snap29.jpg');
% imshow(I);
% impixelinfo;
function [I] = preprocess(I)

%中间过程截图
dir = 'E:\研一所有课件\现代信号处理\Project Team6\GMM - try\int\';

persistent filename ;
if isempty(filename)
        filename = 0;
end

%拉普拉斯核
h =[-1,-1,-1;-1,8,-1;-1,-1,-1];                                  
laplaceImg =imfilter(I,h); 
show_write_image(laplaceImg,dir,filename,"laplaceImg",false);

%锐化后图像
sharpImg=I+laplaceImg;
show_write_image(sharpImg,dir,filename,"sharpImg",false);


I_R = sharpImg(:,:,1);
I_G = sharpImg(:,:,2);
I_B = sharpImg(:,:,3);

row = size(I,1);
column = size(I,2);

%该值越大，红色越强烈
diff_r = 35;
for i = 1:row
    for j = 1:column
        %提取红色通道，使红色的地方变黑
        if I_R(i,j)-I_G(i,j)>diff_r &&I_R(i,j)-I_B(i,j)>diff_r
            I_R(i,j)=0;
        end
         %使深灰色的地方变黑
        if I_R(i,j)<40 &&I_B(i,j)<40&&I_G(i,j)<40
            I_R(i,j)=0;
        end
    end
end
show_write_image(I_R,dir,filename,"binaryImg of RedChannel",false);


%对比度调整
filename=filename+1;
show_write_image(I_R,dir,filename,"I_R",false);
I_R = imadjust(I_R,[0.0 0.4],[],3.0);
filename=filename+1;
show_write_image(I_R,dir,filename,"R",false);
filename=filename+1;
show_write_image(I_G,dir,filename,"I_G",false);
I_G = imadjust(I_G,[0.0 0.5],[],8);
filename=filename+1;
show_write_image(I_G,dir,filename,"G",false);
filename=filename+1;
show_write_image(I_B,dir,filename,"I_B",false);
I_B = imadjust(I_B,[0.0 0.4],[],1.0);
filename=filename+1;
show_write_image(I_B,dir,filename,"B",false);

%I_R相当于mask,混合调整对比度后的Blue和Green通道
I_B=(I_B+I_R)./2;
filename=filename+1;
show_write_image(I_B,dir,filename,"avgIB",true);

I_G=(I_G+I_R)./2;
filename=filename+1;
show_write_image(I_G,dir,filename,"avgIG",true);


I(:,:,1) = I_R;
I(:,:,2) = I_G;
I(:,:,3) = I_B;
% figure,imshow(I),title('preprocess');
%转换到LAB空间
% cform = makecform('srgb2lab');
% I = applycform(im2,cform);
% figure,imshow(I),title('lab_I');
% figure,imshow(I(:,:,1)),title('lab_I1');
% figure,imshow(I(:,:,2)),title('lab_I2');
% figure,imshow(I(:,:,3)),title('lab_I3');
%转换到HSV空间
% I = rgb2hsv(I);
% figure,imshow(I),title('hsv_I');
% imwrite(I,'I.jpg');
end