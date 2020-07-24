function [t1, t2] = FindTang(p, c, r)

% goal : fins tangents to circle from point outside circle

A = (r^2 - c(1)*(c(1) - p(1)) - c(2)*(c(2) - p(2)))/(p(1) - c(1));
B = (c(2) - p(2))/(p(1) - c(1));

a = 1 + B^2;
b = 2*A*B - 2*B*c(1) - 2*c(2);
d = A^2 + c(1)^2 -2*A*c(1) + c(2)^2 - r^2;

y1 = (-b + sqrt(b^2 - 4*a*d))/(2*a);
x1 = A + B*y1;

y2 = (-b - sqrt(b^2 - 4*a*d))/(2*a);
x2 = A + B*y2;

t1 = [x1, y1];
t2 = [x2, y2];

end