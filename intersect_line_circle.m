function [u1, u2] = intersect_line_circle(p1, p2, c, r)
% Goal -> calculate point(s) of intersection of line segment and circle

% INPUTS:

% p1: vector (1x2) -> initial point on the line segment
% p2: vector (1x2) -> final point on the line segment
% c: vector (1x2) -> center of circle
% r: real number -> radius of circle

% OUTPUTS:

% u1, u2: vector(1x2) -> points of intersection

err = .001;

A = (p1(1) - p2(1))^2 + (p1(2) - p2(2))^2;
B = 2*dotproduct(c, p1, p1, p2);
C = (p1(1) - c(1))^2 + (p1(2) - c(2))^2 - r^2;

t1 = (-B + sqrt(B^2 - 4*A*C))/(2*A);
t2 = (-B - sqrt(B^2 - 4*A*C))/(2*A);

if B^2 - 4*A*C >= 0

    u1 = p1 + (p2 - p1)*t2;
    u2 = p1 + (p2 - p1)*t1;

else
    u1 = [];
    u2 = [];
end
end