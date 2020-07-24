function [t1, t2] = Find_t1t2(r1, r2, r3, x, y, a, t1prev, t2prev, b)

% GOAL: Calculate firt and second joint angles based on end-effector
% position and previous joint angles (smoothness of trajectory)

% INPUTS:

% r1: real number- first link length 
% r2: real number- second link length 
% r3: real number- third link length 
% x, y: real numbers- coordinates of end-effector
% a: vector (1 x 2)- coordinates of origin
% t1prev: real number: previous first joint angle
% t2prev: real number: previous second joint angle

% OUTPUTS:

%   t1: real number- first joint angle
%   t2: real number- second joint angle

ct2 = ((x - a(1))^2 + (y - a(2))^2 - r1^2 - r2^2)/(2*r1*r2);
st2a = real(sqrt(1 - ct2^2));
st2b = -real(sqrt(1 - ct2^2));

ct1a = ((y - a(2))*r2*st2a + (x - a(1))*(r1 + r2*ct2))/((x - a(1))^2 + (y - a(2))^2);
st1a = (r1 + r2*ct2 - (x - a(1))*ct1a)/(y - a(2));

ct1b = ((y - a(2))*r2*st2b + (x - a(1))*(r1 + r2*ct2))/((x - a(1))^2 + (y - a(2))^2);
st1b = (r1 + r2*ct2 - (x - a(1))*ct1b)/(y - a(2));

t2a = wrapTo2Pi(atan2(st2a, ct2));
t2b = wrapTo2Pi(atan2(st2b, ct2));

t1a = wrapTo2Pi(atan2(st1a, ct1a));
t1b = wrapTo2Pi(atan2(st1b, ct1b));

if abs(sin(t2prev) - st2a) + abs(sin(t1prev) - st1a) + abs(cos(t1prev) - ct1a) > abs(sin(t2prev) - st2b) + abs(sin(t1prev) - st1b) + abs(cos(t1prev) - ct1b)
    t2 = t2b;
    t1 = t1b;
else
    t2 = t2a;
    t1 = t1a;
end

end