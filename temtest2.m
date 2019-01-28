clear all
clc
im=imread('3.jpg');
figure,title('origin'),imshow(im);
% Iycbcr=rgb2ycbcr(im);
im=rgb2gray(im);
im=double(im);
[minn,minm,immin]=imin(im);
immax=max(max(im));
[n,m]=size(im);
% hold on;
[count,center]=hist(im(:),[50:255]);
% hist(im(:),[50:255]);
[pks,locs] = findpeaks(count,'minpeakdistance',20); 
% plot(center(locs),pks,'*','color','R'); 
% hold off;
Iout=ones(n,m);
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
           [resx,resy,rec]= k_means(x,y,10);%论文里写ten instances
           for tcir=1:10
                if rec(tcir)>0
                xcircle=[resx(tcir,1:rec(tcir));resy(tcir,1:rec(tcir))];
            [z,r]=fitcircle(xcircle,'linear');
            for t=0:0.01:2*pi
            Iout(ceil(z(1) + r * cos(t)),ceil(z(2) + r * sin(t)))=0;
            end
            Iout=imfill(~Iout,'hole');
            Iout=~Iout;
%            figure, imshow(Iout,[]);
            Iout=imresize(Iout,[n,m]);
            imo=imo+Iout;
%             figure,imshow(imo,[]);
                end
            end

         end
    end
end
figure,title('result'),imshow(imo,[]);
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
            