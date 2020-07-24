function [SV, tangs] = OverSVline(pl1, pl2, o, r1)

% find tangent from pl1 to circle center o and radius r1
distpl1c = sqrt((pl1(1)-o(1))^2 + (pl1(2)-o(2))^2);
distpl2c = sqrt((pl2(1)-o(1))^2 + (pl2(2)-o(2))^2);

polygon = [o; pl1; pl2];
tangs = [];
if distpl1c > r1
    [t11, t21] = FindTang(pl1, o, r1);
    polygon = [polygon; t11; t21];
    tangs = [pl1 t11; pl1 t21];
end
if distpl2c > r1
    [t12, t22] = FindTang(pl2, o, r1);
    polygon = [polygon; t12; t22];
    tangs = [pl2 t12; pl2 t22];
end

[x, y] = sortPoints(polygon(:,1), polygon(:,2));
p = [x, y];
k = unique(convhull(p));
SV = [p(k,1),p(k,2)];

end