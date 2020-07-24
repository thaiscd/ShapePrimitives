function [con] = SelfColl2a(c, r, pa1, pa2, ang, o, a)
% Goal -> constraint to guarantee that first link of a 3DOF is at certain
% minimum distance (thickness of link + 0.05) of arc shape
% primitive

% INPUTS:

% c: vector (1 x 2)- coordinates of center of circle defining arc
% r: real number- radius of circle defining arc
% pa1: vector (1 x 2)- coordinates of initial point on arc
% pa2: vector (1 x 2)- coordinates of end point on arc
% ang: real number- angle of arc
% o: vector (1 x 2)- coordinates of origin of manipulator
% a: vector (1 x 2)- coordinates of end first link

% OUTPUTS:

% con: vector -> c <= 0 constraint

mindist = 0.05;

if ang > pi
    dist = dist_line_point(o, a, c);
    con = r + mindist - dist;
else
    p = (pa1 + pa2)/2;
    dist = r - sqrt((p(1)-c(1))^2 + (p(2)-c(2))^2);
    con = mindist - dist;
end

end