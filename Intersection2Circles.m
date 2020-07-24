function [pnts] = Intersection2Circles(c1, r1, c2, r2)
% Goal -> calculate point(s) of intersection between 2 circles

% INPUTS:

% c1: vector (1x2) -> center of circle
% r1: real number -> radius of circle
% c2: vector (1x2) -> center of circle
% r2: real number -> radius of circle

% OUTPUTS:

% pnts: vector(2x2) -> points of intersection

dc1c2 = sqrt((c1(1) - c2(1))^2 + (c1(2) - c2(2))^2);
r1dc1c2cb = (r1^2 + dc1c2^2 - r2^2)/2;
A = r1dc1c2cb/(c2(1) - c1(1));
B = -(c2(2) - c1(2))/(c2(1) - c1(1));
a = 1 + B^2;
b = 2*A*B - 2*c1(1)*B;
c = A^2 + c1(1)^2 -2*A*c1(1) + c1(2)^2 - r1^2;
y1 = (-b + sqrt(b^2 - 4*a*c))/(2*a);
y2 = (-b - sqrt(b^2 - 4*a*c))/(2*a);
x1 = A + B*y1;
x2 = A + B*y2;
pi1 = [real(x1 + c1(1)), real(y1 + c1(2))];
pi2 = [real(x2 + c1(1)), real(y2 + c1(2))];

pnts = [pi1;pi2];

end
