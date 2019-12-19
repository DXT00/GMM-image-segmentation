file_path ='E:\研一所有课件\现代信号处理\Project Team6\GMM - try\Team6\';%   图像文件夹路径
img_path_list =dir(strcat(file_path,'*.jpg'));%获取该文件夹中所有jpg格式的图像
img_num = length(img_path_list);%获取图像总数量
if img_num > 0 %有满足条件的图像
    %reshape_I_all = [];
    for j = 1:img_num %逐一读取图像
        image_name(:,:,j)= img_path_list(j).name;% 图像名
        orign_IMG(:,:,:,j)=  imread(strcat(file_path,image_name(:,:,j)));
        fprintf('%d %d %s\n',i,j,strcat(file_path,image_name(:,:,j)));% 显示正在处理的图像名
        %图像处理
        k = 2;      
        I = preprocess(orign_IMG(:,:,:,j));
        I = double(I(:,:,2:3));
        % I = double(I);
        row(j) = size(I,1);
        column(j) = size(I,2);
        reshape_I = reshape(I,row(j)*column(j),2);
        if j==1
            reshape_I_all=  reshape_I;
        else
            reshape_I_all = vertcat(reshape_I_all,  reshape_I(:,1:2));

        end
    end
        %聚类 4张图像一块GMM，求model
        [labels,model] = GMM(k, reshape_I_all);
        labels = labels - 1;
        
    for j = 1:img_num %图像还原存储
        LabelImage = reshape(labels(row(j)*column(j)*(j-1)+1:row(j)*column(j)*j,:),row(j),column(j));
        %对结果进行形态学后处理，并将分割结果显示在原图上
        result = postprocess(orign_IMG(:,:,:,j),LabelImage);
        figure;imshow(result);title('result');
        img_dir = strcat('E:\研一所有课件\现代信号处理\Project Team6\GMM - try\result\',image_name(:,:,j));

        imwrite(result,img_dir);
     end
        
        
end