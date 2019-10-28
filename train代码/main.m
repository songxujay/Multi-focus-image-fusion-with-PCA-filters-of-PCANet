clear all;
close all;
clc;


addpath('./Utils');
addpath('./Liblinear');% %ͼƬ��С����

TrnNum = 5000;
ImgWid = 256;ImgHei = 256;

cnt=1;
for i=1:1000
    for j=1:5
        trainImages_path = ['./image_class1000/',num2str(i),'_',num2str(j),'.JPEG'];
        preTrainImages_path = ['./preImage_class1000/',num2str(cnt),'.JPEG'];
        image_temp = imread(trainImages_path);
        image = imresize(image_temp,[ImgWid ImgHei]);
        imwrite(image,preTrainImages_path);
        cnt = cnt+1;
    end
end


ImgFormat = 'gray';
TrnData = zeros(ImgWid*ImgHei,TrnNum);
for i=1:TrnNum
    image = imread(['./preImage_class1000/',num2str(i),'.JPEG']);
    image = im2double(image);
    TrnData(:,i) = reshape(image,ImgWid*ImgHei,1);
end

%%  PCANet parameters
% We use the parameters in our IEEE TPAMI submission
PCANet.NumStages = 2;
PCANet.PatchSize = [7 7];
PCANet.NumFilters = [8 8];
PCANet.HistBlockSize = [7 7];
PCANet.BlkOverLapRatio = 0.5;
PCANet.Pyramid = [];

fprintf('\n ===== PCANet Parameters ======== \n');
PCANet

%% PCANet Training with 10000 samples

fprintf('\n ====== PCANet Training ======= \n')
TrnData_ImgCell = mat2imgcell(TrnData,ImgWid,ImgHei,ImgFormat); % convert columns in TrnData to cells 
clear TrnData; 
tic;
 V = PCANet_train(TrnData_ImgCell,PCANet,1); % BlkIdx serves the purpose of learning block-wise DR projection matrix; e.g., WPCA
PCANet_TrnTime = toc;

clear TrnData_ImgCell; 
save V_class1000_5000image_noMean V;
% %% PCANet Feature Extraction and Testing 
% 
% source_path1 = 'sourceimages/multifocus/flower_left.png';
% image1 = imread(source_path1);
% ImgSize_wid = size(image1,1); ImgSize_hei = size(image1,2);
% TestData1 = reshape(image1,ImgSize_wid*ImgSize_hei,1);
% TestData_ImgCell = mat2imgcell(TestData1,ImgSize_wid,ImgSize_hei,ImgFormat); % convert columns in TestData to cells 
% 
% [featureImages_stage1,featureImages_stage2] = PCANet_FeaExt(TestData_ImgCell,V,PCANet);  % extract a test feature using trained PCANet model 
% clear TestData1; 

