clear ;
clc;
close all;

maindir = 'D:\imagenet\ILSVRC2012_img_val_subfolders';
subdir =  dir( maindir );   % ��ȷ�����ļ���

for i = 1 : length( subdir )
    if( isequal( subdir( i ).name, '.' ) || ...
        isequal( subdir( i ).name, '..' ) || ...
        ~subdir( i ).isdir )   % �������Ŀ¼����
        continue;
    end
     
    subdirpath = fullfile( maindir, subdir( i ).name, '*.JPEG' );
    images = dir( subdirpath );   % ��������ļ������Һ�׺Ϊjpg���ļ�
     
    % ����ÿ��ͼƬ
    for j = 1 : 10
        imagepath = fullfile( maindir, subdir( i ).name, images( j ).name  );
        image = imread(imagepath);
        
        if size(image,3)>1
            img_gray = rgb2gray(image);
        else
            img_gray = image;
        end
        
       imwrite(img_gray,strcat('./image/',num2str(i-2),'_',num2str(j),'.JPEG'));
    end
end