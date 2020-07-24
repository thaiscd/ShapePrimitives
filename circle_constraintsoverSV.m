function [c, ceq] = circle_constraintsoverSV(a, r1, r2, bc, pc, ci, r, Obs)

% Goal -> apply circle segment constraints in the candidate 2 link design

% INPUTS

% a: vector (1x2)- coordinates of origin of manipulator
% r1: real number- first link length 
% r2: real number- second link length 
% bc: vector (1x2): position of elbow for the 
% final and start point on the circle
% pc: vector (1x2): initial and final point on circle
% ci: vector (1x2): coordinates of center of circle shape primitive
% r: real number: radius of circle shape primitive
% Obs: matrix (# of obstacles x 3)- (x_center, y_center, radius)

% OUTPUTS:

% c: vector -> c <= 0 constraints
% ceq: vector -> ceq == 0 constraints

[nobs, ~] = size(Obs);
err = .001;
eps = .05;

daci = sqrt((a(1) - ci(1))^2 + (a(2) - ci(2))^2);
ptop = [ci(1) - (a(1) - ci(1))*r/daci, ci(2) - (a(2) - ci(2))*r/daci]; % farthest point to origin
pdown = [ci(1) + (a(1) - ci(1))*r/daci, ci(2) + (a(2) - ci(2))*r/daci]; % closest point to origin

ceq1 = (a(1) - bc(1))^2 + (a(2) - bc(2))^2 - r1^2;
ceq2 = (bc(1) - pc(1))^2 + (bc(2) - pc(2))^2 - r2^2;

ceq = [ceq1; ceq2];

% ptop and pdown on reachable space
c1 = (r1 - r2)^2 - ((pdown(1) - a(1))^2 + (pdown(2) - a(2))^2);
c2 = ((ptop(1) - a(1))^2 + (ptop(2) - a(2))^2) - (r1 + r2)^2;

c = [c1; c2];

[left, right, pleft, pright, T] = extremSV([0, ci, r, pc, 0 0], [r1 r2], a, bc, bc);

if isempty(T)
    M = (left + right)/2;
    t = 1 - r1/sqrt((M(1) - a(1))^2 + (M(2) - a(2))^2);
    T = M + (a - M)*t;
end

[c3] = SelfColl1(r1, r2, a, left, pleft);
[c4] = SelfColl1(r1, r2, a, right, pright);
c = [c; c3; c4];

if ~isempty(Obs)
    
     for j = 1:nobs

        xo = Obs(j,1);
        yo = Obs(j,2);
        ro = Obs(j,3) + eps;

        dist = sqrt((xo - a(1))^2 + (yo - a(2))^2);
        c1 = r1 + ro - dist;
        c = [c; c1];

        [SV,t1,t2] = OverSVcirce(ci, r, a, r1);
        if isempty (SV)
            in = 1;
            ceq = [ceq; in];
            c = [c; 1; 1; 1; 1];
        else
            in = inpolygon(xo, yo, SV(:,1), SV(:,2));
            ceq = [ceq; in];

            q1 = dist_line_point(t1(1,:), t2(1,:), [xo, yo]);
            q2 = dist_line_point(t1(1,:), t2(2,:), [xo, yo]);
            q3 = dist_line_point(t1(2,:), t2(1,:), [xo, yo]);
            q4 = dist_line_point(t1(2,:), t2(2,:), [xo, yo]);

            c1 = ro - q1;
            c2 = ro - q2;
            c3 = ro - q3;
            c4 = ro - q4;
            c = [c; c1; c2; c3; c4];
        end
    end
    
end

end