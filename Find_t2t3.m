function [t2, t3] = Find_t2t3(r1, r2, r3, x, y, a0, t1, t2prev, t3prev)

% GOAL: Calculate second and third joints angle based on end-effector position 

% INPUTS:

%   r1: float -> first link length
%   r2: float -> second link length
%   r3: float -> third link length
%   x,y: floats -> coordinates of end-effector
%   a0: [1 x 2] -> origin of manipulator (result from Sketch)
%   t1: float -> first joint angle
%   t2prev: float -> second previous joint angle
%   t3prev: float -> third previous joint angle

% OUTPUTS:
%   t2: float -> second joint angle
%   t3: float -> third joint angle

A = (x - a0(1))*cos(t1) + (y - a0(2))*sin(t1) - r1;
B = (y - a0(2))*cos(t1) - (x - a0(1))*sin(t1);
C = (A^2 + B^2 + r2^2 - r3^2)/(2*r2);
a = A^2 + B^2;
b = -2*A*C;
c = C^2 - B^2;
ct2a = real((-b + sqrt(b^2 - 4*a*c))/(2*a));
st2a = real((C - A*ct2a)/B);
ct2b = real((-b - sqrt(b^2 - 4*a*c))/(2*a));
st2b = real((C - A*ct2b)/B);
t2a = wrapTo2Pi(atan2(st2a, ct2a));
t2b = wrapTo2Pi(atan2(st2b, ct2b));

aux1 = (x - a0(1))*cos(t1) + (y - a0(2))*sin(t1);
aux2 = B;
aux3 = aux1*ct2a + aux2*st2a;
aux4 = aux2*ct2a - aux1*st2a;
ct3a = (aux3 - r2 - r1*ct2a)/r3;
st3a = (aux4 + r1*st2a)/r3;
t3a = wrapTo2Pi(atan2(st3a, ct3a));
aux3 = aux1*ct2b + aux2*st2b;
aux4 = aux2*ct2b - aux1*st2b;
ct3b = (aux3 - r2 - r1*ct2b)/r3;
st3b = (aux4 + r1*st2b)/r3;
t3b = wrapTo2Pi(atan2(st3b, ct3b));

if abs(sin(t2prev) - st2a) + abs(cos(t2prev) - ct2a) + abs(sin(t3prev) - st3a) + abs(cos(t3prev) - ct3a) > abs(sin(t2prev) - st2b) + abs(cos(t2prev) - ct2b) + abs(sin(t3prev) - st3b) + abs(cos(t3prev) - ct3b)
    t2 = t2b;
    t3 = t3b;
else
    t2 = t2a;
    t3 = t3a;
end

end