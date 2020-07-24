function [ceq] = originConstraints(p, n, nL)

% Goal -> constraints so the first link is fixed to reach all points on the
% shape primitive

% INPUTS:

% p: vector ((nL + 1) x 2)- coordinates of pose of arm
% n: integer- number of points discretized on the shape primitive
% nL: integer- number of links

% OUTPUTS:

% ceq: vector -> c == 0 constraints

p_x = zeros(n,1);
p_y = zeros(n,1);
dist = 0;
for i = 1:n
    p_x(i) = p((i-1)*2*nL+1);
    p_y(i) = p((i-1)*2*nL+2);
    if i > 1
        dist = dist + (p_x(i-1)-p_x(i))^2 + (p_y(i-1)-p_y(i))^2;
    end
end
ceq = dist;
end