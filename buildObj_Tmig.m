%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Flavio Esposito   Oct 15 2014
% function to build objective of VM migration time 
% single VM to be transferred
%
% IN:
% nj   : number of page rounds
% D    : memory dirtying rate
% R(I)  : geometric programming variable gpvar
% Vmem : size of the VM to be migrated
% mu   : muliplicative factor for definiing the VM size

% OUT
% Tmig : posynomial objective
%
function Tmig = buildObj_Tmig(nj,D,R,Vmem,mu)

    
    Tmig = posynomial;
    p1 = posynomial;  %productory _h=1^i
    p2 = posynomial;  %sum _i=1^nj
    p2 =1;
    %construct big parenthesus of Tmig
    p1 = 1; 
    
    if (nj >=2)  %matlab starts from 1 not from 0
        for i = 1:nj 
           for h =2:i
               p1 = p1*(D/R(h-1))*(D/R(h));
           end
           p2 = p2+p1; 
        end
    end
  
   
    Tmig = (mu*Vmem / R(1) ) * p2;    
    return 
end