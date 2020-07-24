function [x0] = initguess4mps(MPs, nL, maxlength, Obs, nitermax, OC)

% Goal -> find a initial guess based on discretization

% INPUTS:

% MPS: matrix (# of shape primitives x 8)- shape primitives
% nL: integer (2 or 3)- number of links in the solution
% maxlength - real number- maximum link length allowed
% Obs: matrix (# of obstacles x 3)- (x_center, y_center, radius)
% nitermax: integer- # maximum of iterations to try to find a design for 
% each # of possible dofs
% OC: matrix (# of rectangles x 4)- (xmin, ymin, xmax, ymax) - it defines
% the constraints on the origin of manipulator

% OUTPUTS:

% x0: vector (# of variables)- initial guess for each variable

n = 2; % discretize each shape primitive
Points = GetPoints(MPs, n); 

bool = 0;
i = 0;

while bool == 0 && i < 2
    i = i + 1;
    [bool, x] = CalculateDesign2d(nL, maxlength, Points, Obs, nitermax, OC, n);
end

x0 = Getx0(x, n, MPs, nL);

end