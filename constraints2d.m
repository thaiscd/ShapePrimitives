function [c,ceq] = constraints2d(x, nL, Points, Obs, OC, n)

% Goal -> constraints to find a design able to reach a set of points on 2d

% INPUTS:

% x: vector with the variables
% nL: integer (2 or 3)- number of links in the solution
% Points: matrix ((# of shape primitive)*n) x 2- coordinates of points
% Obs: matrix (# of obstacles x 3)- (x_center, y_center, radius)
% nitermax: integer- # maximum of iterations to try to find a design for 
% each # of possible dofs
% OC: matrix (# of rectangles x 4)- (xmin, ymin, xmax, ymax) - it defines
% the constraints on the origin of manipulator
% n: integer - number of discretized points in each shape primitive

% OUTPUTS:

% c: vector -> c <= 0 constraints
% ceq: vector -> ceq == 0 constraints

c = [];
ceq = [];

r = x(1 : nL);
o = x(nL+1 : nL+2);
y = x(nL+3 : end);

% constraints on origin
if ~isempty(OC)
    [nOC, ~] = size(OC);
    F = zeros(nOC,1);
    for i = 1:nOC
        F(i) = max([(o(1) - OC(i,2)),(o(2) - OC(i,4)),(OC(i,1) - o(1)),(OC(i,3) - o(2))]);
    end
    c = min(F);
end

[np, ~] = size(Points);

pose = [];

for i = 1:np
    init = (i-1)*2*nL+1;
    fin = i*2*nL;
    trans = y(init:fin);
    m = o';
    for j = 1:2:2*nL
        m = [m; trans(j:j+1)'];
    end
    pose{i} = m;
end


for i = 1:np

    % link length constraints
    [ceqll] = LinkLengthconstraint2d(pose{i}, r);
    ceq = [ceq; ceqll];


    if ~isempty(Obs)
%     % collision avoidance constraints
        [cca] = CollAvoiconstraint2d(pose{i}, Obs);
        c = [c; cca];
    end

% reachability constraints
    [ceqef] = EFreach(pose{i}, Points(i,:));
    ceq = [ceq; ceqef];

end

% % % elbow constraints
for i = 1:np-1
    config1 = pose{i};
    config2 = pose{i+1};
    cel = ElbowConstraints(config1, config2);
    c = [c; cel];
end

nmp = int16(np/n);
% fixed first link length constraints for a 3 link arm
for i = 1:nmp
    p = y((i-1)*n*(2*nL)+1:i*n*(2*nL));
    [ceqor] = originConstraints(p, n, nL);
    ceq = [ceq;ceqor];
end


end
