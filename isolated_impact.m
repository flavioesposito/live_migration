addpath /Users/flavioesposito/Documents/MATLAB/ggplab;

%close all
clear all
global QUIET;
QUIET =1;

%Global vars for plots
Z=5;   % iteration to compute confidence interval
I=10;  % rounds (dirty pages to be trnasferred plus main VM)
nj=I;
TotMin1 =zeros(I,Z);
TotMin2 =zeros(I,Z);
TotMin3 =zeros(I,Z);


% Simulation parameter
plotta =1;

mu = 4; % VM size multiplying factor


%%%%%%%%%%%%%%%%%%%%%%%
% Simulation parameters

Rmatrix = zeros(I);

q  = 0.2;             % fraction of VM with smaller size
M = 3;                % number of VMs
avg = 1000;           % mean of VM distribution 
var = 300;             % variance of VM distribution 
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
        Cmig =0;
        Cdown =1;

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
        

        obj = posynomial;
        obj =  Cmig*Tmig + Cdown*Tdown;
       

        %%%%%%%%%%%% BUILD CONSTRAINTS %%%%%%%%%  
        constr = buildConstraints(M,RMAX,R,D);

        % solve problem
        [min,solution,status] = gpsolve(obj, constr,'min');
        assign(solution)

        % Store input
        for k=1:size(R)
            Rmatrix(k,nj)=R(k);
        end

        TotMin1(nj,z) = min;
      
    end
    


end

Cmig =1;
Cdown =0; 
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
        

        obj = posynomial;
        obj =  Cmig*Tmig + Cdown*Tdown;
       

        %%%%%%%%%%%% BUILD CONSTRAINTS %%%%%%%%%  
        constr = buildConstraints(M,RMAX,R,D);

        % solve problem
        [min,solution,status] = gpsolve(obj, constr,'min');
        assign(solution)

        % Store input
        for k=1:size(R)
            Rmatrix(k,nj)=R(k);
        end

        TotMin2(nj,z) = min;
      
    end
    


end

 
Cmig =1;
Cdown =1;
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
        

        obj = posynomial;
        obj =  Cmig*Tmig + Cdown*Tdown;
       

        %%%%%%%%%%%% BUILD CONSTRAINTS %%%%%%%%%  
        constr = buildConstraints(M,RMAX,R,D);

        % solve problem
        [min,solution,status] = gpsolve(obj, constr,'min');
        assign(solution)

        % Store input
        for k=1:size(R)
            Rmatrix(k,nj)=R(k);
        end

        TotMin3(nj,z) = min;
      
    end
    


end



avgTotMin1 = mean(TotMin1');
stdTotMin1 = std(TotMin1'); 
E1 = 1.96 * stdTotMin1/sqrt(Z);   % 95 confidence interval

avgTotMin2 = mean(TotMin2')
stdTotMin2 = std(TotMin2'); 
E2 = 1.96 * stdTotMin2/sqrt(Z);   % 95 confidence interval

avgTotMin3 = mean(TotMin3');
stdTotMin3 = std(TotMin3'); 
E3 = 1.96 * stdTotMin3/sqrt(Z);   % 95 confidence interval


% plot
if(plotta ==1)
    figure;
    %plot(0,-1,'k:o','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on
    %plot(0,-1,'k--d','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on
    %plot(0,-1,'k-d','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','k');hold on


    
    errorbar(iter,avgTotMin3,E3,'k:o','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on;
    errorbar(iter,avgTotMin2,E2,'k--d','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on;
    errorbar(iter,avgTotMin1,E1,'k-d','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','k');
    
    LegendLabels = {'only T_{down}','only T_{mig}', 'T_{mig}+T_{down}'};
    legend(LegendLabels,3,'FontSize',22,'FontName','Times New Roman','Location','NorthEast');
    legend boxoff
    
    %plot(iter,TotMin3/60,'k:o','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on;
    %plot(iter,TotMin2/60,'k--d','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on;
    %plot(iter,TotMin1/60,'k-d','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','k');
    axis([-1 10 0 1500]);

    set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'XLabel'),'FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'YLabel'),'FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'title'),'FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'title'),'FontName','Times New Roman');

    %title('Impact of VM Migration Time');
    xlabel('Memory Transferred [rounds]');ylabel('Migration Time [s]');

     saveas(gcf,'../generated_figures/Separate_Tmig_Tdown_Rate3VM_gauss.eps');
    saveas(gcf,'../generated_figures/Separate_Tmig_Tdown_Rate3VM_gauss.fig');

%     %plot in log scale   
%      figure;
%  %    semilogy(0,0,'k:o','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on
% %     semilogy(0,0,'k--d','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on
% %     semilogy(0,0,'k-d','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','k');hold on
% % 
% % 
%      LegendLabels = {'VM size = 4 GB','VM size = 2 GB', 'VM size = 1 GB'};
%      legend(LegendLabels,3,'FontSize',22,'FontName','Times New Roman','Location','NorthWest');
%      legend boxoff
%      set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',22)
%      set(get(get(gcf,'CurrentAxes'),'XLabel'),'FontSize',22)
%      set(get(get(gcf,'CurrentAxes'),'YLabel'),'FontSize',22)
%      set(get(get(gcf,'CurrentAxes'),'title'),'FontSize',22)
%      set(get(get(gcf,'CurrentAxes'),'title'),'FontName','Times New Roman');
% 
%     %title('Impact of VM Migration Time');
%     xlabel('Memory Transferred rounds]');ylabel('Migration Time [s]');
% 
% 
%     semilogy(iter,avgTotMin3,'k:o','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on;
%     semilogy(iter,avgTotMin2,'k--d','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on;
%     semilogy(iter,avgTotMin1,'k-d','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','k');

    %errorbar(vswitchCount ,bw_1,ci1,'k-d','LineWidth',3,'MarkerSize',20,'MarkerFaceColor','k');hold on
    %errorbar(vswitchCount ,bw_2,ci2,'k--d','LineWidth',3,'MarkerSize',20,'MarkerFaceColor','w');
% 
% 
%     set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',22)
%     set(get(get(gcf,'CurrentAxes'),'XLabel'),'FontSize',22)
%     set(get(get(gcf,'CurrentAxes'),'YLabel'),'FontSize',22)
%     set(get(get(gcf,'CurrentAxes'),'title'),'FontSize',22)
%     set(get(get(gcf,'CurrentAxes'),'title'),'FontName','Times New Roman');
% 
%     %title('Impact of VM Migration Time');
%     xlabel('Memory Transferred [rounds]');ylabel('Migration Time [min]');
%     saveas(gcf,'./generated_figures/TmigImpactVMsize_semilogyFULL.eps');

    %%%%%%%%%% BAR %%%%%%%%%
    figure;bar(Rmatrix'*8) %convert into Mbps
    % 
    % 
    set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'XLabel'),'FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'YLabel'),'FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'title'),'FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'title'),'FontName','Times New Roman');
    % 
    % %title('title');
    xlabel('Memory Transferred [rounds]');ylabel('Optimal Rates [Mbps]');
    LegendLabels = {'VM 1','VM 2', 'VM 3'};
 %LegendLabels = {'Rate for VM 1','Rate for VM 2', 'Rate for VM 3', 'Rate for VM 4'...
  %   'Rate for VM 5','Rate for VM 6'};
      legend(LegendLabels,3,'FontSize',22,'FontName','Times New Roman','Location','NorthWest');
      legend boxoff
    
    saveas(gcf,'../generated_figures/BarTmigRate3VM.eps');
    saveas(gcf,'../generated_figures/BarTmigRate3VM.fig');

end