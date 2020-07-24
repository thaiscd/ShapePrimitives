function bool = intersect2lines(u1,u2,v1,v2)
% Goal -> check if 2 line segments intersect

% INPUTS:

% v1: vector (1x2) -> initial point on the first vector
% v2: vector (1x2) -> final point on the first vector
% u1: vector (1x2) -> initial point on the second vector
% u2: vector (1x2) -> final point on the second vector

% OUTPUTS:

% bool: boolean -> 0 if they don't intersect and 1 if they do

v = v2 - v1;
u = u2 - u1;
k = u1 - v1;
p = (v(1)*k(2) - v(2)*k(1))/(u(1)*v(2) - u(2)*v(1));
t = (k(1) + u(1)*p)/v(1);

bool = 0;

if t > 0 && t < 1 && p > 0 && p < 1
    bool = 1;
end
end