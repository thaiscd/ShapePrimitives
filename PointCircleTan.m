function [tg] = PointCircleTan(p, c, r)

a = c(1);
b = c(2);
xp = p(1);
yp = p(2);
tg = [];

x1 = ((xp - a)*r^2 + r*(yp - b)*sqrt((xp - a)^2 + (yp - b)^2 - r^2))/((xp - a)^2 + (yp - b)^2) + a;
x2 = ((xp - a)*r^2 - r*(yp - b)*sqrt((xp - a)^2 + (yp - b)^2 - r^2))/((xp - a)^2 + (yp - b)^2) + a;
y1 = ((yp - b)*r^2 - r*(xp - a)*sqrt((xp - a)^2 + (yp - b)^2 - r^2))/((xp - a)^2 + (yp - b)^2) + b;
y2 = ((yp - b)*r^2 + r*(xp - a)*sqrt((xp - a)^2 + (yp - b)^2 - r^2))/((xp - a)^2 + (yp - b)^2) + b;

tg = [x1, y1; x2, y2];

end