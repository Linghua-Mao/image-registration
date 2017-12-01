clc
clear
close all
%% Try Hybird GA and PSO, The main idea: Add Mutation And Crossover in PSO
addpath('./image')
input=imread('tv3.png');
base=imread('ir3.png');
[row,col,c]=size(base);
[row1,col1,c1]=size(input);

% scale_x = row/row1;
% scale_y = col/col1;
% scale = min(scale_x,scale_y);
% scale_lb=scale-scale/2;
% scale_ub=scale+scale/2;

if c>1
base = rgb2gray(base);
end

if c1>1
input = rgb2gray(input);
end


if row > row1
    row=row1;
end
if col > col1
    col=col1;
end
input = input(1:row,1:col);
store_input=input;
%% PSO Parameter Initial
popsize = 100;
dimension = 3;
iteration = 100;
lb = [-50,-50,-2];
ub = [50,50,2];
x = rand(popsize,dimension).*repmat(ub-lb,popsize,1) + repmat(lb, popsize,1);

pbest = x;
for i=1:popsize
    f_x(i)=f4(base,input,x(i,:));
    f_pbest(i)=f_x(i);
end

%寻找全局最大值
g=max(find(f_pbest==max(f_pbest(1:popsize))));
gbest=pbest(g,:);   
f_gbest=f_pbest(g);

%% GA Parameter Initial
Keep_percent = 0.5;
CrossOver_percent = 0.5;
Mutation_percent = 0.8;
KeepNum = popsize * Keep_percent;
CrossOverNum = popsize * CrossOver_percent;
if mod(CrossOverNum,2) ~= 0
    CrossOverNum = CrossOverNum + 1;
end
MutationNum = popsize * Mutation_percent;

MaxMat = [];
MeanMat = [];
count =0;
for iter = 1:iteration
    iter
    beta=(1.0-0.5)*(iteration-iter)/iteration+0.5;
    for i=1:popsize
        %杂交
        SlectedIndexes = SelectParents_Fcn(f_pbest,CrossOverNum,1);
        CrossPop = [];
        for ii = 1:2:CrossOverNum
            Par1Index = SlectedIndexes(ii);
            Par2Index = SlectedIndexes(ii+1);        
            Par1 = x(Par1Index,:);
            Par2 = x(Par2Index,:);        
            [Off1 , Off2] = CrossOver_fcn(Par1,Par2);
            CrossPop = [CrossPop ; Off1 ; Off2];
        end
        x(KeepNum+1:KeepNum+CrossOverNum,:) = CrossPop;
        %粒子群算法
        fi=rand(1,dimension);
        p=fi.*pbest(i,:)+(1-fi).*gbest;
        u=rand(1,dimension);
        b=beta*abs(p-x(i,:));       
        v=-log(u); 
        x(i,:)=p+((-1).^ceil(0.5+rand(1,dimension))).*b.*v;
        
        x(:,1) =  round(x(:,1));
        x(:,2) =  round(x(:,2));
        
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
            last_fgbest = f_gbest;
            f_gbest=f_pbest(i);
        end
         %找出最多的粒子，判断是否超过一半，超过一半切迭代次数没有超过一半，则进行编译操作
        tongji=tabulate(f_pbest);
       if(max(tongji(:,2)))>=50  && iter < iteration/2
           particle = tongji(find(tongji(:,2)==max(tongji(:,2))),1);
           index = find(abs(f_pbest-particle)<10e-6);
           mutation_num = numel(index);
           mutation_pop = rand(mutation_num,dimension).*repmat(ub-lb,mutation_num,1) + repmat(lb, mutation_num,1);
           x(index,:) = mutation_pop;
           %更新变异对应的粒子最佳位置
           for j=1:mutation_num
                f_x(index(j))=f4(base,input,x(index(j),:));
                f_pbest(index(j))=f_x(index(j));
           end

       end
    end
   %% Display 
   MaxMat=[MaxMat f_gbest];
   MeanMat= [MeanMat mean(f_pbest)];
    plot(MaxMat,'r','Linewidth',2.5);
    xlabel('Iterations')
    ylabel('Cost')
    hold on
    plot(MeanMat,'b:','Linewidth',2);
    hold off
    grid on
    xlim([1 iteration])
    title(['max: ' num2str(f_gbest)  ', mean: ' num2str(mean(f_pbest))]);
    legend('best fit','mean fit');
    pause(0.05)
end
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
