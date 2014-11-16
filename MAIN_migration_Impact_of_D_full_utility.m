addpath /Users/flavioesposito/Documents/MATLAB/ggplab;
global QUIET;
QUIET =1;
close all
clear all


%Global vars for plots

TotMin1 =[];
TotMin2 =[];
TotMin3 =[];
pageRate = [];


% Simulation parameter
plotta =1;
Cmig =1;
Cdown =1;
Z=20

q  = 0.2;             % fraction of VM with smaller size
M = 3;                % number of VMs
avg = 1000;           % mean of VM distribution 
var = 200;             % variance of VM distribution 
VMdistribution = 'b'; % choose bw 'uniform', 'bimodal', 'constant', 'normal'


mu = 1; % VM size multiplying factor

%%%%%%%%%%%%%%%%%%%%
I=11;
Rmatrix = zeros(I);
RMAX = 125;% 1 Gbps = 125 Mbytes/s
 
Vmem = 1000*mu; %1 GB = 1000 MB
Ro = RMAX;  
D = 10.24; %2500 pps = 81.92 Mbps = 10.24 MBytes/s
iter = 2.24:2:20.48; 
%Vmem = 3*ones(3,1);
for z =1:Z
    z        %to track simulations status
    mubimodal = 10;
    Vmem = GenerateVmem(M,mubimodal,VMdistribution,avg,var,q); %1 GB = 1000 MB
    
    nj=2;
    d=1;
    
    for D=2.24:2:20.48;  % total number of rounds  % n_j
    
        %%%%%%%%%%%%%%%%% PROBLEM INPUT
        gpvar R(I);  %R(i,j) rounds x VMs



        %%%%%%%%%%%% BUILD OBJECTIVE FUNCTION %%%%%%%%%  
        Tmig = posynomial;
        Tmig = buildObj_Tmig_MultiVM_BETA(nj,D,R,Vmem,mu);
        

        Tdown = posynomial;
        Tdown = buildObj_Tdown_MultiVM_BETA(nj,D,R,Vmem,mu);
       


        obj = posynomial;
        obj = Cmig*Tmig + Cdown*Tdown;
        obj = Cmig*Tmig + Cdown*Tdown;

        %%%%%%%%%%%% BUILD CONSTRAINTS %%%%%%%%%  
        %constr = buildConstraints(nj,RMAX,R,D, I);
        constr = buildConstraints(M,RMAX,R,D);

        % solve problem
        [min,solution,status] = gpsolve(obj, constr,'min');
        assign(solution);

        % Store input
        for k=1:size(R)
            Rmatrix(k,nj)=R(k);
        end

        TotMin1(z,d) = min;
        d=d+1;
        if(z==1)
            pageRate = [pageRate; D];
        end
    end


nj=3;
    d=1;
    for D=2.24:2:20.48;  % total number of rounds  % n_j
    
    %%%%%%%%%%%%%%%%% PROBLEM INPUT
    gpvar R(I);  %R(i,j) rounds x VMs

    
    %%%%%%%%%%%% BUILD OBJECTIVE FUNCTION %%%%%%%%%  
    Tmig = posynomial;
    Tmig = buildObj_Tmig_MultiVM_BETA(nj,D,R,Vmem,mu);
        

	Tdown = posynomial;
    Tdown = buildObj_Tdown_MultiVM_BETA(nj,D,R,Vmem,mu);
       
                            
    
    obj = posynomial;
    obj = Cmig*Tmig + Cdown*Tdown;
    obj = Cmig*Tmig + Cdown*Tdown;
    
    %%%%%%%%%%%% BUILD CONSTRAINTS %%%%%%%%%  
    constr = buildConstraints(M,RMAX,R,D);
    
    
    % solve problem
    [min,solution,status] = gpsolve(obj, constr,'min');
    assign(solution);

    % Store input
    for k=1:size(R)
        Rmatrix(k,nj)=R(k);
    end
    
    TotMin2(z,d) = min;
    d=d+1;
end


    nj=4;
    d=1;
    for D=2.24:2:20.48;  % total number of rounds  % n_j

        %%%%%%%%%%%%%%%%% PROBLEM INPUT
        gpvar R(I);  %R(i,j) rounds x VMs


        %%%%%%%%%%%% BUILD OBJECTIVE FUNCTION %%%%%%%%%  

        Tmig = posynomial;
        Tmig = buildObj_Tmig_MultiVM_BETA(nj,D,R,Vmem,mu);
        
        Tdown = posynomial;
        Tdown = buildObj_Tdown_MultiVM_BETA(nj,D,R,Vmem,mu);

        obj = posynomial;
        obj = Cmig*Tmig + Cdown*Tdown;
        obj = Cmig*Tmig + Cdown*Tdown;

        %%%%%%%%%%%% BUILD CONSTRAINTS %%%%%%%%%  
        constr = buildConstraints(M,RMAX,R,D);

        % solve problem
        [min,solution,status] = gpsolve(obj, constr,'min');
        assign(solution);

        % Store input
        for k=1:size(R)
            Rmatrix(k,nj)=R(k);
        end
    
        TotMin3(z,d) = min;
        d=d+1;
    end

end


avgTotMin1 = mean(TotMin1);
stdTotMin1 = std(TotMin1); 
E1 = 1.96 * stdTotMin1/sqrt(Z);   % 95 confidence interval

avgTotMin2 = mean(TotMin2)
stdTotMin2 = std(TotMin2); 
E2 = 1.96 * stdTotMin2/sqrt(Z);   % 95 confidence interval

avgTotMin3 = mean(TotMin3);
stdTotMin3 = std(TotMin3); 
E3 = 1.96 * stdTotMin3/sqrt(Z);   % 95 confidence interval

% plot
if(plotta ==1)
    figure;
    errorbar(iter,avgTotMin3,E3,'k:o','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on;
    errorbar(iter,avgTotMin2,E2,'k--d','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on;
    errorbar(iter,avgTotMin1,E1,'k-d','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','k');
    
    %plot(40,0,'k-s','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','k');hold on
    %plot(40,0,'k--s','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on
    %plot(40,0,'k:o','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on

    LegendLabels = {'4 Transferring rounds','3 Transferring rounds', '2 Transferring rounds'};
    legend(LegendLabels,3,'FontSize',22,'FontName','Times New Roman','Location','NorthWest');
    legend boxoff

    %plot(pageRate/0.004096,TotMin1,'k:o','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on;
    %plot(pageRate/0.004096,TotMin2,'k--s','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on;
    %plot(pageRate/0.004096,TotMin3,'k-s','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','k');
    %axis([500 5000 15 50]);

    set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'XLabel'),'FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'YLabel'),'FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'title'),'FontSize',22)
    set(get(get(gcf,'CurrentAxes'),'title'),'FontName','Times New Roman');

    %title('Impact of VM Migration Time');
    xlabel('Page Dirty Rate [MB/s]');ylabel('Migration Time [s]');

    saveas(gcf,'../generated_figures/ImpactDirtyRateFULL.eps');


%     
%     figure;
%     semilogy(0,0,'k:o','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on
%     semilogy(0,0,'k--d','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on
%     semilogy(0,0,'k-d','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','k');hold on
% 
% 
%     LegendLabels = {'VM size = 4 GB','VM size = 2 GB', 'VM size = 1 GB'};
%     legend(LegendLabels,3,'FontSize',22,'FontName','Times New Roman','Location','NorthWest');
%     legend boxoff
%     set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',22)
%     set(get(get(gcf,'CurrentAxes'),'XLabel'),'FontSize',22)
%     set(get(get(gcf,'CurrentAxes'),'YLabel'),'FontSize',22)
%     set(get(get(gcf,'CurrentAxes'),'title'),'FontSize',22)
%     set(get(get(gcf,'CurrentAxes'),'title'),'FontName','Times New Roman');
% 
%     %title('Impact of VM Migration Time');
%     xlabel('Memory Transferred rounds]');ylabel('Migration Time [min]');
% 
% 
%     semilogy(iter,TotMin3/60,'k:o','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on;
%     semilogy(iter,TotMin2/60,'k--d','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','w');hold on;
%     semilogy(iter,TotMin1/60,'k-d','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','k');
% 
%     %errorbar(vswitchCount ,bw_1,ci1,'k-d','LineWidth',3,'MarkerSize',20,'MarkerFaceColor','k');hold on
%     %errorbar(vswitchCount ,bw_2,ci2,'k--d','LineWidth',3,'MarkerSize',20,'MarkerFaceColor','w');
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
% 
%     %%%%%%%%%% BAR %%%%%%%%%
%     figure;bar(Rmatrix'*8) %convert into Mbps
%     % 
%     % 
%     set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',22)
%     set(get(get(gcf,'CurrentAxes'),'XLabel'),'FontSize',22)
%     set(get(get(gcf,'CurrentAxes'),'YLabel'),'FontSize',22)
%     set(get(get(gcf,'CurrentAxes'),'title'),'FontSize',22)
%     set(get(get(gcf,'CurrentAxes'),'title'),'FontName','Times New Roman');
%     % 
%     % %title('title');
%     xlabel('Memory Transferred [rounds]');ylabel('Optimal Rates [Mbps]');
% 
%     saveas(gcf,'./generated_figures/BarTmigRate100FULL.eps');

end