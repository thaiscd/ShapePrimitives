function [bool] = VerifySV2DOF(o, r1, r2, theta, Obs)

% bool = 1 if there is a collision while executing MP

[n, ~] = size(theta);
S1 = o;
S2 = [];

for i = 1:n
    P = FK([r1 r2], theta(i,:), o);
    S1 = [S1; P(2,:)];
    S2 = [S2; P(2:3,:)];
end

[x, y] = sortPoints(S1(:,1), S1(:,2));
p = [x, y];
k = unique(convhull(p));
p1 = [p(k,1),p(k,2)];
[n1,~] = size(p1);

[x, y] = sortPoints(S2(:,1), S2(:,2));
p = [x, y];
k = unique(convhull(p));
p2 = [p(k,1),p(k,2)];
[n2,~] = size(p2);

[nobs, ~] = size(Obs);
bool = 0;

for j = 1:nobs
    xo = Obs(j,1);
    yo = Obs(j,2);
    ro = Obs(j,3);
    
    for i1 = 1:n1
        if i1 ~= n1
            q = dist_line_point(p1(i1,:), p1(i1+1,:), [xo, yo]);
        else
            q = dist_line_point(p1(1,:), p1(i1,:), [xo, yo]);
        end
        if q < ro
            bool = 1;
        end
    end
    
    for i2 = 1:n2
        if i2 ~= n2
            q = dist_line_point(p2(i2,:), p2(i2+1,:), [xo, yo]);
        else
            q = dist_line_point(p2(1,:), p2(i2,:), [xo, yo]);
        end
        if q < ro
            bool = 1;
        end
    end
        
end
    
end