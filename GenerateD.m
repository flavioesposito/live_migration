%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Flavio Esposito   Nov 10 2014
% function to construct page dirtying rate D 
% single VM to be transferred
%
% IN
% dim          : dimension of vector D
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
function D = GenerateD(dim,distribution,avg,var,q)


    switch distribution
        case {'constant','Constant','CONSTANT','C','c'} 
            D = avg*ones(1,dim); %1 GB = 1000 MB
            disp('Generated vector of constant D')

        case {'uniform','Uniform', 'UNIFORM','U','u'}
            for j = 1:dim
                D(j) = avg*rand(1); %1 GB = 1000 MB
            end
            disp('Generated vector of D with size Uniformely distributed')

        case {'normal','Normal','NORMAL','n','N'}
            for j = 1:dim
                D(j) = normrnd(avg,var);
            end
            
            disp('D size generated with normal distribution')
        case {'bimodal','Bimodal','BIMODAL','B','b'}
            for j=1:dim
                if(j < q*dim ) % small
                    D(j) = normrnd(avg,var);
                else % large 
                    D(j) = normrnd(mu*avg,var); 
                end
            end
            disp('Generated vector of VMs with bimodal distribution')
            
        otherwise
            D = 1000*ones(1,M); %1 GB = 1000 MB
            warning('Unsupported distribution type. Generated VMs of constant size');
    end %switch

   
    
    

    
return
end