function [x] = GenerateInitialGuess2d(nL, maxlength, Points, Obs, OC, n)

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

[np, ~] = size(Points);

x0 = [maxlength*rand(nL,1); 2*rand(2,1)-1; 2*rand(2*nL*np,1)-1]; % random initial guess

[nv,~] = size(x0);
lb = zeros(nv,1);
ub = zeros(nv,1);
lb(:) = -1;
ub(:) = 1;
lb(1:nL) = 0.1;
ub(1:nL) = maxlength;
lb(nL+1) = OC(1);
lb(nL+2) = OC(3);
ub(nL+1) = OC(2);
ub(nL+2) = OC(4);

fun = @(x) InitialGuessOpt2d(x, nL, Points, Obs, OC, n); % find initial guess 

options = optimoptions('fmincon','MaxFunctionEvaluations',5.000000e+03,'Algorithm','sqp','ConstraintTolerance',1e-1);

[x,~] = fmincon(fun,x0,[],[],[],[],lb,ub,[],options);

end
