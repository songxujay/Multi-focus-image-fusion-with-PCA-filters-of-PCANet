# Multi-focus-image-fusion-with-PCA-filters-of-PCANet

Published in: IAPR Workshop on Multimodal Pattern Recognition of Social Signals in Human-Computer Interaction 

Song X, Wu X J. Multi-focus Image Fusion with PCA Filters of PCANet[C]//IAPR Workshop on Multimodal Pattern Recognition of Social Signals in Human-Computer Interaction. Springer, Cham, 2018: 1-17.

[论文链接](https://f.glgoo.top/scholar?hl=zh-CN&as_sdt=0%2C5&q=Multi-focus+Image+Fusion+with+PCA+Filters+of+PCANet&btnG=)


## Abstract
As is well known to all, the training of deep learning model is time consuming and complex. Therefore, in this paper, a very simple deep learning model called PCANet is used to extract image features from multi-focus images. First, we train the two-stage PCANet using ImageNet to get PCA filters which will be used to extract image features. Using the feature maps of the first stage of PCANet, we generate activity level maps of source images by using nuclear norm. Then, the decision map is obtained through a series of post-processing operations on the activity level maps. Finally, the fused image is achieved by utilizing a weighted fusion rule. The experimental results demonstrate that the proposed method can achieve state-of-the-art fusion performance in terms of both objective assessment and visual quality.

### The framework of fusion method

< img src="D:\研一下\论文\框架.png" width="150" height="150" alt="图片加载失败时，显示这段字"/>
