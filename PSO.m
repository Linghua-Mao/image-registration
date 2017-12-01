close all
clc
clear
tic
addpath('./image')
input=imread('tv3.png');
base=imread('ir3.png');
% figure,imshowpair(base,input);
base = rgb2gray(base);
input = rgb2gray(input);

[row,col]=size(base);
[row1,col1]=size(input);
if row > row1
    row=row1;
end
if col > col1
    col=col1;
end
input = input(1:row,1:col);
store_input=input;

%ga
% ga_lb=[-50,-50,-2];
% ga_ub=[50,50,2]; 
% option = gaoptimset('PopulationSize',50,'PlotInterval',1,'PlotFcns', @gaplotbestf);
% [x,feval,flag,output,population] = ga(@fitness,3,[],[],[],[],ga_lb,ga_ub,[],[],option);


%粒子群初始化
popsize=50;   %粒子数
MAXITER=30;   %迭代数
dimension=3;  %参数个数
lb = [-50,-50,-10];
ub = [50,50,10];
x = rand(popsize,dimension).*repmat(ub-lb,popsize,1) + repmat(lb, popsize,1);
% x=population;
T=cputime;
%产生第一代种
% x=(irange_r- irange_l)*rand(popsize,dimension,1) + irange_l;
% x(:,1,1)=round(x(:,1,1));

pbest=x;
gbest=zeros(1,dimension);
for i=1:popsize
    f_x(i)=f4(base,input,x(i,:));
    f_pbest(i)=f_x(i);
end

%寻找全局最大值
% g=min(find(f_pbest==min(f_pbest(1:popsize))))
g=max(find(f_pbest==max(f_pbest(1:popsize))))
gbest=pbest(g,:);   
f_gbest=f_pbest(g)

%当前获得的最大值
MAXIUM=f_pbest(g);

data1(1)=MAXIUM;
MeanMat = [];
MaxMat = [];
for t=1:MAXITER
t
  beta=(1.0-0.5)*(MAXITER-t)/MAXITER+0.5;
  for i=1:popsize   
        fi=rand(1,dimension);
        p=fi.*pbest(i,:)+(1-fi).*gbest;
        u=rand(1,dimension);
        b=beta*abs(p-x(i,:));       
        v=-log(u); 
        x(i,:)=p+((-1).^ceil(0.5+rand(1,dimension))).*b.*v;
        x(i,1)=round(x(i,1));
        x(i,2)=round(x(i,2));
        
       %防止溢出
        for yy=1:dimension
            if x(i,yy)>ub(yy)
                x(i,yy)=ub(yy);
            end
            if x(i,yy)<lb(yy)
                x(i,yy)=lb(yy);
            end
        end
        f_x(i)=f4(base,input,x(i,:));
        %更新局部最优值
        if f_x(i) > f_pbest(i)
            pbest(i,:)=x(i,:);
            f_pbest(i)=f_x(i);
        end
        %更新全局最优值
        if f_pbest(i)  > f_gbest
            gbest=pbest(i,:);
            f_gbest=f_pbest(i);
        end

        MAXIUM=f_gbest;
  end
   MaxMat=[MaxMat MAXIUM];
   MeanMat= [MeanMat mean(f_pbest)];
    %% Display    
    plot(MaxMat,'r','Linewidth',2.5);
    xlabel('Iterations')
    ylabel('Cost')
    hold on
    plot(MeanMat,'b:','Linewidth',2);
    hold off
    grid on
    xlim([1 MAXITER])
    title(['max: ' num2str(MAXIUM)  ', mean: ' num2str(mean(f_pbest))]);
    legend('best fit','mean fit');
    pause(0.05)
end



gbest
MAXIUM

input_new=get_new_image(store_input,gbest);
input_new=uint8(input_new);
figure
subplot(1,3,1);
imshow(store_input);title('待配准图像');
subplot(1,3,2);
imshow(base);title('tv');
subplot(1,3,3);
imshow(input_new);title('已配准图像');
figure,
imshowpair(base,input_new);
toc

        
 