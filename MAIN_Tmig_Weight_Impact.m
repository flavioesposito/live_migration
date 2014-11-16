addpath /Users/flavioesposito/Documents/MATLAB/ggplab;

close all
clear all
global QUIET;
QUIET =1;

%Global vars for plots
Z=1;   % iteration to compute confidence interval
I=10;  % rounds (dirty pages to be trnasferred plus main VM)
nj=I;
TotMin1 =zeros(I,Z);
TotMin2 =zeros(I,Z);
TotMin3 =zeros(I,Z);


% Simulation parameter
plotta =1;
Cmig =1;
Cdown =1;

mu = 1; % VM size multiplying factor


%%%%%%%%%%%%%%%%%%%%%%%
% Simulation parameters

Rmatrix = zeros(I);

q  = 0.2;             % fraction of VM with smaller size
M = 3;                % number of VMs
avg = 1000;           % mean of VM distribution 
var = 200;             % variance of VM distribution 
VMdistribution = 'n'; % choose bw 'uniform', 'bimodal', 'constant', 'normal'

RMAX = 125;% 1 Gbps = 125 Mbytes/s 
D = 10.24; %2500 pps = 81.92 Mbps = 10.24 MBytes/s

iter = 0:nj-1;
%clear all;
mu = 1               % VM size multiplying factor
for z = 1:Z  % simulation trials
    z        %to track simulations status
    mubimodal = 10;
    Vmem = GenerateVmem(M,mubimodal,VMdistribution,avg,var,q); %1 GB = 1000 MB
    for nj=1:I;  % total number of rounds  % n_j
        
        %%%%%%%%%%%%%%%%% PROBLEM INPUT
        gpvar R(M);  %R(i,j) rounds x VMs


        %%%%%%%%%%%% BUILD OBJECTIVE FUNCTION %%%%%%%%%  
        
        %%% Build Tdown
        Tdown = posynomial;
        Tdown = 0;%
        Tdown = buildObj_Tdown_MultiVM_BETA(nj,D,R,Vmem,mu);
        
        %%% Build Tmig
        Tmig = posynomial;
        Tmig = buildObj_Tmig_MultiVM_BETA(nj,D,R,Vmem,mu);
        
        %%%%%%%%%%%% BUILD CONSTRAINTS %%%%%%%%%  
        constr = buildConstraints(M,RMAX,R,D);

        %%%%%%%%%%%% BUILD OBJECTIVE %%%%%%%%%  
        obj = posynomial;
        index=1;
        a = [];
        
        for alpha = 0:0.1:1
            
            obj =  alpha*Tmig + (1-alpha)*Tdown;
        
    
             % solve problem
            [min,solution,status] = gpsolve(obj, constr,'min');
            assign(solution)


            TotMin1(nj,z) = min;
            
            ToTminAlpha(nj,z,index) = min;
            a = [a, min]
            index = index+1;
            
        end
        ALPHA = 0:0.1:1;
        minimo = ToTminAlpha(nj,z,:);
        
        switch nj
            case 1
                 leg1='-ko'
                 leg2='k'
            case 2
                 leg1='--ko'
                 leg2='w'
            case 3
                 leg1='-ks'
                 leg2='k'
            case 4
                 leg1='--ks'
                 leg2='w'
            case 5
                 leg1='-ko'
                 leg2='k'
            case 6
                 leg1='--ko'
                 leg2='w'
            case 7
                 leg1='-kv'
                 leg2='k'
            case 8
                 leg1='--kv'
                 leg2='w'
            case 9
                 leg2='-kx'
                 leg2='k'
            case 10
                 leg1='--kx'
                 leg2='w'
        end
        
        
        plot(ALPHA,a,leg1,'LineWidth',2,'MarkerSize',10,'MarkerFaceColor',leg2);hold on;
  
         
    end
    


end
        
   LegendLabels = {'n_j=0','n_j=1', 'n_j=2', 'n_j=3', 'n_j=4', 'n_j=5', 'n_j=6'...
       , 'n_j=7', 'n_j=8', 'n_j=9', 'n_j=10'};
    legend(LegendLabels,3,'FontSize',22,'FontName','Times New Roman','Location','NorthEast');
    legend boxoff   
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',22)
set(get(get(gcf,'CurrentAxes'),'XLabel'),'FontSize',22)
set(get(get(gcf,'CurrentAxes'),'YLabel'),'FontSize',22)
set(get(get(gcf,'CurrentAxes'),'title'),'FontSize',22)
set(get(get(gcf,'CurrentAxes'),'title'),'FontName','Times New Roman');

%title('Impact of VM Migration Time');
xlabel('Objective Weight \alpha ');ylabel('Migration Time [s]');

saveas(gcf,'../generated_figures/Weight_impact_on_obj_MultiVM_TMigImpact_VMsize_constant_size.eps');

 