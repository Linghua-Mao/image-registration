%% Start of the program.
clc
clear
close all
addpath('./image');
%% Problem Statement
NPar = 3;              % Number of Optimization Parameters
VarLow =[-50 -50 -2]; % Lower Limmit of problem
VarHigh =[50 50 2];   % Upper Limmit of problem
FunName = 'fitness';
%% Algoritm Parameters
PopSize = 50;
ChromLenght = NPar;
MaxIterations = 20;
KeepPercent = 50/100;
CrossPercent = 50/100;
MutatPercent = 1 - KeepPercent - CrossPercent;
SelectionMode = 1;

KeepNum = round(KeepPercent * PopSize);
CrossNum = round(CrossPercent * PopSize);
if mod(CrossNum,2) ~= 0
    CrossNum = CrossNum + 1;
end
MutatNum = PopSize - KeepNum - CrossNum;

%% Initial Population
AA=rand(PopSize,NPar);
AB=VarHigh - VarLow;
ABC=[];
for i=1:NPar
    C=AA(:,i)*AB(:,i)+VarLow(1,i);
    ABC=[ABC C];
end
Pop = ABC;
clear AA AB ABC C;
for i=1:PopSize
Cost(i) = feval(FunName,Pop(i,:));
end
[Cost Indx] = sort(Cost,'descend');
Pop = Pop(Indx,:);

%% MAIN LOOP
MaxMat = [];
MeanMat = [];
tic
for Iter = 1:MaxIterations
    Iter
    %% Select Keep
    Pop(1:KeepNum,:) = PSO_Fcn(Pop(1:KeepNum,:));
    %% CrossOver
    SlectedIndexes = SelectParents_Fcn(Cost,CrossNum,SelectionMode);
    CrossPop = [];
    for ii = 1:2:CrossNum
        Par1Index = SlectedIndexes(ii);
        Par2Index = SlectedIndexes(ii+1);        
        Par1 = Pop(Par1Index,:);
        Par2 = Pop(Par2Index,:);        
        [Off1 , Off2] = CrossOver_fcn(Par1,Par2);
        CrossPop = [CrossPop ; Off1 ; Off2];
    end
    
    Pop(KeepNum+1:KeepNum+CrossNum,:) = CrossPop;
    %% Mutation
    AA=rand(MutatNum,NPar);
    AB=VarHigh - VarLow;
    ABC=[];
    for i=1:NPar
        C=AA(:,i)*AB(:,i)+VarLow(1,i);
        ABC=[ABC C];
    end
    Pop(KeepNum+CrossNum+1 : end , :)= ABC;
    clear AA AB ABC;
    [m,n] = size(Pop);
    %% NewPopulation
    for i=1:n
        jj=1;
      while jj<=m
          if  Pop(jj,i)>VarHigh(1,i)
              Pop(jj,i)=VarHigh(1,i);
          end
          
          if  Pop(jj,i)<VarLow(1,i)
              Pop(jj,i)=VarLow(1,i);
          end
          jj=jj+1;
      end;
    end;     
    for i=1:PopSize
        Cost(i) = feval(FunName,Pop(i,:));
    end
    
    [Cost Indx] = sort(Cost,'descend');
    Pop = Pop(Indx,:);
    
    MaxMat = [MaxMat max(Cost)];
    MeanMat = [MeanMat mean(Cost)];
    
    %% Display    
    plot(MaxMat,'r','Linewidth',2.5);
    xlabel('Iterations')
    ylabel('Cost')
    hold on
    plot(MeanMat,'b:','Linewidth',2);
    hold off
    grid on
    xlim([1 MaxIterations])
    title(['max: ' num2str(max(Cost))  ', mean: ' num2str(mean(Cost))]);
    legend('best fit','mean fit');
    pause(0.05)
    
end
%% Final Result Display
BestSolution = Pop(1,:)
BestCost = Cost(1)
fval=BestCost;
toc
%% 显示配准结果
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
base = double(base);
input = double(input);
input_new=get_new_image(input,BestSolution);
input_new=uint8(input_new);
figure
subplot(1,3,1);
imshow(input,[]);title('待配准图像');
subplot(1,3,2);
imshow(base,[]);title('tv');
subplot(1,3,3);
imshow(input_new);title('已配准图像');
input=uint8(input);
figure,
imshowpair(input,base);
title('未配准前');
figure,
imshowpair(input_new,base);
title('配准后');