function [p] = Intersect2InfLines(a1, b1, a2, b2)

x = (b2 - b1)/(a1 - a2);
y = a1*x + b1;
p = [x y];

end