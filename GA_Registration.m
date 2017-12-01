close all
clc
clear
tic
nvars = 3;
addpath('./image')
lb=[-50,-50,-20];
ub=[50,50,20]; 
option = gaoptimset('PopulationSize',100,'PlotInterval',1,'PlotFcns', @gaplotbestf);
[x,feval] = ga(@fitness,nvars,[],[],[],[],lb,ub,[],[],option);

%��ʾ��׼���
input = imread('ir1.png');
base = imread('tv1.png');
[row1,col1,c1] = size(base);
[row2,col2,c2] = size(input);
if c1>1
    base = rgb2gray(base);
end
if c2>1
    input = rgb2gray(input);
end
base = double(base);
input = double(input);
input_new=get_new_image(input,x);
input_new=uint8(input_new);
figure
subplot(1,3,1);
imshow(input,[]);title('����׼ͼ��');
subplot(1,3,2);
imshow(base,[]);title('tv');
subplot(1,3,3);
imshow(input_new);title('����׼ͼ��');
input=uint8(input);
figure,
imshowpair(input,base);
title('δ��׼ǰ');
figure,
imshowpair(base,input_new);
title('��׼��');
toc


