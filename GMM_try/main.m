file_path ='E:\��һ���пμ�\�ִ��źŴ���\Project Team6\GMM\Team6\';%  'C:\Users\86157\Desktop\GMM\Team6\';% ͼ���ļ���·��
img_path_list = dir(strcat(file_path,'*.jpg'));%��ȡ���ļ���������jpg��ʽ��ͼ��
img_num = length(img_path_list);%��ȡͼ��������
if img_num > 0 %������������ͼ��
    %reshape_I_all = [];
    for j = 1:img_num %��һ��ȡͼ��
        image_name(:,:,j)= img_path_list(j).name;% ͼ����
        orign_IMG(:,:,:,j)=  imread(strcat(file_path,image_name(:,:,j)));
        fprintf('%d %d %s\n',i,j,strcat(file_path,image_name(:,:,j)));% ��ʾ���ڴ����ͼ����
        %ͼ����
        k = 2;
        %ͼ��Ԥ�������LAB�ռ���ѡ��AB����ͨ��Ч���ȽϺã�������HSV�ռ�Ч��һ�㣩
       % figure;imshow(orign_IMG(:,:,3:3));
       
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
        %����
        [labels,model] = GMM(k, reshape_I_all);
        labels = labels - 1;
    for j = 1:img_num %��һ��ȡͼ��
        LabelImage = reshape(labels(row(j)*column(j)*(j-1)+1:row(j)*column(j)*j,:),row(j),column(j));


        %�Խ��������̬ѧ���������ָ�����ʾ��ԭͼ��
        result = postprocess(orign_IMG(:,:,:,j),LabelImage);
        figure;imshow(result);title('result');
        img_dir = strcat('C:\Users\DXT00\Desktop\gmm_imagr\',image_name(:,:,j));
        imwrite(result,img_dir);
     end
        
        
end