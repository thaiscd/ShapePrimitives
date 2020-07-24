function [bool, a, r1, r2, bl1, bl2, bc, ba1, ba2] = try2DOFoverSV(nitermax, MPs, Obs, OC, maxlength)

% Goal -> try to find a 2DOF design

% INPUTS:

% nitermax: integer- # maximum of iterations to try to find a design for 
% each # of possible dofs
% MPS: matrix (# of shape primitives x 8)- shape primitives
% Obs: matrix (# of obstacles x 3)- (x_center, y_center, radius)
% OC: matrix (# of rectangles x 4)- (xmin, ymin, xmax, ymax) - it defines
% the constraints on the origin of manipulator
% maxlength - real number- maximum link length allowed

% OUTPUTS:

% bool: boolean- 1 if found a design and 0 if it didn't
% a: vector (1x2)- coordinates of origin of manipulator
% r1: real number- first link length 
% r2: real number- second link length 
% bl1: matrix (# of line shape primitives x 2): positions of elbow for the 
% initial point that define a line segment shape primitive
% bl2: matrix (# of line shape primitives x 2): positions of elbow for the 
% final point that define a line segment shape primitive
% bc: matrix (# of circle shape primitives x 2): positions of elbow for the 
% initial and final point that define a line segment shape primitive
% ba1: matrix (# of arc shape primitives x 2): positions of elbow for the 
% initial point that define an arc shape primitive
% ba2: matrix (# of arc shape primitives x 2): positions of elbow for the 
% final point that define an arc segment shape primitive

% initializing variables
a = 0;
r1 = 0;
r2 = 0;

bl1 = 0;
bl2 = 0;
bc = 0;

ba1 = 0;
ba2 = 0;

nL = 2;

[nMPs, ~] = size(MPs);
x0 = initguess4mps(MPs, nL, maxlength, Obs, nitermax, OC); % find a initrial guess
[nv,~] = size(x0);
lb = zeros(nv,1); % upper and lower bounds on the variables
ub = zeros(nv,1);
lb(:) = -1;
ub(:) = 1;
lb(3) = 0.1;
lb(4) = 0.1;
ub(3) = maxlength;
ub(4) = maxlength;
lb(1) = OC(1);
lb(2) = OC(3);
ub(1) = OC(2);
ub(2) = OC(4);

options = optimoptions('fmincon','MaxFunctionEvaluations',5.000000e+04,'Algorithm','sqp','ConstraintTolerance',1e-3);

nonlcon = @(x) constraints2DOFoverSV(x, MPs, Obs, OC);
fun = @(x) minL(x, nL, nMPs); % minimize link lengths
bool = 0;
indx = 0;
viol = 5e-2;

while bool ~= 1 && indx <= nitermax
    indx = indx + 1;
    try
        [x, ~, ~, ~] = fmincon(fun,x0,[],[],[],[],lb,ub,nonlcon,options);
        [c,ceq] = constraints2DOFoverSV(x, MPs, Obs, OC);

        if all(c <= viol) && all(abs(ceq) < viol)
            bool = 1;
            a = x(1:2)';
            r1 = x(3);
            r2 = x(4);
            y = x(5:end);

            bl1 = [];
            bl2 = [];
            bc = [];
            ba1 = [];
            ba2 = [];

            for i = 1:nMPs
                if MPs(i,1) == 1
                    bl1p = y(4*i-3:4*i-2)';
                    bl2p = y(4*i-1:4*i)';
                    bl1 = [bl1; bl1p];
                    bl2 = [bl2; bl2p];
                elseif MPs(i,1) == 0
                    bcp = y(4*i-3:4*i-2)';
                    bc = [bc; bcp];
                else
                    ba1p = y(4*i-3:4*i-2)';
                    ba2p = y(4*i-1:4*i)';
                    ba1 = [ba1; ba1p];
                    ba2 = [ba2; ba2p];
                end
            end
        else
            fun = @(x) minL(x, nL, nMPs);
            nonlcon = @(x) constraints2DOFoverSV(x, MPs, Obs, OC);
            x0 = initguess4mps(MPs, nL, maxlength, Obs, nitermax, OC);
        end
    catch
        
    end
    
end

end