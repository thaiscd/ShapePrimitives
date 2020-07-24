function [ceq] = continuity_constraints(pose1, pose2)

% Goal -> apply continuity constraints during the transition motion between
% current and next shape primitive for a 2 link arm. In this case, the
% final position of the current shape primitive need tos coincide with
% initial position of next

% INPUTS

% pose1: matrix (3x2)-> arm pose at the end of current shape primitive
% pose2: matrix (3x2)-> arm pose at the beginning of current shape primitive

% OUTPUTS:

% ceq: vector -> ceq == 0 constraints


ceq1 = abs(pose1(1,1) - pose2(1,1));
ceq2 = abs(pose1(1,2) - pose2(1,2));
ceq3 = abs(pose1(2,1) - pose2(2,1));
ceq4 = abs(pose1(2,2) - pose2(2,2));
ceq5 = abs(pose1(3,1) - pose2(3,1));
ceq6 = abs(pose1(3,2) - pose2(3,2));

ceq = [ceq1; ceq2; ceq3; ceq4; ceq5; ceq6];
ceq = ceq + 0.01;

    
end