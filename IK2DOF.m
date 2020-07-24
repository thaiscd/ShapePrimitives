function [p1, p2] = IK2DOF(c, pl, r1, r2)

A = (r2^2 - r1^2 - ((pl(1)^2 - c(1)^2) + (pl(2)^2 - c(2)^2)))/(2*(c(1) - pl(1)));
B = (pl(2) - c(2))/(c(1) - pl(1));

a = B^2 + 1;
b = 2*A*B - 2*B*pl(1) - 2*pl(2);
c = pl(1)^2 + A^2 - 2*A*pl(1) + pl(2)^2 - r2^2;

y1 = (-b + sqrt(b^2 - 4*a*c))/(2*a);
x1 = A + B*y1;

y2 = (-b - sqrt(b^2 - 4*a*c))/(2*a);
x2 = A + B*y2;

p1 = [x1, y1];
p2 = [x2, y2];

end