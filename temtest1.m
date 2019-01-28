clear all
clc
im=imread('3.jpg');%处理图像名称
figure,imshow(im,[]),title('origin');
% Iycbcr=rgb2ycbcr(im);
im=rgb2gray(im);%灰度化
im=double(im);
[minn,minm,immin]=imin(im);
immax=max(max(im));
[n,m]=size(im);
% hold on;
[count,center]=hist(im(:),[0:255]);%获取直方图
% hist(im(:),[50:255]);
[pks,locs] = findpeaks(count,'minpeakdistance',10); %峰值选区与图像的灰度层次有关最后一个参数
% plot(center(locs),pks,'*','color','R'); 
% hold off;
imo=zeros(n,m);
se = strel('ball',5,5);%模板
for i=1:length(locs)
    if count(locs(i))>100
        particle{1,i}=ones(n,m).*255;
        particle{2,i}=zeros(n,m);
        [nn,mm]=find((im<=center(locs(i))));
        center(locs(i))
        for j=1:size(nn)
            particle{1,i}(nn(j),mm(j))=im(nn(j),mm(j));%第几个locs对应的center即像素值
            particle{2,i}(nn(j),mm(j))=1;%第几个locs对应的center即像素值
        end
         [x,y]=find(particle{2,i}==1);
         if ~isempty(x)
             k_class=20;%每个层次圆的个数，个位数越多面积越小.与上文的层次之间有关系，负相关
           [resx,resy,rec]= k_means(x,y,k_class);%论文里写ten instances
           for tcir=1:k_class
                if rec(tcir)>2
                xcircle=[resx(tcir,1:rec(tcir));resy(tcir,1:rec(tcir))];
            [z,r]=fitcircle(xcircle,'linear');%z r是参数方程的系数，可以用于三维重建确定圆心及半径
            Iout=zeros(n,m);
            for t=0:0.01:2*pi%画圆
            Iout(ceil(z(1) + r * cos(t)),ceil(z(2) + r * sin(t)))=1;
            end
            Iout=imfill(Iout,'hole');%填充圆形内部
%             Iout=~Iout;
%            figure, imshow(Iout,[]);
            Iout=imresize(Iout,[n,m]);
            imo=imo-((255.*ones(n,m)-imo).*(255.*ones(n,m)-200.*Iout))/200.*Iout;%这是ps的颜色加深模式。其中混合色为自己选择。
%             figure,imshow(imo,[]);
                end
            end

         end
    end
end
imo = mat2gray(imo);
figure,imshow(imo,[]),title('result');
%              
%              
%              
%              
%              [Lbw4, numbw4] = bwlabel(particle{3,i});%把每个单词（此时已连通）贴上标签
%                             %Lbw4为贴标签之后的矩阵，numbw4为标签（即单词）个数
% stats = regionprops(Lbw4);%获取区域的某个属性(面积、最小包围矩形的坐标长宽等)的值
% imshow( particle{3,i});hold on;
% for i = 1 : numbw4
%   tempBound = stats(i).BoundingBox;
%   rectangle('position',tempBound,'edgecolor','r');
% end
% 

% 
%         m2=20; %矩阵的行数
%         n2=20; %矩阵的列数
%         r=10;   %生成圆的半径
%         m1=-m2/2:m2/2-1;   %把圆心变到矩阵的中间
%         n1=-n2/2:n2/2-1;
%         [x,y]=meshgrid(m1,n1);
%         circle=x.^2+y.^2;   %计算出每一点到圆心的距离的平方
%         circ_mask=zeros(m2,n2);
%         circ_mask(find(circle<=r*r))=1;  %找到圆内的元素，并复制为1
%         circ_mask(find(circle>r*r))=0;   %找到圆外的元素，并复制为0
%         circ_mask=circ_mask;
%         particle{3,i}=imdilate(particle{1,i},circ_mask);
%         particle{3,i}=particle{3,i};
            