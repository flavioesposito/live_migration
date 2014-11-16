%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Flavio Esposito   Oct 15 2014
% function to build constraint of VM migration problem
%
% IN:
% nj   : number of page rounds
% RMAX : maximum value of data Rate to be split among rounds
% R(I) : geometric programming variable gpvar
% D    : memory dirtying rate
% I    : max no. of rounds
%
% OUT
% constr : built constraints 
%
function constr = buildConstraints(M,RMAX,R,D)
 
    % Constant 
    epsilon = 0.0000000000000001; 
    
    %%%%%%%%%%%% CONSTRAINTS %%%%%%%%%  
    %%%%%%%%%%%%  Rj <= R %%%%%%%%%  \forall i
    c1 =    R(1)<= RMAX  ;
  
    for j =2:M
            c1 = [c1; R(j)<= RMAX];
    end
   
    % 
    %%%%%%%%%%%%  Di-1,j <= Rj %%%%%%%%%  \forall i
    c2 = D <= R(1);
   
        for j =2:M
            c2 = [c2; D <= R(j)];
        end
%     
%     c3 = epsilon <= R(1);
%    
%         for j =1:M
%             c3 = [c3; epsilon <= R(j)];
%         end
    
     %%%%%%%%%%%%  sum_j Rj <= R %%%%%%%%%  
    q = posynomial;
    
    for j =1:M
        q = q + R(j);
    end
    c4 = q <= RMAX;


    %constr = [c1;c2;c3;c4];
    constr = [c1;c2;c4];
    return; 
end