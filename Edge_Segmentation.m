function [seg_edges_line,seg_edges_circle]=Edge_Segmentation(input_img)
%函数功能：
%seg_edge=Edge_Segmentation(edge)
%实现边缘的分割
%函数输入：
%edge:边缘坐标
%函数输出：
%seg_edge:分割后的边缘段，为cell型
%seg_edge_num:分割后的边缘数:seg_edge_num(1)为水平边缘数，seg_edge_num(2)为垂直边缘数

if size(input_img,3)==3
    input_img=rbg2gray(input_img);
end

edge_img=input_img;
nrow=size(edge_img,1);
ncol=size(edge_img,2);

%进行霍夫变换
[H,T,R] = hough(edge_img,'Theta',-90:1:89);


%提取hough变换后的图像极值点并进行过滤
P=houghpeaks(H,10,'Threshold',0.2*max(H(:)));

%进行逐点扫描
scan_size=2;
seg_edges_line={};
for k=1:size(P,1)
    temp_edge=[];
    theta=T(P(k,2));
    rho=R(P(k,1));
    for x=1:ncol
        ideay=round((rho-x*cosd(theta))/sind(theta))+1
        if ideay<(size(edge_img,1)-scan_size) && ideay>scan_size
            patch=edge_img(ideay-scan_size:ideay+scan_size,x);
            realy=find(patch>0);
            if (length(realy)~=0)
                for ii=1:length(realy)
                    temp_edge(end+1,1:2)=[realy(ii)-scan_size-1+ideay,x];
                    edge_img(realy(ii)-scan_size-1+ideay,x)=0;
                end
            end
        end
    end
    if size(temp_edge,1)>15
        seg_edges_line{end+1}=temp_edge;
    end
    
end

temp_edges=seg_edges_line;
delete_len=25;
delete_gap=15;
for k=1:length(temp_edges);
    edge=temp_edges{k};
    real_start=1;
    real_len=[];
    len=1;
    for ii=2:size(edge,1)-1;
        if norm(edge(ii,:)-edge(ii+1,:))<delete_gap
            len=len+1;
        else
            if (len>delete_len)
                real_len(end+1)=len;
                real_start(end+1)=ii+1;
                len=1;
            else
                real_start(end)=ii+1;
                len=1;
            end
        end
    end
    if (len>delete_len)
        real_len(end+1)=len-1;    
    else
        real_start(end)=[];
    end
    
    temp_ed=[];
    for jj=1:length(real_start)
        temp_ed(end+1:end+real_len(jj),1:2)=edge(real_start(jj):real_start(jj)+real_len(jj)-1,:);
    end
    seg_edges_line{k}=temp_ed(1:end,:);
        
end

%======================================================================%
temp_img=input_img;
for k=1:length(seg_edges_line);
    edge=seg_edges_line{k};
    for i=1:size(edge,1)
        temp_img(edge(i,1),edge(i,2))=0;
    end
end

[label_img,num]=bwlabel(temp_img);
seg_edges_circle={};
for i=1:num
    edge_circle=[];
    [r,c]=find(label_img==i);
    if length(r)>delete_len
        edge_circle(end+1:end+length(r),1:2)=[r,c];
        seg_edges_circle{end+1}=edge_circle;
    end
end

        










% 
% figure, imshow(edge_img);
% hold on;
% for k=1:size(P,1)
%     temp_edge=[];
%     theta=T(P(k,2));
%     rho=R(P(k,1));
%     
%     for x=1:ncol
%         ideay=round((rho-x*cosd(theta))/sind(theta));
%         if ideay<(size(edge_img,1)-scan_size) && ideay>scan_size
%             temp_edge(end+1,1:2)=[ideay,x];
%         end
%     end
%     H(P(k,1),P(k,2))
% 
%     
%     if size(temp_edge,1)~=0
%          plot(temp_edge(:,2),temp_edge(:,1),'r');
%     end
%     
% end



   