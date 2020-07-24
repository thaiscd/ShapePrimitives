function [c] = SelfColl2l(pl1, pl2, o, a)
% Goal -> constraint to guarantee that first link of a 3DOF is at certain
% minimum distance (thickness of link + 0.05) of line segment shape
% primitive

% INPUTS:

% pl1: vector (1 x 2)- coordinates of first point defining line segment
% pl2: vector (1 x 2)- coordinates of second point defining line segment
% o: vector (1 x 2)- coordinates of origin of manipulator
% a: vector (1 x 2)- coordinates of end first link

% OUTPUTS:

% c: real number -> c <= 0 constraint

mindist = 0.05;
dist = dist_line_line2D(pl1, pl2, o, a);
c = mindist - dist;

end