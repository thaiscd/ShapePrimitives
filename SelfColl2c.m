function [con] = SelfColl2c(c, r, o, a)
% Goal -> constraint to guarantee that first link of a 3DOF is at certain
% minimum distance (thickness of link + 0.05) of circle shape
% primitive

% INPUTS:

% c: vector (1 x 2)- coordinates of center of circle
% r: real number- radius of circle
% o: vector (1 x 2)- coordinates of origin of manipulator
% a: vector (1 x 2)- coordinates of end first link

% OUTPUTS:

% con: vector -> c <= 0 constraint

mindist = 0.05;
dist = dist_line_point(o, a, c);

con = r + mindist - dist;

end