clc
clear;

%读入图像
img=imread('metal-parts-01.png');
img123=imread('metal-parts-blurred.png');
% figure,imshow(img);

%进行边缘提取
edgeImg=Canny_Edge_Detect(img);

figure,imshow(edgeImg);

%进行边缘分割
[lines,circles]=Edge_Segmentation(edgeImg);

temp_img1=zeros(size(edgeImg));
for k=1:length(lines);
    edge=lines{k};
    for i=1:size(edge,1)
        temp_img1(edge(i,1),edge(i,2))=255;
    end
end
figure,imshow(uint8(temp_img1))

temp_img2=zeros(size(edgeImg));
for k=1:length(circles);
    edge=circles{k};
    for i=1:size(edge,1)
        temp_img2(edge(i,1),edge(i,2))=255;
    end
end
figure,imshow(uint8(temp_img2));

%进行边界亚像素提取
figure,imshow(img123)
hold on;
for i=1:length(circles)
    
    circle=circles{i};
    sub_circle=Subpixel_Extraction(circle,img);
    [center,rad]=Circle_Fit(sub_circle);
    circle_theta=-pi:0.01:pi;
    xfit=rad*cos(circle_theta)+center(2);
    yfit=rad*sin(circle_theta)+center(1);
    plot(xfit,yfit,'b-');
    rad
    pause;
    
end

    
    
        





