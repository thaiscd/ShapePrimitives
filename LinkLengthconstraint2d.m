function [ceq] = LinkLengthconstraint2d(p, r)

% Goal -> constraints guaranteeing that the distance between 2 consecutive
% points of the pose are equal to respective link length

% INPUTS:

% p: vector ((nL + 1) x 2)- coordinates of pose of arm
% r: vector (1 x nL)- link lengths

% OUTPUTS:

% ceq: vector -> c == 0 constraints

[nl, ~] = size(r);
ceq = [];

for i = 1:nl

    p1 = p(i,:);
    p2 = p(i+1,:);
    lr = sqrt((p1(1) - p2(1))^2 + (p1(2) - p2(2))^2) - r(i);
    ceq = [ceq; lr];

end
end
