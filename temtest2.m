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
se = strel('ball',5,5);%ģ��
for i=1:length(locs)
    if count(locs(i))>100
        particle{1,i}=ones(n,m).*255;
        particle{2,i}=zeros(n,m);
        [nn,mm]=find((im<=center(locs(i))));
        center(locs(i))
        for j=1:size(nn)
            particle{1,i}(nn(j),mm(j))=im(nn(j),mm(j));%�ڼ���locs��Ӧ��center������ֵ
            particle{2,i}(nn(j),mm(j))=1;%�ڼ���locs��Ӧ��center������ֵ
        end
         [x,y]=find(particle{2,i}==1);
         if ~isempty(x)
           [resx,resy,rec]= k_means(x,y,10);%������дten instances
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
%              [Lbw4, numbw4] = bwlabel(particle{3,i});%��ÿ�����ʣ���ʱ����ͨ�����ϱ�ǩ
%                             %Lbw4Ϊ����ǩ֮��ľ���numbw4Ϊ��ǩ�������ʣ�����
% stats = regionprops(Lbw4);%��ȡ�����ĳ������(�������С��Χ���ε����곤���)��ֵ
% imshow( particle{3,i});hold on;
% for i = 1 : numbw4
%   tempBound = stats(i).BoundingBox;
%   rectangle('position',tempBound,'edgecolor','r');
% end
% 

% 
%         m2=20; %���������
%         n2=20; %���������
%         r=10;   %����Բ�İ뾶
%         m1=-m2/2:m2/2-1;   %��Բ�ı䵽������м�
%         n1=-n2/2:n2/2-1;
%         [x,y]=meshgrid(m1,n1);
%         circle=x.^2+y.^2;   %�����ÿһ�㵽Բ�ĵľ����ƽ��
%         circ_mask=zeros(m2,n2);
%         circ_mask(find(circle<=r*r))=1;  %�ҵ�Բ�ڵ�Ԫ�أ�������Ϊ1
%         circ_mask(find(circle>r*r))=0;   %�ҵ�Բ���Ԫ�أ�������Ϊ0
%         circ_mask=circ_mask;
%         particle{3,i}=imdilate(particle{1,i},circ_mask);
%         particle{3,i}=particle{3,i};
            