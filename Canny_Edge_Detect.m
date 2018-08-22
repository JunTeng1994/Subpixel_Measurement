function edge_img=Canny_Edge_Detect(in_im)
%函数功能：
%pos_vector=Canny_Edge_Detect(in_im)
%函数输入：
%in_im: 输入待检测的灰度图像，输入的图像为uint8灰度图像
%函数输出：
%pos_vector: 输出检测的边缘坐标，其中：
%pos_vector(:,1): 边缘坐标的行位置
%pos_vector(:,2): 边缘坐标的列位置

if size(in_im,3)==3
    in_im=rgb2gray(in_im);
end

edge_img = edge(in_im,'canny',0.5);
