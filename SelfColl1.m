function [c] = SelfColl1(r1, r2, a, b, p)
% Goal -> check if 2 external links collide

% INPUTS:

% r1: real number - first link length
% r2: real number - second link length
% a: vector (1 x 2)- coordinates of origin of manipulator
% b: vector (1 x 2)- coordinates of end first link
% p: vector (1 x 2)- coordinates of end-effector

% OUTPUTS:

% c: real number -> c <= 0 constraint

mindist = 0.04; % 2*thickness of link +0.01

if r2 < r1
    dist = dist_line_point(a, b, p);
elseif r1 < r2
    dist = dist_line_point(b, p, a);
elseif r1 == r2
    dist = sqrt((a(1)-p(1))^2 + (a(2)-p(2))^2);
end

c = mindist - dist;

end