function [labels, parameter] = GMM(K, x)
N_row = size(x,1);
n_channel = size(x,2);
%ͨ��kmeans�ҵ���ʼmu��ΪGMM�ĳ�ʼ����
[labels,mu] = kmeans(x,K);
%��MLE�����ʼ��Ȩ�أ�pai���ͷ���sigma
for k = 1:K
    pai(k) = sum(labels == k)/N_row; 
    sigma{k} = cov(x(labels == k,:)); 
end

convergence = 0;
t = 1;
while t == 1 || ~convergence
    % E-step��ͨ����ʼ��������������gama
    gama = zeros(N_row,K);
    for k = 1:K
        y = mvnpdf(x,mu(k,:),sigma{k});
        gama(:,k) = pai(k) * mvnpdf(x,mu(k,:),sigma{k});
    end
    llh(t) = 0;
    temp = sum(gama,2);
    temp = log(temp);
    llh(t) = sum(temp);
    llh(t) = llh(t) / N_row;
%     p = gama(:,1)+gama(:,2);
%     p = log(p);
%     lnpdf(t) = sum(p)/N_row;
    fprintf('llh(t)  %d \n', llh(t) );
    %��weight�ĸ��³̶��������Ƿ���������
    if t > 1
        
        convergence =llh(t)>0.0 %(llh(t) - llh(t-1)) < 0.0001;
        % convergence = (lnpdf(t) - lnpdf(t-1)) < 0.001% 0.0001;

    end    
    t = t + 1
    temp = sum(gama,2);
    gama = gama ./ temp;
    
    %M-step ����mu,sigma,weight
    for k = 1:K
        % ����mu 
        N(k) = sum(gama(:,k));
        mu(k,:) = sum(bsxfun(@times,gama(:,k),x)) / N(k);
        
        % ����sigma
        sigma{k} = zeros(n_channel,n_channel);      
        MU = ones(N_row,1);
        MU = MU * mu(k,:);
        MU_ = gama(:,k) .* (x - MU);
        sigma{k} =  (x - MU)' * MU_;
        sigma{k} = sigma{k} ./ N(k);                              
    end
    
    % ����pai
%     pai = N./sum(N);
    pai = N ./ N_row;
end
%�������յĲ��� mu, sigma, pai
parameter.mu = mu;
parameter.sigma = sigma;
parameter.pai = pai;
%���з��ࡣ2��ʾ���бȽ�
[~,labels] = max(gama,[],2);
