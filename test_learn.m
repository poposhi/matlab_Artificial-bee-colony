clc; 
clear; 
close all;

%不知道可以怎樣定義副程式  
%為什麼第五行要在前面 小老鼠的用意是什麼
costfunc =@(x)  Sphere(x);    % Cost Function
% 
% function output =sphere(x) 
% 	output = sum(x.^2);
% end



%這個錯誤好像是前面定義func的問題 
nvar =  3;
var_size = [1 nvar]; 
var_max =10;
var_min =-10;

%人工蜂群設置
maxit = 100;
npop = 100; % 工蜂 npop隻
nonlook =npop;
L=round(0.6*nvar*npop); % 捨去比例
a=1; 

%做出蜜蜂
bee.position = [];  %
bee.cost=[];

%做出蜂群
pop = repmat(bee,100,1); %
%pop=repmat(empty_bee,nPop,1);

best_each = zeros(maxit);
%最佳解    best_cost = inf;  
BestSol.Cost=inf;
%每一個位置失敗的次數 C=zeros(nPop,1);
fail = zeros(npop,1);


%初始化位置
for m = 1:npop %pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
    pop(m).position= unifrnd (var_min,var_max,var_size) ; %範圍限制 輸出形狀
    pop(m).cost = costfunc(pop(m).position); %成本函數的輸入不太會 %pop(i).Cost=CostFunction(pop(i).Position);

%     pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
%     pop(i).Cost=CostFunction(pop(i).Position);
    %把最好的結果記錄下來 
     if pop(m).cost  <BestSol.Cost
            BestSol.Cost=pop(m).cost;
     end
end

best_cost = zeros(maxit,1);
%abc loop 
for it =1:maxit %第i次
    best_cost(it) = inf;
    for ii =1:npop %第ii隻
    %隨機找蜜蜂
    other = [1:ii-1 ii+1:npop];%剩下有幾個 K是一個存INDEX的矩陣，也有自己的INDEX，要從他的INDEX找出隨機
    k=other(randi([1 numel(other)])); %找出剩下幾個的第幾個(randi)，在換成原本的indnx
   
    %距離多長        phi=a*unifrnd(-1,+1,VarSize);   我少了a
    phi = unifrnd(-1,1,var_size);
    %新位置    newbee.Position=pop(i).Position+phi.*(pop(i).Position-pop(k).Position);
    newbee.position = pop(ii).position+phi.*( pop(k).position-pop(ii).position );
    %比較新位置
        %算新距離
        newbee.cost = costfunc(newbee.position);
        if  newbee.cost <pop(ii).cost
            pop(ii)= newbee;
        else
            fail(ii)=fail(ii)+1;
        end
        
    end


%計算我一直不懂的fitness value 還有機率
F=zeros(npop,1); %存放比值的東西
MeanCost = mean([pop.cost]);
for i=1:npop
        F(i) = exp(-pop(i).cost/MeanCost); % Convert Cost to Fitness
end %fitness value = exp與平均距離的比值

P=F/sum(F);

%旁觀者
for ii = 1:nonlook %第ii隻旁觀者
%依照fitness機率選擇跟蹤第幾隻工蜂
    i=RouletteWheelSelection(P);%選出第幾隻工蜂 第i隻
    
    other = [1:ii-1 ii+1:npop];
    k=other(randi([1 numel(other)]));  %選出方向工蜂 第k隻
    
    %距離多長        phi=a*unifrnd(-1,+1,VarSize);
    phi = unifrnd(-1,1,var_size);
  
    newbee.position = pop(i).position+phi.*( pop(k).position-pop(i).position );
   
    
    %算新距離
        newbee.cost = costfunc(newbee.position);
        if  newbee.cost <pop(i).cost
            pop(i)= newbee;
        else
            fail(i)=fail(i)+1;
        end
end

% 偵查蜜蜂scout 
for i=1:npop
    if fail(i)>L %失敗太多次就給他一個新位置
    pop(i).position= unifrnd (var_min,var_max,var_size) ; 
    pop(i).cost = costfunc(pop(i).position);
    fail(i)=0;
    end
end

%計算最佳解
for ii = 1:npop %這次的最佳解，應該也會是歷史最佳
    if pop(ii).cost<best_cost(it)
    best_cost(it) =pop(ii).cost;
    end
end





end



for it = 1:maxit %這次的最佳解，應該也會是歷史最佳
    if best_cost(it)<BestSol.Cost
   BestSol.Cost =best_cost(it);
    end
end

disp (BestSol.Cost);


figure;
%plot(BestCost,'LineWidth',2);
semilogy(best_cost,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;




