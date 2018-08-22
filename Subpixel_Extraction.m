function sub_edge=Subpixel_Extraction(edge,orig_img)

if size(orig_img,3)==3;
    orig_img=rgb2gray(orig_img);
end

[height,width]=size(orig_img);
orig_img=double(orig_img);%将图像变为double型

%%以下首先进行高斯滤波
mask_r=2;%高斯滤波掩膜窗口半径
mask=fspecial('gaussian',2*mask_r+1);%生成高斯滤波掩膜
gaussian_im=imfilter(orig_img,mask,'replicate');%高斯滤波生成滤波图像

%%以下求取图像梯度
w=fspecial('sobel');%求取高度方向sobel掩膜算子
gradient_h_im=imfilter(gaussian_im,w,'replicate');%求取高度方向的梯度
w=w';%求取宽度方向sobel掩膜算子
gradient_w_im=imfilter(gaussian_im,w,'replicate');%求取宽度方向的梯度
%图像的梯度幅值为：
gradient_amp_im=sqrt(gradient_h_im.^2+gradient_w_im.^2);


R=[-2 -1 0 1 2 ];        %取样模板
Len=length(edge);
%定义一个位置矩阵，这个位置矩阵存放边缘法线方向上的7个采样点的位置
Neigh_H_Matrix=zeros(Len,5);    %存放行坐标
Neigh_W_Matrix=zeros(Len,5);    %存放列坐标
%定义一个角度向量，存储每个边缘点的梯度方向
Gradient_Thea=zeros(Len,1);


%提取边缘法线方向上的采样点
for i=1:Len
    %取出边缘点
    h=edge(i,1);            
    w=edge(i,2);
    %求解边缘点梯度
    dh=gradient_h_im(h,w);
    dw=gradient_w_im(h,w);
    %结算梯度方向
    thea=atan2(dh,dw);
    %取出此时梯度方向的边缘点
    Neigh_H_Matrix(i,:)=R*sin(thea)+h;
    Neigh_W_Matrix(i,:)=R*cos(thea)+w;
    Gradient_Thea(i)=thea;
    
end
%进行双线性插值，求解图像采样点上的灰度值
Neigh_Gray_Diff=interp2(gradient_amp_im,Neigh_W_Matrix,Neigh_H_Matrix);

%%进行二次曲线拟合    Y=A*X^2+B*X+C
Ln_Neigh_Gray_Diff=log(Neigh_Gray_Diff);  %相对边缘灰度像素取对数
%初始化系数矩阵
V=[4 -2 1;
   1 -1 1;
   0  0 1;
   1  1 1;
   4  2 1];
E=(V'*V)\V';
%初始化精确定位结果
sub_pixel_edge=zeros(Len,2);
for i=1:Len
    U=Ln_Neigh_Gray_Diff(i,:)'; %U=[f(-2),f(-1),f(0),f(1),f(2)]';
    %求解系数A
    A=E(1,:)*U;
    %求解系数B
    B=E(2,:)*U;
    %则解得抛物线顶点坐标为：
    x=-B/(2*A);
    %结算边缘亚像素位置
    sub_pixel_edge(i,1)=edge(i,1)+x*sin(Gradient_Thea(i));
    sub_pixel_edge(i,2)=edge(i,2)+x*cos(Gradient_Thea(i));
end



%进行结果输出
sub_edge=sub_pixel_edge;
    
    
