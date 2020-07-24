function [ceq1] = EFreach(pose, p)

% Goal -> constraints to the end-effector coincide with the task point

% INPUTS:

% pose: vector (1 x 2)- coordinates of end-effector
% p: vector (1 x 2)- coordinates of task point

% OUTPUTS:

% ceq: vector -> ceq == 0 constraints


EF = pose(end,:);

ceq1 = (EF(1)-p(1))^2 + (EF(2)-p(2))^2;

end
