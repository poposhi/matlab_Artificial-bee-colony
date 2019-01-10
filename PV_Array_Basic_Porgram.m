% |||||||||||||||||||||||| PV_Characteristics ||||||||||||||||||||||||||||| 

clc;
close all;
clear all;

%EEE_HUB EEE_HUB EEE  Constant Declaration  EEE_HUB EEE_HUB EEE_HUB EEE_HUB

K=1.38065e-23;                                           %Boltzman Constant
q=1.602e-19;                                             %Electron's Charge
Iscn=8.21;                               %Desigerable Short Circuit Current 
Vocn=32.9;                               % Desigerable Open Circuit Voltage 
Kv=-0.123;                                  % Temperature  Voltage Constant 
Ki=0.0032;                                   %Temperature  Current Constant
Ns=54;                                     %Number of Series Conected Cells
T=25+273;                                 % Operating Temperature in Kelvin
Tn=30+273;                                              %Temperature at STC 
Gn=1000;                                                 %Irradiance at STC 
a=2.0;                                     %Diode Ideality Constant [1<a<2]
Eg=1.2; %Band Gap of silicon at Temperature of STC condition [ 25 deg. Cel]
G=1000;                                                  %Actual Irradiance
Rs=0.221;                          %Series Resistance of Equivalent PV cell 
Rp=415.405;                      %Parallel Resistance of Equivalent PV cell



%EEE_HUB EEE_HUB EEE Parameter's Value Calculation  EEE_HUB EEE_HUB EEE_HUB

Vtn=Ns*((K*Tn)/q);                                             % Equation 2

I0n=Iscn/((exp(Vocn/(a*Vtn)))-1);                              % Equation 5

I0=I0n*((Tn/T)^3)*exp(((q*Eg/(a*K))*((1/Tn)-(1/T))));           %Equation 4

Ipvn=Iscn;

Ipv=(G/Gn)*(Ipvn+Ki*(T-Tn));                                    %Equation 3

Vt=Ns*((K*T)/q);

i=1;
I(1)=0;

for (V=Vocn: -0.1: 0)
    
    I_term1=I0*(exp((V+I(i)*Rs)/(Vt*a))-1);             %Part of Equation 1
    
    I_term2= (V+I(i)*Rs)/Rp;                           % Part of Equation 1
    
    I(i+1)=Ipv-(I_term1+I_term2);                               %Equation 1
        
    
    if I(i)>0                     % Negative Power and Current Control Loop
       I(i)=I(i);
    else 
       I(i)=0;
    end
    
    
    Pi(i)=V*I(i);
    
    Vi(i)=V;
    
    i=i+1;
end



%EEE_HUB EEE_HUB EEE Graphical Interface   EEE_HUB EEE_HUB EEE_HUB  EEE_HUB
figure(1)
plot(Vi(1:i-1),I(1:i-1),'r', 'Linewidth',2.5)
xlabel('Voltage (volt)');
ylabel('Current (Amp)');

figure(2)
plot(Vi(1:i-1),Pi(1:i-1),'k', 'Linewidth',2.5)
xlabel('Voltage (volt)');
ylabel('Power (Watt)');

% |||||||||||||||||||||:||||||||||| End |||||||||||||||||||||||||||||||||||  




