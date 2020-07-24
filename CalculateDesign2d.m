function [bool, x] = CalculateDesign2d(nL, maxlength, Points, Obs, nitermax, OC, n)

% Goal -> find a initial guess based on discretization

% INPUTS:

% nL: integer (2 or 3)- number of links in the solution
% maxlength: real number- maximum link length allowed
% Points: matrix ((# of shape primitive)*n) x 2- coordinates of points
% Obs: matrix (# of obstacles x 3)- (x_center, y_center, radius)
% nitermax: integer- # maximum of iterations to try to find a design for 
% each # of possible dofs
% OC: matrix (# of rectangles x 4)- (xmin, ymin, xmax, ymax) - it defines
% the constraints on the origin of manipulator
% n: integer - number of discretized points in each shape primitive

% OUTPUTS:

% bool: boolean- 1 if a design was fornd and 0 if it wasn't
% x: vector (# of variables)- initial guess for each variable

x0 = GenerateInitialGuess2d(nL, maxlength, Points, Obs, OC, n);
x = x0;
bool = 1;
[nv,~] = size(x0);
lb = zeros(nv,1);
ub = zeros(nv,1);
lb(:) = -1;
ub(:) = 1;
lb(1:nL) = .1;
ub(1:nL) = maxlength;
lb(nL+1) = -1;
lb(nL+2) = -1;
ub(nL+1) = 1;
ub(nL+2) = 1;

lb(nL+1) = OC(1);
lb(nL+2) = OC(3);
ub(nL+1) = OC(2);
ub(nL+2) = OC(4);

options = optimoptions('fmincon','MaxFunctionEvaluations',5.000000e+04,'Algorithm','sqp','ConstraintTolerance',1e-3);

nonlcon = @(x) constraints2d(x, nL, Points, Obs, OC, n);
fun = @(x) MinPose(x, nL);
bool = 0;
indx = 0;

viol = 1e-1;

while bool ~= 1 && indx <= nitermax

    [x, ~, ~, ~] = fmincon(fun,x0,[],[],[],[],lb,ub,nonlcon,options);

    [c,ceq] = constraints2d(x, nL, Points, Obs, OC, n);

    if all(c<viol) && all(abs(ceq)<viol) 
        bool=1;

    else
        x0 = GenerateInitialGuess2d(nL, maxlength, Points, Obs, OC, n);
        indx = indx +1;
    end

end

end
