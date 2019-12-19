%预处理彩色图像，将分割目标弄得明显一点
% I = imread('snap29.jpg');
% imshow(I);
% impixelinfo;
function [I] = preprocess(I)

dir = 'C:\Users\DXT00\Desktop\gmm_imagr\int\';

persistent filename ;
if isempty(filename)
        filename = 0;
end


h =[-1,-1,-1;-1,8,-1;-1,-1,-1];                                  
im1 =imfilter(I,h); 
figure;
imshow(im1); 
title('2：拉普拉斯操作后图像');

%---图3，由于使用的模板如上，让常数c=1，简单的将原图和图2相加就可以得到一幅经过锐化过的图像。

 im2=I+im1;
 figure;
 imshow(im2);
 title('3:1图和2图相加后图像');


I_R = im2(:,:,1);
figure;imshow(I_R);
I_G = im2(:,:,2);
% figure;imshow(I(:,:,3));
I_B = im2(:,:,3);
row = size(I,1);
column = size(I,2);


diff_r = 35;
for i = 1:row
    for j = 1:column
        if I_R(i,j)-I_G(i,j)>diff_r &&I_R(i,j)-I_B(i,j)>diff_r
            I_R(i,j)=0;
        end
        if I_R(i,j)<40 &&I_B(i,j)<40&&I_G(i,j)<40
            I_R(i,j)=0;
        end
    end
end
show_write_image(I_R,dir,filename,"binaryIR");
filename=filename+1;


show_write_image(I_R,dir,filename,"I_R");
I_R = imadjust(I_R,[0.0 0.4],[],3.0);
filename=filename+1;
show_write_image(I_R,dir,filename,"R");
filename=filename+1;
show_write_image(I_G,dir,filename,"I_G");
I_G = imadjust(I_G,[0.0 0.5],[],8);
filename=filename+1;
show_write_image(I_G,dir,filename,"G");
filename=filename+1;
show_write_image(I_B,dir,filename,"I_B");
I_B = imadjust(I_B,[0.0 0.4],[],1.0);
filename=filename+1;
show_write_image(I_B,dir,filename,"B");

I_B=(I_B+I_R)./2;
filename=filename+1;
show_write_image(I_B,dir,filename,"avgIB");

I_G=(I_G+I_R)./2;
filename=filename+1;
show_write_image(I_G,dir,filename,"avgIG");


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