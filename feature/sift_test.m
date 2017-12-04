addpath('image');
clc
clear
Ia = imread('tv3.png');
[m,n,c]=size(Ia);
if c>1
Ia=rgb2gray(Ia);
end
Ia=mat2gray(Ia);
Ia = single(Ia) ;  

Ib = imread('ir3.png');
[m1,n1,c1]=size(Ib);
if c1>1
Ib=rgb2gray(Ib);
end
Ib=mat2gray(Ib);
Ib = single(Ib) ;  
[fa, da] = vl_sift(Ia) ;  
[fb, db] = vl_sift(Ib) ;  
[matches, scores] = vl_ubcmatch(da, db) ;


[drop, perm] = sort(scores, 'descend') ;%%降序排列两个点的欧式距离，perm是索引，drop是降序结果，drop=scores（perm）
matches = matches(:, perm) ;            %%得到排序后？？
scores  = scores(perm) ;                %%降序后的欧式距离

% figure(1) ; clf ;
% imagesc(cat(2, Ia, Ib)) ;
% axis image off ;
% vl_demo_print('sift_match_1', 1) ;

 figure(2) ; clf ;
if m>m1
    m2=m1;
else
    m2=m;
end
if n>n1
    n2=n1;
else
    n2=n;
end
Ia = Ia(1:m2,1:n2);
Ib = Ib(1:m2,1:n2);
imagesc(cat(2, Ia, Ib)) ;

xa = fa(1,matches(1,:)) ;%%each fa is a feature frame and has the format [x;y;s;th],where x,y is the center of the frame,s is the scale 
xb = fb(1,matches(2,:)) + size(Ia,2) ;
ya = fa(2,matches(1,:)) ;
yb = fb(2,matches(2,:)) ;

hold on ;
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 1, 'color', 'b') ;

vl_plotframe(fa(:,matches(1,:))) ;
fb(1,:) = fb(1,:) + size(Ia,2) ;
vl_plotframe(fb(:,matches(2,:))) ;
axis image off ;

vl_demo_print('sift_match_2', 1) ;



 
 

