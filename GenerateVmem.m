%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Flavio Esposito   Nov 1 2014
% function to construct vector of VM size to be migrated
% single VM to be transferred
%
% IN
% M            : nubmer of VMs to be transferred
% mu           : muliplicative factor for definiing the VM size
% distribution : VM size distribution
%                constant => produces vector with identicaly VM size
%                uniform  => produces vector with size uniform distri
%                            with mean avg and variance var
%                bimodal =>  produces vector with VM os size Vmem0 
%                            for a fraction q, and mu*Vmem0 for remaining 1-q
% avg          : mean of the distribution
% var          : variance of the distribution
% q            : in a bimodal, fraction of VMs with small memory size 
%                (1-q) with large 

% OUT
% Vmem : vector 1 x M of sizes of the VMs to be migrated
%
function Vmem = GenerateVmem(M,mu,distribution,avg,var,q)


    switch distribution
        case {'constant','Constant','CONSTANT','C','c'} 
            Vmem = avg*ones(1,M); %1 GB = 1000 MB
            disp('Generated vector of constant VMs')

        case {'uniform','Uniform', 'UNIFORM','U','u'}
            for j = 1:M
                Vmem(j) = avg*rand(1); %1 GB = 1000 MB
            end
            disp('Generated vector of VMs with size Uniformely distributed')

        case {'normal','Normal','NORMAL','n','N'}
            for j = 1:M
                Vmem(j) = normrnd(avg,var);
            end
            
            disp('VM size generated with normal distribution')
        case {'bimodal','Bimodal','BIMODAL','B','b'}
            for j=1:M
                if(j < q*M ) % small
                    Vmem(j) = normrnd(avg,var);
                else % large 
                    Vmem(j) = normrnd(mu*avg,var); 
                end
            end
            disp('Generated vector of VMs with bimodal distribution')
            
        otherwise
            %Vmem = 1000*ones(1,M); %1 GB = 1000 MB
            %warning('Unsupported distribution type. Generated VMs of constant size');
            error('Unsupported distribution type. choose between c, u, n or b');
    end %switch

   
    
    

    
return
end