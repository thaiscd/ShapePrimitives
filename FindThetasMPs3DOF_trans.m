function [booltraj, theta] = FindThetasMPs3DOF_trans(r0, r1, r2, o, pose1, pose2, obs, n)

             
% GOAL: Calculate firt, second and third joint angles during transition
% between shape primitives

% INPUTS:

%   R0, R1, R2: link lengths
%   o: [1 x 2] -> origin of manipulator 
%   pose1: vector ((nL + 1) x 2)- coordinates of module's center of arm at
%   the end of current shape primitive
%   pose2: vector ((nL + 1) x 2)- coordinates of module's center of arm at
%   the beginning of next shape primitive
%   Obs: matrix (# of obstacles x 3)- (x_center, y_center, radius)
%   n: integer - # of points in each motion primitive to calculate joint
%   angle

% OUTPUTS:
%   booltraj: 1 if there is trajectory without collision and 0 if there
%   isn't
%   theta: matrix [n x 3] -> joint angles for transition motion


[P1] = FK([r0, r1, r2], pose1, o);
EF = P1(end,:);

if pose1(1) ~= pose2(1)
    if pose2(1) > pose1(1)
        t1d1 = linspace(pose1(1), pose2(1), n);
        t1d2 = linspace(pose2(1), 2*pi, n);
        t1d2 = fliplr([t1d2, linspace(0, pose1(1), n)]);
    else
        t1d1 = linspace(pose1(1), pose2(1), n);
        t1d2 = linspace(pose1(1), 2*pi, n);
        t1d2 = [t1d2, linspace(0, pose2(1), n)];
    end
else
    t1d2 = linspace(pose2(1), 2*pi, n);
    t1d2 = fliplr([t1d2, linspace(0, pose2(1), n)]);
    t1d1 = fliplr(t1d2);
end
    
    
t2d1 = zeros(length(t1d1),1);
t2d2 = zeros(length(t1d2),1);
t3d1 = zeros(length(t1d1),1);
t3d2 = zeros(length(t1d2),1);
t2d1(1,1) = pose1(2);
t2d2(1,1) = pose1(2);
t3d1(1,1) = pose1(3);
t3d2(1,1) = pose1(3);

errd1 = 0;
errd2 = 0;

id1 = 1;
id2 = 1;
booltrajd1 = 0;
booltrajd2 = 0;

while booltrajd1 == 0 && id1 < length(t1d1)
    id1 = id1 + 1;
    [j2, j3] = Find_t2t3(r0, r1, r2, EF(1), EF(2), o, t1d1(id1), t2d1(id1-1), t3d1(id1-1));
    t2d1(id1) = j2;
    t3d1(id1) = j3;
    [booltrajd1, Q] = CollisionCheck([r0, r1, r2], [t1d1(id1), j2, j3], o, obs);
    errd1 = errd1 + (Q(1) - EF(1))^2 + (Q(2) - EF(2))^2;
    
end

while booltrajd2 == 0 && id2 < length(t1d2)
    id2 = id2 + 1;
    [j2, j3] = Find_t2t3(r0, r1, r2, EF(1), EF(2), o, t1d2(id2), t2d2(id2-1), t3d2(id2-1));
    t2d2(id2) = j2;
    t3d2(id2) = j3;
    [booltrajd2, Q] = CollisionCheck([r0, r1, r2], [t1d2(id2), j2, j3], o, obs);
    errd2 = errd2 + (Q(1) - EF(1))^2 + (Q(2) - EF(2))^2;
    
end
booltraj = 1;
eps=5e-1;
if booltrajd1 == 0 && booltrajd2 == 1
    if errd1 < eps
        if abs(wrapToPi(t2d1(end)) - wrapToPi(pose2(2))) < eps || abs(wrapToPi(t2d1(end) - pose2(2))) < eps
            theta = [t1d1', t2d1, t3d1];
        else
            theta = [];
            booltraj = 0;
        end
    else
        theta = [];
        booltraj = 0;
    end
elseif booltrajd1 == 1 && booltrajd2 == 0
    if errd2 < eps
        if abs(wrapToPi(t2d2(end)) - wrapToPi(pose2(2))) < eps || abs(wrapToPi(t2d2(end) - pose2(2))) < eps
            theta = [t1d2', t2d2, t3d2];
        else
            theta = [];
            booltraj = 0;
        end
    else
        theta = [];
        booltraj = 0;
    end
elseif booltrajd1 == 0 && booltrajd2 == 0
    if errd2 < errd1 && errd2 < eps
        if abs(wrapToPi(t2d2(end)) - wrapToPi(pose2(2))) < eps || abs(wrapToPi(t2d2(end) - pose2(2))) < eps
            theta = [t1d2', t2d2, t3d2];
        else
            if abs(t2d1(end) - pose2(2)) < eps
                theta = [t1d1', t2d1, t3d1];
            else
                theta = [];
                booltraj = 0;
            end
        end
    else
        if abs(wrapToPi(t2d1(end)) - wrapToPi(pose2(2))) < eps && errd1 < eps || abs(wrapToPi(t2d1(end) - pose2(2))) < eps && errd1 < eps
            theta = [t1d1', t2d1, t3d1];
        else
            if (abs(wrapToPi(t2d2(end)) - wrapToPi(pose2(2))) || abs(wrapToPi(t2d2(end) - pose2(2))) < eps) < eps && errd2 < eps
                theta = [t1d2', t2d2, t3d2];
            else
                theta = [];
                booltraj = 0;
            end
        end
    end
else
    theta = [];
    booltraj = 0;
end

end

