%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Flavio Esposito   Oct 31 2014
% function to build objective of the VM downtime
% for single VM to be transferred
% the downtime is given by the 
% Assumption that D constant and R is the same across all rounds
%
% IN:
% nj         : number of page rounds + 1 %matlab starts from 1 not from 0
% D          : memory dirtying rate
% R(J)       : geometric programming variable gpvar 
%              rate assigned to VM J (constant w.r.t. all dirty page rounds)
% Vmem       : vector 1 x M of sizes of the VMs to be migrated
% mu         : muliplicative factor for definiing the VM size

% OUT
% Tdown : posynomial objective
%
function Tdown = buildObj_Tdown_MultiVM_BETA(nj,D,R,Vmem,mu)
     
    TdownTemp = posynomial;
    Tdown = posynomial;

    for j=1:size(Vmem,2) % M
        if (nj >=2)  %matlab starts from 1 not from 0
            TdownTemp = D^(nj-1)*(mu*Vmem(j)) / R(j)^(nj);  
        else
            TdownTemp = mu*Vmem(j)/R(j);
        end   
        Tdown = Tdown +TdownTemp;
    end
    return 
end