function [SV,t1,t2] = OverSVcirce(c1, r1, c2, r2)

polygon = [];
[t1, t2] = Tang2circles(c1, r1, c2, r2);
polygon = real([t1; t2]);

[x, y] = sortPoints(polygon(:,1), polygon(:,2));
p = [x, y];
p1 = unique(p, 'rows');
[n,~]=size(p1);
if n <= 2
    SV = [];
    t1 = [];
    t2 = [];
else
    k = unique(convhull(p));
    SV = [p(k,1),p(k,2)];
end

end