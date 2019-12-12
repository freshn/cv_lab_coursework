clear all;
clc;
img1 = imread('img\train03.jpg');
%exp = imread('i6.jpg');

%exp=rgb2gray(exp);
%exp=imresize(exp,[32,32]);
%exp_hog =hog(exp); 

hsva = rgb2hsv(img1);
h = hsva(:,:,1);
s = hsva(:,:,2);
v = hsva(:,:,3);
[n,m,y]=size(hsva);
[n1,m1]=size(img1);

Img1copy=zeros(n,m);

for i=1:n
    for j=1:m
        if h(i,j)<=0.67&& h(i,j)>=0.55  && s(i,j) >=0.5 && v(i,j) >=0.15% detect blue brick
       % if h(i,j)<=1&& h(i,j)>=0.8  && s(i,j) >=0.5 && v(i,j) >=0.2  ||h(i,j)<=0.1&&s(i,j) >=0.5 && v(i,j) >=0.63
            Img1copy(i,j)=1;
        end
    end
end
figure,subplot(2,2,1),imshow(Img1copy);
se1=strel('disk',4);
se2=strel('disk',2);%这里是创建一个半径为5的平坦型圆盘结构元素
Img1copy=imdilate(Img1copy,se1);
subplot(2,2,2),imshow(Img1copy);
Img1copy=imerode(Img1copy,se2);
subplot(2,2,3),imshow(Img1copy);
Img1copy = bwareaopen(Img1copy,5000);
[xx,yy]=find(Img1copy==1);
copy=zeros(n,m,3);
for i=1:length(xx)
    copy(xx(i),yy(i),:)=img1(xx(i),yy(i),:);
    copy = uint8(copy);
end

    
[L,num] = bwlabel(Img1copy,8);
RGB = label2rgb(L);
subplot(2,2,4),imshow(RGB)

%stats = regionprops(L, 'basic');
%status=regionprops(L,'BoundingBox');

stats = regionprops(L, 'BoundingBox' ,'Area','Centroid' ,'PixelList' );
figure,imshow(Img1copy),title('2')  

hold on
num=0;
num2=0;
for i=1:size(stats)
     rectangle('Position',[stats(i).BoundingBox],'LineWidth',2,'LineStyle','--','EdgeColor','r'),
     im2=imcrop(copy,[stats(i).BoundingBox]);
     
     im2=rgb2gray(im2);
    
    
     J3=edge(im2,'Canny',0.2);  
     figure,imshow(J3);
     [centers, radii, metric] = imfindcircles( J3,[15 100]);
     viscircles(centers, radii,'EdgeColor','b');
   
 
     %im2=imresize(im2,[32,32]);
     %hogt =hog(im2);  
     %c=(exp_hog-hogt).^2;
     %d=sqrt(sum(c(:)));
     %A=(norm(hogt-exp_hog))^2; 
     [nn,mm]=size(centers);
     
     if nn==8||nn==7||nn==3
     num=num+1;   
     end
     if nn>=10
     num=num+2;
     
     end
end
disp(num);
  


