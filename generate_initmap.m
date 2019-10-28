function [gen] = generate_initmap(features_a, features_b,image1,image2)

[m,n] = size(features_a);
texture1 = zeros(m-2,n-2);
texture2 = zeros(m-2,n-2);
unit=1;

for i=2:m-1
    for j=2:n-1
        A1 =sum(sum(features_a(i-1:i+1,j-1:j+1)))/9;
        A2 =sum(sum(features_b(i-1:i+1,j-1:j+1)))/9;
        
        % choose max
        if A1>A2
           texture1(((i-2)*unit+1):((i-1)*unit),((j-2)*unit+1):((j-1)*unit)) = 1;
        else
           texture2(((i-2)*unit+1):((i-1)*unit),((j-2)*unit+1):((j-1)*unit)) = 1;
        end
    end
end
% figure;imshow(texture1);
% figure;imshow(texture2);


ratio=0.1;%it could be mannually adjusted according to the characteristic of source images
area=ceil(ratio*(m-2)*(n-2));
tempMap1=bwareaopen(texture1,area);
tempMap2=bwareaopen(texture2,area);

% figure;imshow(tempMap1);
% figure;imshow(tempMap2);

tempMap1_1=1-tempMap1;
tempMap2_1=1-tempMap2;

% figure;imshow(tempMap1_1);
% figure;imshow(tempMap2_1);

tempMap1_2=bwareaopen(tempMap1_1,area);
tempMap2_2=bwareaopen(tempMap2_1,area);

% figure;imshow(tempMap1_2);
% figure;imshow(tempMap2_2);

initMap1=1-tempMap1_2;
initMap2=1-tempMap2_2;

% figure;imshow(initMap1);
% figure;imshow(initMap2);

initMap1 = bwmorph(initMap1,'close');  %闭运算
% figure;imshow(initMap1);
initMap1 = bwmorph(initMap1,'open');  %开运算
% figure;imshow(initMap1);

initMap2 = bwmorph(initMap2,'close');  %闭运算
% figure;imshow(initMap2);
initMap2 = bwmorph(initMap2,'open');  %开运算
% figure;imshow(initMap2);


fusion_map=1*initMap1+0.5*(1-initMap1-initMap2);%将两幅初始决策图不相同的地方变成了0.5，相同的地方为initMap1里相同地方所对应的数值
ratio=0.01;%it could be mannually adjusted according to the characteristic of source images
area=ceil(ratio*(m-2)*(n-2));
fusion_map = 1-fusion_map;
fusion_map=bwareaopen(fusion_map,area);

fusion_map = 1-fusion_map;
fusion_map=bwareaopen(fusion_map,area);

% figure;imshow(fusion_map);

fusion_map=medfilt2(fusion_map,[3,3]);
gen = fusion_map;
figure;imshow(gen);
end





