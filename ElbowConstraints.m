function [c] = ElbowConstraints(pose1, pose2)

% Goal -> constraints so the elbow is always up or down for consecutive
% task points so the motion is smooth between task points ( without
% disconnecting from trajectory)

% INPUTS:

% pose1: vector ((nL + 1) x 2)- coordinates of module's center of arm at
% the previous point
% pose2: vector ((nL + 1) x 2)- coordinates of module's center of arm at
% the next point

% OUTPUTS:

% c: vector -> c <= 0 constraints

[n, ~] = size(pose1);

if n == 3 %nL == 2
    a = pose1(1,:);
    b1 = pose1(2,:);
    c1 = pose1(3,:);
    b2 = pose2(2,:);
    c2 = pose2(3,:);
    
    cons1 = -crossproduct(a, b1, a, c1)*crossproduct(a, b2, a, c2);
    
    c = cons1;
    
elseif n == 4 %nL == 3
    a = pose1(1,:);
    b1 = pose1(2,:);
    c1 = pose1(3,:);
    d1 = pose1(4,:);
    b2 = pose2(2,:);
    c2 = pose2(3,:);
    d2 = pose2(4,:);
    
    cons1 = -crossproduct(a, b1, a, c1)*crossproduct(a, b2, a, c2);
    cons2 = -crossproduct(b1, c1, b1, d1)*crossproduct(b2, c2, b2, d2);
    
    c = [cons1; cons2];
    
elseif n == 5 %nL == 4
   
    a = pose1(1,:);
    b1 = pose1(2,:);
    c1 = pose1(3,:);
    d1 = pose1(4,:);
    e1 = pose1(5,:);
    b2 = pose2(2,:);
    c2 = pose2(3,:);
    d2 = pose2(4,:);
    e2 = pose2(5,:);
    
    cons1 = -crossproduct(a, b1, a, c1)*crossproduct(a, b2, a, c2);
    cons2 = -crossproduct(b1, c1, b1, d1)*crossproduct(b2, c2, b2, d2);
    cons3 = -crossproduct(c1, d1, c1, e1)*crossproduct(c2, d2, c2, e2);
    
    c = [cons1; cons2; cons3];
    
end

end