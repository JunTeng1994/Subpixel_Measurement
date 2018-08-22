function sub_edge=Subpixel_Extraction(edge,orig_img)

if size(orig_img,3)==3;
    orig_img=rgb2gray(orig_img);
end

[height,width]=size(orig_img);
orig_img=double(orig_img);%��ͼ���Ϊdouble��

%%�������Ƚ��и�˹�˲�
mask_r=2;%��˹�˲���Ĥ���ڰ뾶
mask=fspecial('gaussian',2*mask_r+1);%���ɸ�˹�˲���Ĥ
gaussian_im=imfilter(orig_img,mask,'replicate');%��˹�˲������˲�ͼ��

%%������ȡͼ���ݶ�
w=fspecial('sobel');%��ȡ�߶ȷ���sobel��Ĥ����
gradient_h_im=imfilter(gaussian_im,w,'replicate');%��ȡ�߶ȷ�����ݶ�
w=w';%��ȡ��ȷ���sobel��Ĥ����
gradient_w_im=imfilter(gaussian_im,w,'replicate');%��ȡ��ȷ�����ݶ�
%ͼ����ݶȷ�ֵΪ��
gradient_amp_im=sqrt(gradient_h_im.^2+gradient_w_im.^2);


R=[-2 -1 0 1 2 ];        %ȡ��ģ��
Len=length(edge);
%����һ��λ�þ������λ�þ����ű�Ե���߷����ϵ�7���������λ��
Neigh_H_Matrix=zeros(Len,5);    %���������
Neigh_W_Matrix=zeros(Len,5);    %���������
%����һ���Ƕ��������洢ÿ����Ե����ݶȷ���
Gradient_Thea=zeros(Len,1);


%��ȡ��Ե���߷����ϵĲ�����
for i=1:Len
    %ȡ����Ե��
    h=edge(i,1);            
    w=edge(i,2);
    %����Ե���ݶ�
    dh=gradient_h_im(h,w);
    dw=gradient_w_im(h,w);
    %�����ݶȷ���
    thea=atan2(dh,dw);
    %ȡ����ʱ�ݶȷ���ı�Ե��
    Neigh_H_Matrix(i,:)=R*sin(thea)+h;
    Neigh_W_Matrix(i,:)=R*cos(thea)+w;
    Gradient_Thea(i)=thea;
    
end
%����˫���Բ�ֵ�����ͼ��������ϵĻҶ�ֵ
Neigh_Gray_Diff=interp2(gradient_amp_im,Neigh_W_Matrix,Neigh_H_Matrix);

%%���ж����������    Y=A*X^2+B*X+C
Ln_Neigh_Gray_Diff=log(Neigh_Gray_Diff);  %��Ա�Ե�Ҷ�����ȡ����
%��ʼ��ϵ������
V=[4 -2 1;
   1 -1 1;
   0  0 1;
   1  1 1;
   4  2 1];
E=(V'*V)\V';
%��ʼ����ȷ��λ���
sub_pixel_edge=zeros(Len,2);
for i=1:Len
    U=Ln_Neigh_Gray_Diff(i,:)'; %U=[f(-2),f(-1),f(0),f(1),f(2)]';
    %���ϵ��A
    A=E(1,:)*U;
    %���ϵ��B
    B=E(2,:)*U;
    %���������߶�������Ϊ��
    x=-B/(2*A);
    %�����Ե������λ��
    sub_pixel_edge(i,1)=edge(i,1)+x*sin(Gradient_Thea(i));
    sub_pixel_edge(i,2)=edge(i,2)+x*cos(Gradient_Thea(i));
end



%���н�����
sub_edge=sub_pixel_edge;
    
    
