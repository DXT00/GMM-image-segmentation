function [I] = show_write_image(image,dir,filename,title_)
figure;imshow(image);title(title_);


filename=int2str(filename);
filename = strcat(filename,'_');

filename = strcat(filename,title_);
filename = strcat(filename,".jpg");
img_dir = strcat(dir,filename);
imwrite(image,img_dir);


end