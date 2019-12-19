function[I_bond] = postprocess(orign_IMG,multi_IMG) 

row = size(multi_IMG,1);
column = size(multi_IMG,2);

%ȥ��С���
pixel_labels = bwareaopen(multi_IMG,20000);
pixel_labels = bwareaopen(1 - pixel_labels,20000);
% figure;imshow(pixel_labels);title('ȥ��С���');

%����
se = strel('square',10);
pixel_labels=imdilate(pixel_labels,se);
pixel_labels=imdilate(1 - pixel_labels,se);
% figure;imshow(pixel_labels);title('����');

%��ֵ�˲�
pixel_labels=medfilt2(pixel_labels,[10,10]);
% figure;imshow(pixel_labels);title('��ֵ�˲��⻬��Ե');

%��ԭͼ�����չʾ�ָ�����
I_bond = im2double(orign_IMG);
I_1 = I_bond(:,:,1);
I_2 = I_bond(:,:,2);
I_3 = I_bond(:,:,3);
contour = bwperim(pixel_labels); 
for i = 1:row
    for j = 1:column
        if contour(i,j) == 1
           I_1(i,j) = 255;
           I_2(i,j) = 255;
           I_3(i,j) = 255;
        end
    end
end

I_bond(:,:,1) = I_1;
I_bond(:,:,2) = I_2;
I_bond(:,:,3) = I_3;

end