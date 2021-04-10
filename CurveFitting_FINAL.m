%% fix cpd=90, vary Ps
clc; clear all; close all;
cd('C:\Users\Ridhi\Documents\Spring_21\CollagenPaper');

%% Varying Ps
% cpd=90
Data=xlsread('VaryingPs_1_22_normalized.xlsx');
Ps=Data(:,6); kx=Data(:,7); ky=Data(:,8); kr=Data(:,9); R=Data(:,2); cpd=Data(:,3);


x=0:0.1:1;
a=1.955; b=4.728; c=0.5504;
y=a.*x.^b+c;

% cpd=70
Data=xlsread('VaryingPs_1_25_normalized.xlsx');
Ps2=Data(:,6); kx=Data(:,7); ky=Data(:,8); kr2=Data(:,9); R=Data(:,2); cpd=Data(:,3);

x2=0:0.1:1;
a=2.165; b=1.68; c=-0.2044;% update
y2=a.*x2.^b+c;

figure;
plot(x,y,'k--',Ps,kr,'k.',x2,y2,'k--',Ps2,kr2,'k.','LineWidth',3,'MarkerSize',10)
xlabel('Collagen Straightness'); ylabel('Stiffness Ratio'); axis([0.6 1 0 3]) 

legend('Sim-model-90','Sim-data-90','Sim-model-70','Sim-data-70')


%% Varying Cpd

cpd=0:5:90;

% simulated data
Data=xlsread('VaryingCpd_1_21_normalized.xls');
kx=Data(:,8); ky=Data(:,9); kr1=Data(:,10); cpd1=Data(:,1);

% exponential fit Ps=1
x1=-180:5:270;
a=0.3714; b=0.02266;
y1=a.*exp(b.*x2);



% Ps=0.85
Data=xlsread('VaryingCpd_Ps=0.85_normalized.csv');
kr2=Data(:,9);

% exponential fit
x2=-180:5:270;
a=0.92; b=0.0018;
y2=a.*exp(b.*x2);

figure;
plot(cpd1,kr1,'k.',x1,y1,'k--',cpd,kr2,'k.',x2,y2,'k--','LineWidth',3,'MarkerSize',10)
xlabel('Relative Collagen Direction'); ylabel('Stiffness Ratio'); axis([0 90 0 3])
legend('Sim-model-1','Sim-data-1','Sim-model-0.85','Sim-data-0.85')

%% experimental
% experimental data
close all; clear all; clc;
 Data= xlsread('DATAFINAL.xlsx');
Ps=Data(:,7); kr=Data(:,10); 

cpd=0:5:90;
% simulated data
Data=xlsread('VaryingCpd_Ps=0.85_normalized.csv');
kr=Data(:,9);



% exponential fit
x2=-180:5:270;
a=0.92; b=0.0018;
y2=a.*exp(b.*x2);

%figure; 
hold on;
plot(cpd,kr,'r.',x2,y2,'g--')
xlabel('Relative Collagen Direction'); ylabel('Stiffness Ratio'); axis([0 90 0 3])
legend('Exp-data','Sim-data','Sim-model-sigmoidal','Sim-data-exponential')
