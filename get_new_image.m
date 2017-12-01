function new_image=get_new_image(old_image,x)
delta_x=x(1,1);
delta_y=x(1,2);
theta=x(1,3);
% scale=x(1,4);
delta_x= round(delta_x);
delta_y=round(delta_y);
se=translate(strel(1),[delta_x delta_y]);
now_image=imdilate(old_image,se);
now_image=imrotate(now_image,theta,'bicubic','crop');
new_image=now_image;
% se=translate(strel(1),[delta_x delta_y]);
% now_image=imdilate(old_image,se);
% now_image=imrotate(now_image,theta,'bicubic','crop');
% now_image = imresize(old_image,scale,'bicubic');
% new_image=now_image;

