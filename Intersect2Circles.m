function [tg] = Intersect2Circles(c1, r0, c2, r1)

a = c1(1);
b = c1(2);
c = c2(1);
d = c2(2);

D = sqrt((c - a)^2 + (d - b)^2);
if D < r0 + r1 && D > abs(r0 - r1)
    m = 0.25*sqrt((D + r0 + r1)*(D + r0 - r1)*(D - r0 + r1)*(-D + r0 + r1));
    x1 = (a + c)/2 + (c - a)*(r0^2 - r1^2)/(2*D^2) + 2*(b - d)*m/D^2;
    x2 = (a + c)/2 + (c - a)*(r0^2 - r1^2)/(2*D^2) - 2*(b - d)*m/D^2;
    y1 = (b + d)/2 + (d - b)*(r0^2 - r1^2)/(2*D^2) - 2*(a - c)*m/D^2;
    y2 = (b + d)/2 + (d - b)*(r0^2 - r1^2)/(2*D^2) + 2*(a - c)*m/D^2;
    tg = [x1, y1; x2, y2];
else
    tg = [];
end

end