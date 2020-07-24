function [joint1, joint2] = IK(r1, r2, x, y, a)

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

joint1 = [t1a, t2a];
joint2 = [t1b, t2b];


end