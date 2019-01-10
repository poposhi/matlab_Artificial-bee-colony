clc; 
clear; 
close all;

%�����D�i�H��˩w�q�Ƶ{��  
%������Ĥ���n�b�e�� �p�ѹ����ηN�O����
costfunc =@(x)  Sphere(x);    % Cost Function
% 
% function output =sphere(x) 
% 	output = sum(x.^2);
% end



%�o�ӿ��~�n���O�e���w�qfunc�����D 
nvar =  3;
var_size = [1 nvar]; 
var_max =10;
var_min =-10;

%�H�u���s�]�m
maxit = 100;
npop = 100; % �u�� npop��
nonlook =npop;
L=round(0.6*nvar*npop); % �˥h���
a=1; 

%���X�e��
bee.position = [];  %
bee.cost=[];

%���X���s
pop = repmat(bee,100,1); %
%pop=repmat(empty_bee,nPop,1);

best_each = zeros(maxit);
%�̨θ�    best_cost = inf;  
BestSol.Cost=inf;
%�C�@�Ӧ�m���Ѫ����� C=zeros(nPop,1);
fail = zeros(npop,1);


%��l�Ʀ�m
for m = 1:npop %pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
    pop(m).position= unifrnd (var_min,var_max,var_size) ; %�d�򭭨� ��X�Ϊ�
    pop(m).cost = costfunc(pop(m).position); %������ƪ���J���ӷ| %pop(i).Cost=CostFunction(pop(i).Position);

%     pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
%     pop(i).Cost=CostFunction(pop(i).Position);
    %��̦n�����G�O���U�� 
     if pop(m).cost  <BestSol.Cost
            BestSol.Cost=pop(m).cost;
     end
end

best_cost = zeros(maxit,1);
%abc loop 
for it =1:maxit %��i��
    best_cost(it) = inf;
    for ii =1:npop %��ii��
    %�H����e��
    other = [1:ii-1 ii+1:npop];%�ѤU���X�� K�O�@�ӦsINDEX���x�}�A�]���ۤv��INDEX�A�n�q�L��INDEX��X�H��
    k=other(randi([1 numel(other)])); %��X�ѤU�X�Ӫ��ĴX��(randi)�A�b�����쥻��indnx
   
    %�Z���h��        phi=a*unifrnd(-1,+1,VarSize);   �ڤ֤Fa
    phi = unifrnd(-1,1,var_size);
    %�s��m    newbee.Position=pop(i).Position+phi.*(pop(i).Position-pop(k).Position);
    newbee.position = pop(ii).position+phi.*( pop(k).position-pop(ii).position );
    %����s��m
        %��s�Z��
        newbee.cost = costfunc(newbee.position);
        if  newbee.cost <pop(ii).cost
            pop(ii)= newbee;
        else
            fail(ii)=fail(ii)+1;
        end
        
    end


%�p��ڤ@��������fitness value �٦����v
F=zeros(npop,1); %�s���Ȫ��F��
MeanCost = mean([pop.cost]);
for i=1:npop
        F(i) = exp(-pop(i).cost/MeanCost); % Convert Cost to Fitness
end %fitness value = exp�P�����Z�������

P=F/sum(F);

%���[��
for ii = 1:nonlook %��ii�����[��
%�̷�fitness���v��ܸ��ܲĴX���u��
    i=RouletteWheelSelection(P);%��X�ĴX���u�� ��i��
    
    other = [1:ii-1 ii+1:npop];
    k=other(randi([1 numel(other)]));  %��X��V�u�� ��k��
    
    %�Z���h��        phi=a*unifrnd(-1,+1,VarSize);
    phi = unifrnd(-1,1,var_size);
  
    newbee.position = pop(i).position+phi.*( pop(k).position-pop(i).position );
   
    
    %��s�Z��
        newbee.cost = costfunc(newbee.position);
        if  newbee.cost <pop(i).cost
            pop(i)= newbee;
        else
            fail(i)=fail(i)+1;
        end
end

% ���d�e��scout 
for i=1:npop
    if fail(i)>L %���ѤӦh���N���L�@�ӷs��m
    pop(i).position= unifrnd (var_min,var_max,var_size) ; 
    pop(i).cost = costfunc(pop(i).position);
    fail(i)=0;
    end
end

%�p��̨θ�
for ii = 1:npop %�o�����̨θѡA���Ӥ]�|�O���v�̨�
    if pop(ii).cost<best_cost(it)
    best_cost(it) =pop(ii).cost;
    end
end





end



for it = 1:maxit %�o�����̨θѡA���Ӥ]�|�O���v�̨�
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




