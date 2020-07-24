function [c] = CollAvoiconstraint(pose, Obs)
% Goal -> apply collision avoidance constraints on each pose (for
% discretization process)

% INPUTS:

% pose: matrix ((nL + 1) x 2): coordinates of each module's center and
% end-efector
% Obs: matrix (# of obstacles x 3)- (x_center, y_center, radius)

% OUTPUTS:

% c: vector -> c <= 0 constraints
[nl, ~] = size(pose);
[nobs, ~] = size(Obs);
c = [];

for i = 1:nl - 1
    p1 = pose(i,:);
    p2 = pose(i+1,:);
    for j = 1:nobs
        co = Obs(j,1:2);
        ro = Obs(j,3);
        dist = dist_line_point(p1, p2, co);
        c1 = ro - dist;
        c = [c; c1];
    end
end

end
