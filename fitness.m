function y=fitness(x)
input = imread('tv3.png');
base = imread('ir3.png');
[row1,col1,c1] = size(base);
[row2,col2,c2] = size(input);
if c1>1
    base = rgb2gray(base);
end
if c2>1
    input = rgb2gray(input);
end

if row1 > row2
    row1=row2;
end
if col1 > col2
    col1=col2;
end
input = input(1:row1,1:col1);

base = double(base);
input = double(input);

% 仿射变化
delta_x=x(1,1);  %水平平移
delta_y=x(1,2);  %垂直平移
theta=x(1,3);    %旋转角
% scale=x(1,4);    %缩放因子
delta_x= round(delta_x);
delta_y=round(delta_y);

now_image = get_new_image(input,x);

y=MI(base,now_image);
