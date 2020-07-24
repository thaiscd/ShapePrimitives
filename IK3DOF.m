function [joint1, joint2] = IK3DOF(a0, b0, r1, r2, r3, x, y)

ct1 = (b0(1) - a0(1))/r1;
st1 = (b0(2) - a0(2))/r1;
t1 = wrapTo2Pi(atan2(st1,ct1));

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

joint1 = [t1, t2a, t3a];
joint2 = [t1, t2b, t3b];


end