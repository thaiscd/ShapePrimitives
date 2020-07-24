function [SV, tang] = OverSVarc(dir, pa1, pa2, ca, a, r1)

ra = sqrt((pa1(1) - ca(1))^2 + (pa1(2) - ca(2))^2); 
        % find padown and patop
        
daca = sqrt((a(1) - ca(1))^2 + (a(2) - ca(2))^2);
patop = [ca(1) - (a(1) - ca(1))*ra/daca, ca(2) - (a(2) - ca(2))*ra/daca];
padown = [ca(1) + (a(1) - ca(1))*ra/daca, ca(2) + (a(2) - ca(2))*ra/daca];

% check if on arc
bool1 = PointsOnArc(dir, pa1, pa2, ca, patop);
bool2 = PointsOnArc(dir, pa1, pa2, ca, padown);
points = [pa1; pa2; a];
tang = [];
if bool1 == 1 % patop on arc
    distptopc = sqrt((patop(1)-a(1))^2 + (patop(2)-a(2))^2);
    points = [points; patop];
    if distptopc > r1
        [t1, t2] = FindTang(patop, a, r1);
        points = [points; t1; t2];
        tang = [patop, t1; patop, t2];
    end
end

if bool2 == 1 % patop on arc
    distpdownc = sqrt((padown(1)-a(1))^2 + (padown(2)-a(2))^2);
    points = [points; padown];
    if distpdownc > r1
        [t1, t2] = FindTang(padown, a, r1);
        points = [points; t1; t2];
        tang = [tang; padown, t1; padown, t2];
    end
end

distpa1c = sqrt((pa1(1)-a(1))^2 + (pa1(2)-a(2))^2);
distpa2c = sqrt((pa2(1)-a(1))^2 + (pa2(2)-a(2))^2);
if distpa1c > r1
    [t1, t2] = FindTang(pa1, a, r1);
    points = [points; t1; t2];
    tang = [tang; pa1, t1; pa1, t2];
end
if distpa2c > r1
    [t1, t2] = FindTang(pa2, a, r1);
    points = [points; t1; t2];
    tang = [tang; pa2, t1; pa2, t2];
end

[x, y] = sortPoints(points(:,1), points(:,2));
p = [x, y];
k = unique(convhull(p));
SV = [p(k,1),p(k,2)];

end