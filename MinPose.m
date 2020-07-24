function [dist] = MinPose(x, nL)

% GOAL: minimeze distance between two consecutive poses of the arm to reach
% consecutive points

% INPUTS:

%   x: vector (n x 1) - containing variables
%   nL: integer- number of link lengths

% OUTPUTS:
%   dist: sum of the distances between the poses (each point that define
%   the pose)

y = x(nL + 3 : end);

if nL == 2
    poses = reshape(y, 4, [])';
elseif nL == 3
    poses = reshape(y, 6, [])';
elseif nL == 4
    poses = reshape(y, 8, [])';
end

p = diff(poses(:,1:end-2)).^2;

dist = sum(sum(p));

end