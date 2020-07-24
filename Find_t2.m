function [t2] = Find_t2(a, c, r1, r2, t1)

% GOAL: Calculate second joint angle based on end-effector position of the
% second link (c)

% INPUTS:
%   a: [1 x 2] -> origin of manipulator (result from Sketch)
%   c: [1 x 2] -> cartesian position of the end of the second link 
%   r1: float -> first link length
%   r2: float -> second link length
%   t1: float -> first joint angle

% OUTPUTS:
%   t2: float -> second joint angle

ct1 = cos(t1);
st1 = sin(t1);

ct2 = (((c(1) - a(1))*ct1 + (c(2) - a(2))*st1) - r1)/r2;
st2 = -(((c(1) - a(1))*st1 - (c(2) - a(2))*ct1))/r2;
t2 = wrapTo2Pi(atan2(st2,ct2));

end