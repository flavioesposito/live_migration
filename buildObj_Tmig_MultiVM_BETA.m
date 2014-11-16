%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Flavio Esposito   Oct 15 2014
% function to build objective of VM migration time 
% single VM to be transferred
%
% IN:
% D       : memory dirtying rate
% R(I)    : geometric programming variable gpvar
% Vmem    : vector 1 x M of sizes of the VMs to be migrated
% mu      : muliplicative factor for definiing the VM size


% OUT
% Tmig : posynomial objective migration time
%
                
function Tmig = buildObj_Tmig_MultiVM_BETA(nj,D,R,Vmem,mu)

    TmigTemp = posynomial;
    Tmig = posynomial;
    %construct big parenthesus of Tmig
 
    for j = 1:size(Vmem,2)          
            TmigTemp = ComputeTmig(nj,D,mu,R,Vmem,j);
            Tmig = Tmig + TmigTemp;
    end

    return 
end

%recursive function
function TmigN = ComputeTmig(n,D,mu,R,Vmem,j)
       TmigN = posynomial;
       if(n==1)
            TmigN = mu*Vmem(j)/R(j);
            
       else
            TmigN = (D/R(j))^(n) * (mu*Vmem(j)) / R(j) + ...
                    ComputeTmig(n-1,D,mu,R,Vmem,j);
       end
       return
end