function edge_img=Canny_Edge_Detect(in_im)
%�������ܣ�
%pos_vector=Canny_Edge_Detect(in_im)
%�������룺
%in_im: ��������ĻҶ�ͼ�������ͼ��Ϊuint8�Ҷ�ͼ��
%���������
%pos_vector: ������ı�Ե���꣬���У�
%pos_vector(:,1): ��Ե�������λ��
%pos_vector(:,2): ��Ե�������λ��

if size(in_im,3)==3
    in_im=rgb2gray(in_im);
end

edge_img = edge(in_im,'canny',0.5);
