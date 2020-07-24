function [t1] = Find_t1(a, b, r1)

% GOAL: Calculate firt joint angle based on end-effector position of the
% first link (b)

% INPUTS:
%   a: [1 x 2] -> origin of manipulator (result from Sketch)
%   b: [1 x 2] -> cartesian position of the end of the first link 
%   r1: float -> first link length

% OUTPUTS:
%   t1: float -> first joint angle

ct1 = (b(1) - a(1))/r1;
st1 = (b(2) - a(2))/r1;
t1 = wrapTo2Pi(atan2(st1,ct1));

end