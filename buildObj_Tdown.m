%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Flavio Esposito   Oct 31 2014
% function to build objective of the VM downtime
% for single VM to be transferred
%
% IN:
% nj   : number of page rounds
% D    : memory dirtying rate
% R(I)  : geometric programming variable gpvar
% Vmem : size of the VM to be migrated
% mu   : muliplicative factor for definiing the VM size

% OUT
% Tdown : posynomial objective
%
function Tdown = buildObj_Tdown(nj,D,R,Vmem,mu)

    
    Tdown = posynomial;
    p1 = posynomial;  %productory _h=1^nj
    p1 = 1; 
    
    if (nj >=2)  %matlab starts from 1 not from 0
        for h =2:nj
               p1 = p1*(D/R(h-1))*(D/R(h));
        end
        Tdown = (mu*Vmem / R(1) ) * p1;
    else
        Tdown = 0;
    end   
    
    return 
end