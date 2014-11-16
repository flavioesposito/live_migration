addpath /Users/flavioesposito/Documents/MATLAB/ggplab;
%global QUIET;
%QUIET =1;
close all
clear all
plotta =1;

%Global vars for plots
TotMin1 =[];
TotMin2 =[];
TotMin3 =[];
iter = [];

% Simulation parameter
mu = 1; % VM size multiplying factor

%%%%%%%%%%%%%%%%%%%%
I=11;
Rmatrix = zeros(I);
RMAX = 125;% 1 Gbps = 125 Mbytes/s
M = 3;   
Vmem = 1000*mu; %1 GB = 1000 MB
Ro = RMAX;  
D = 10.24; %2500 pps = 81.92 Mbps = 10.24 MBytes/s
  
%Vmem = 3*ones(3,1);

%clear all;
for nj=1:I;  % total number of rounds  % n_j
    
    %%%%%%%%%%%%%%%%% PROBLEM INPUT
    gpvar R(I);  %R(i,j) rounds x VMs

    
    %%%%%%%%%%%% BUILD OBJECTIVE FUNCTION %%%%%%%%%  
    Tmig = posynomial;
    Tmig = buildObj_Tmig(nj,D,R,Vmem,mu);
    
    %%%%%%%%%%%% BUILD CONSTRAINTS %%%%%%%%%  
    constr = buildConstraints(nj,RMAX,R,D, I);
    
    % solve problem
    [min,solution,status] = gpsolve(Tmig, constr,'min')
    assign(solution)

    % Store input
    for k=1:size(R)
        Rmatrix(k,nj)=R(k);
    end
    
    TotMin1 = [TotMin1; min];
    iter = [iter; nj-1];
end


% Simulation parameter
mu = 2; % VM size multiplying factor
for nj=1:I;  % total number of rounds  % n_j
    
    %%%%%%%%%%%%%%%%% PROBLEM INPUT
    gpvar R(I);  %R(i,j) rounds x VMs

    
    %%%%%%%%%%%% BUILD OBJECTIVE FUNCTION %%%%%%%%%  
    Tmig = posynomial;
    Tmig = buildObj_Tmig(nj,D,R,Vmem,mu);
    
    %%%%%%%%%%%% BUILD CONSTRAINTS %%%%%%%%%  
    constr = buildConstraints(nj,RMAX,R,D, I);
    
    % solve problem
    [min,solution,status] = gpsolve(Tmig, constr,'min')
    assign(solution)

    % Store input
    for k=1:size(R)
        Rmatrix(k,nj)=R(k);
    end
    
    TotMin2 = [TotMin2; min];
    %iter = [iter; nj];
end

% Simulation parameter
mu = 4; % VM size multiplying factor
for nj=1:I;  % total number of rounds  % n_j
    
    %%%%%%%%%%%%%%%%% PROBLEM INPUT
    gpvar R(I);  %R(i,j) rounds x VMs

    
    %%%%%%%%%%%% BUILD OBJECTIVE FUNCTION %%%%%%%%%  
    Tmig = posynomial;
    Tmig = buildObj_Tmig(nj,D,R,Vmem,mu);
    
    %%%%%%%%%%%% BUILD CONSTRAINTS %%%%%%%%%  
    constr = buildConstraints(nj,RMAX,R,D, I);
    
    % solve problem
    [min,solution,status] = gpsolve(Tmig, constr,'min')
    assign(solution)

    % Store input
    for k=1:size(R)
        Rmatrix(k,nj)=R(k);
    end
    
    TotMin3 = [TotMin3; min];
    %iter = [iter; nj];
end



% plot
if(plotta ==1)
    figure;
    plot(0,0,'k:o','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on
    plot(0,0,'k--d','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on
    plot(0,0,'k-d','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','k');hold on


    LegendLabels = {'VM size = 4 GB','VM size = 2 GB', 'VM size = 1 GB'};
    legend(LegendLabels,3,'FontSize',22,'FontName','Times New Roman','Location','NorthWest');
    legend boxoff

    plot(iter,TotMin3/60,'k:o','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on;
    plot(iter,TotMin2/60,'k--d','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on;
    plot(iter,TotMin1/60,'k-d','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','k');
   % axis([0 10 0 20]);

    set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'XLabel'),'FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'YLabel'),'FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'title'),'FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'title'),'FontName','Times New Roman');

    %title('Impact of VM Migration Time');
    xlabel('Memory Transferred [rounds]');ylabel('Migration Time [min]');

    saveas(gcf,'./generated_figures/TmigImpactVMsize.eps');


    
    figure;
    semilogy(0,0,'k:o','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on
    semilogy(0,0,'k--d','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on
    semilogy(0,0,'k-d','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','k');hold on


    LegendLabels = {'VM size = 4 GB','VM size = 2 GB', 'VM size = 1 GB'};
    legend(LegendLabels,3,'FontSize',22,'FontName','Times New Roman','Location','NorthWest');
    legend boxoff
    set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'XLabel'),'FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'YLabel'),'FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'title'),'FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'title'),'FontName','Times New Roman');

    %title('Impact of VM Migration Time');
    xlabel('Memory Transferred rounds]');ylabel('Migration Time [min]');


    semilogy(iter,TotMin3/60,'k:o','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on;
    semilogy(iter,TotMin2/60,'k--d','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on;
    semilogy(iter,TotMin1/60,'k-d','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','k');

    %errorbar(vswitchCount ,bw_1,ci1,'k-d','LineWidth',3,'MarkerSize',20,'MarkerFaceColor','k');hold on
    %errorbar(vswitchCount ,bw_2,ci2,'k--d','LineWidth',3,'MarkerSize',20,'MarkerFaceColor','w');


    set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'XLabel'),'FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'YLabel'),'FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'title'),'FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'title'),'FontName','Times New Roman');

    %title('Impact of VM Migration Time');
    xlabel('Memory Transferred [rounds]');ylabel('Migration Time [min]');
    saveas(gcf,'./generated_figures/TmigImpactVMsize_semilogy.eps');

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

	LegendLabels = {'main memory','1st dirty page', '2nd dirty page','3rd dirty page','4th dirty page','5th dirty page','6th dirty page','7th dirty page','8th dirty page','9th dirty page','10th dirty page'};
    legend(LegendLabels,2,'FontSize',14,'FontName','Times New Roman','Location','NorthEast');
    legend boxoff
    set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'XLabel'),'FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'YLabel'),'FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'title'),'FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'title'),'FontName','Times New Roman')
    axis([0 12 0 1050]) 
    saveas(gcf,'./generated_figures/BarTmigRate100.eps');

end