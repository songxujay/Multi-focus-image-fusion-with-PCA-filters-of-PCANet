clear all;
close all;
clc;


addpath('./Utils');
addpath('./Liblinear');% %Í¼Æ¬´óÐ¡ÐÞÕý
ImgFormat = 'gray';

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

%% PCANet Feature Extraction and Testing 
load('V_class1000_5000image.mat');

index2 = 10;

for index = 10:24
source_left = ['./sourceimages/multifocus/',num2str(index),'_left_re.png'];
source_right = ['./sourceimages/multifocus/',num2str(index),'_right_re.png'];
% [imagename1 imagepath1]=uigetfile('source_images\*.jpg;*.bmp;*.png;*.tif;*.tiff;*.pgm;*.gif','Please choose the first input image');
% image1=imread(strcat(imagepath1,imagename1));    
% [imagename2 imagepath2]=uigetfile('source_images\*.jpg;*.bmp;*.png;*.tif;*.tiff;*.pgm;*.gif','Please choose the second input image');
% image2=imread(strcat(imagepath2,imagename2));     

fuse_path = ['./results/pca_norm/',num2str(index2),'_pca_norm.png'];


image1 = imread(source_left);
image2 = imread(source_right);

image1 = im2double(image1);
% image2 = imread(source_path2);
image2 = im2double(image2);

figure;imshow(image1);
figure;imshow(image2);

ImgSize_wid = size(image1,1); ImgSize_hei = size(image1,2);
TestData1 = reshape(image1,ImgSize_wid*ImgSize_hei,1);
TestData2 = reshape(image2,ImgSize_wid*ImgSize_hei,1);
TestData_ImgCell1 = mat2imgcell(TestData1,ImgSize_wid,ImgSize_hei,ImgFormat); % convert columns in TestData to cells 
TestData_ImgCell2 = mat2imgcell(TestData2,ImgSize_wid,ImgSize_hei,ImgFormat); % convert columns in TestData to cells 

[left_featureImages_stage1,left_featureImages_stage2] = PCANet_FeaExt(TestData_ImgCell1,V,PCANet);  % extract a test feature using trained PCANet model 
[right_featureImages_stage1,right_featureImages_stage2] = PCANet_FeaExt(TestData_ImgCell2,V,PCANet);  % extract a test feature using trained PCANet model 
clear TestData1; 

extend_left_featureImages_stage1 = zeros(ImgSize_wid+4,ImgSize_hei+4,PCANet.NumFilters(1)-2);
extend_right_featureImages_stage1 = zeros(ImgSize_wid+4,ImgSize_hei+4,PCANet.NumFilters(1)-2);

extend_left_featureImages_stage1(:,:,1) = extend_feature(cell2mat(left_featureImages_stage1(3))); %%1
extend_right_featureImages_stage1(:,:,1) =  extend_feature(cell2mat(right_featureImages_stage1(3)));%%1

% imwrite(cell2mat(left_featureImages_stage1(3)),['./mid_results/left_feature/left_feature',num2str(3),'.png'],'png');
% imwrite(cell2mat(right_featureImages_stage1(3)),['./mid_results/right_feature/right_feature',num2str(3),'.png'],'png');

left_feature_stage1 = extend_left_featureImages_stage1(:,:,1);
right_feature_stage1 = extend_right_featureImages_stage1(:,:,1);


for i=4:PCANet.NumFilters(2) %%2

    extend_left_featureImages_stage1(:,:,i) = extend_feature(cell2mat(left_featureImages_stage1(i)));
    extend_right_featureImages_stage1(:,:,i) =  extend_feature(cell2mat(right_featureImages_stage1(i)));
    
%     imwrite(cell2mat(left_featureImages_stage1(i)),['./mid_results/left_feature/left_feature',num2str(i),'.png'],'png');
%     imwrite(cell2mat(right_featureImages_stage1(i)),['./mid_results/right_feature/right_feature',num2str(i),'.png'],'png');
    
    left_feature_stage1 = cat(3,left_feature_stage1 ,  extend_left_featureImages_stage1(:,:,i));
    right_feature_stage1 = cat(3,right_feature_stage1 , extend_right_featureImages_stage1(:,:,i));
%     figure;imshow(cell2mat(left_featureImages_stage1(i)));
%     figure;imshow(cell2mat(right_featureImages_stage1(i)));
end

% for i=1:PCANet.NumFilters(2)
% 
%     figure;imshow((left_feature_stage1(:,:,i)));
%     figure;imshow((right_feature_stage1(:,:,i)));
% end
feature_map1 = zeros(ImgSize_wid+4,ImgSize_hei+4);
feature_map2 = zeros(ImgSize_wid+4,ImgSize_hei+4);
unit=5;
for i=3:ImgSize_wid+2
    for j=3:ImgSize_hei+2
        patch1 = left_feature_stage1(i-2:i+2,j-2:j+2,:);
        patch2 = right_feature_stage1(i-2:i+2,j-2:j+2,:);
        
        patch1 = reshape(patch1,unit*unit,PCANet.NumFilters(1)-2); %no -2
        patch2 = reshape(patch2,unit*unit,PCANet.NumFilters(1)-2); %no -2
        
        s1 = svd(patch1);
        s2 = svd(patch2);
        
        feature_map1(i,j) = sum(sum(s1));
        feature_map2(i,j) = sum(sum(s2));
    end
end

feature_map1 = feature_map1(3:ImgSize_wid+2,3:ImgSize_hei+2);
feature_map2 = feature_map2(3:ImgSize_wid+2,3:ImgSize_hei+2);

figure;imshow(feature_map1);
figure;imshow(feature_map2);
% imwrite(feature_map1,'./mid_results/feature_map1.png','png');
% imwrite(feature_map2,'./mid_results/feature_map2.png','png');

A1 = extend_feature_main3( feature_map1 );
A2 = extend_feature_main3( feature_map2 );
% A1 = feature_map1;
% A2 = feature_map2;

gen = generate_initmap(A1,A2,image1,image2);
% imwrite(gen,['./mid_results/gen',num2str(index2),'.png'],'png');
index2 = index2 + 1 ;

f = gen.*image1 + (1-gen).*image2;
figure;imshow(f);

imwrite(f,fuse_path);
% imwrite(left_feature_stage1,['./intermediate_results/texture/left_feature_stage1.png']);
% imwrite(right_feature_stage1,['./intermediate_results/texture/right_feature_stage1.png']);
end