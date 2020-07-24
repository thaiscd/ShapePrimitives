function [F] = InitialGuessOpt2d(x, nL, Points, Obs, OC, n)
% Goal -> find a initial guess based on discretization and minimization of
% function equal to sum of constraints

% INPUTS:

% x: vector (# of variables)- initial guess for each variable
% nL: integer (2 or 3)- number of links in the solution
% Points: matrix ((# of shape primitive)*n) x 2- coordinates of points
% Obs: matrix (# of obstacles x 3)- (x_center, y_center, radius)
% nitermax: integer- # maximum of iterations to try to find a design for 
% each # of possible dofs
% OC: matrix (# of rectangles x 4)- (xmin, ymin, xmax, ymax) - it defines
% the constraints on the origin of manipulator
% n: integer - number of discretized points in each shape primitive

% OUTPUTS:

% F: function to be minimized

[c,ceq] = constraints2d(x, nL, Points, Obs, OC, n);

F = sum(ceq) + sum(abs(c));

end
