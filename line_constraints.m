function [c, ceq] = line_constraints(a, r1, r2, bl1, bl2, pl1, pl2, Obs)

% Goal -> apply line segment constraints in the candidate 2 link design

% INPUTS

% a: vector (1x2)- coordinates of origin of manipulator
% r1: real number- first link length 
% r2: real number- second link length 
% bl1: vector (1x2): position of elbow for the 
% initial point that define a line segment shape primitive
% bl2: vector (1x2): position of elbow for the 
% final point that define a line segment shape primitive
% pl1: vector (1x2): initial point that define line segment
% pl2: vector (1x2): final point that define line segment
% Obs: matrix (# of obstacles x 3)- (x_center, y_center, radius)

% OUTPUTS:

% c: vector -> c <= 0 constraints
% ceq: vector -> ceq == 0 constraints

[nobs, ~] = size(Obs);
eps = 1e-2;

% link lengths
ceq1 = (a(1) - bl1(1))^2 + (a(2) - bl1(2))^2 - r1^2;
ceq2 = (a(1) - bl2(1))^2 + (a(2) - bl2(2))^2 - r1^2;

ceq3 = (bl1(1) - pl1(1))^2 + (bl1(2) - pl1(2))^2 - r2^2;
ceq4 = (bl2(1) - pl2(1))^2 + (bl2(2) - pl2(2))^2 - r2^2;

ceq = [ceq1; ceq2; ceq3; ceq4];

% same direction
aux1 = crossproduct(a, bl1, a, pl1);
aux2 = crossproduct(a, bl2, a, pl2);

c1 = -aux1*aux2;

% extremity points are inside reachable space
c2 = (r1 - r2)^2 - ((pl1(1) - a(1))^2 + (pl1(2) - a(2))^2);
c3 = (r1 - r2)^2 - ((pl2(1) - a(1))^2 + (pl2(2) - a(2))^2);

c4 = ((pl1(1) - a(1))^2 + (pl1(2) - a(2))^2) - (r1 + r2)^2;
c5 = ((pl2(1) - a(1))^2 + (pl2(2) - a(2))^2) - (r1 + r2)^2;

c = [c1; c2; c3; c4; c5];

% calculate point closest to origin on the line segment
t = dotproduct(pl1, a, pl1, pl2)/dotproduct(pl1, pl2, pl1, pl2);
plmin = [pl1(1) + (pl2(1) - pl1(1))*t, pl1(2) + (pl2(2) - pl1(2))*t];

if t > 0 && t < 1
    
    % closest point inside reachable space
    c6 = (r1 - r2)^2 - ((plmin(1) - a(1))^2 + (plmin(2) - a(2))^2);
    c = [c; c6];
    
    % calculate blmin (elbow position to reach plmin)
    if plmin(1) ~= a(1)
        B1 = -(plmin(2) - a(2))/(plmin(1) - a(1));
        A1 = (r1^2 - r2^2 - (a(1)^2 - plmin(1)^2 + a(2)^2 - plmin(2)^2))/(2*(plmin(1) - a(1)));

        A2 = B1^2 + 1;
        B2 = -2*a(1)*B1 + 2*A1*B1 - 2*a(2);
        C2 = a(1)^2 + A1^2 + a(2)^2 - 2*a(1)*A1 - r1^2;

        y1 = (-B2 + sqrt(B2^2 - 4*A2*C2))/(2*A2);
        y2 = (-B2 - sqrt(B2^2 - 4*A2*C2))/(2*A2);
        x1 = B1*y1 + A1;
        x2 = B1*y2 + A1;

        blmin1 = [x1, y1];
        aux1 = crossproduct(a, bl1, a, pl1);
        aux3 = crossproduct(a, blmin1, a, plmin);

        if aux1*aux3 >= 0
            blmin = [x1, y1];
        else
            blmin = [x2, y2];
        end
    else
        d = abs(plmin(2) - a(2));
        ct = (r1^2 + d^2 - r2^2)/(2*r1*d);
        blmin = [a(1) + r1*ct, a(2) + r1*sqrt(1-ct^2)];
    end
    [elbow1,elbow2] = ExtremitiesBetween3P(bl1, bl2, blmin, a);
    c7 = SelfColl1(r1, r2, a, blmin, plmin);
    c = [c; c7];
else
    elbow1 = bl1;
    elbow2 = bl2;   
    c = [c; -10];
    distapl1 = sqrt((pl1(1)-a(1))^2 + (pl1(2)-a(2))^2);
    distapl2 = sqrt((pl2(1)-a(1))^2 + (pl2(2)-a(2))^2);
    if distapl1 < distapl2
        c7 = SelfColl1(r1, r2, a, bl1, pl1);
    else
        c7 = SelfColl1(r1, r2, a, bl2, pl2);
    end
    c = [c; c7];
end

eps = .05;


if ~isempty(Obs) % collision avoidance constraints
    M = (elbow1 + elbow2)/2;
    t1 = 1 - r1/sqrt((M(1) - a(1))^2 + (M(2) - a(2))^2);
    t2 = 1 + r1/sqrt((M(1) - a(1))^2 + (M(2) - a(2))^2);
    T1 = M + (a - M)*t1;
    T2 = M + (a - M)*t2;
    % find which T is in between
    [int1, ~] = intersect_line_circle(pl1, pl2, T1, r2);

    if ~isempty(int1) 
        T = T1;
    else
        T = T2;
    end
    % calculate tangents from elbow1, T and elbow2
    [al, bl] = Tan2CircleFromP(a, elbow1);
    [ar, br] = Tan2CircleFromP(a, elbow2);
    [at, bt] = Tan2CircleFromP(a, T);

    [plt] = Intersect2InfLines(al, bl, at, bt);
    [prt] = Intersect2InfLines(ar, br, at, bt);
    
    points = real([a; elbow1; elbow2; prt; plt]);
%     points(any(isnan(points),2),:) = [];
    [x, y] = sortPoints(points(:,1), points(:,2));
    p = [x, y];
    k = unique(convhull(p));
    p1 = [p(k,1),p(k,2)];
    
    points = real([elbow1; elbow2; pl1; pl2; prt; plt]);
%     points(any(isnan(points),2),:) = [];
    [x, y] = sortPoints(points(:,1), points(:,2));
    p = [x, y];
    k = unique(convhull(p));
    p2 = [p(k,1),p(k,2)];
    
    for j = 1:nobs

        xo = Obs(j,1);
        yo = Obs(j,2);
        ro = Obs(j,3);

        c8 = ro - sqrt((xo - a(1))^2 + (yo - a(2))^2);
        c9 = ro - sqrt((xo - elbow1(1))^2 + (yo - elbow1(2))^2);
        c10 = ro - sqrt((xo - elbow2(1))^2 + (yo - elbow2(2))^2);
        c11 = ro - sqrt((xo - pl1(1))^2 + (yo - pl1(2))^2);
        c12 = ro - sqrt((xo - pl2(1))^2 + (yo - pl2(2))^2);

        c = [c; c8; c9; c10; c11; c12];

        q1 = dist_line_point(a, elbow1, [xo, yo]);
        q2 = dist_line_point(a, elbow2, [xo, yo]);
        q3 = dist_line_point(elbow1, pl1, [xo, yo]);
        q4 = dist_line_point(elbow2, pl2, [xo, yo]);
        q5 = dist_line_point(elbow1, pl2, [xo, yo]);
        q6 = dist_line_point(elbow2, pl1, [xo, yo]);
        
        c13 = ro - q1;
        c14 = ro - q2;
        c15 = ro - q3;
        c16 = ro - q4;
        c17 = ro - q5;
        c18 = ro - q6;
        c = [c; c13; c14; c15; c16; c17; c18];
            
        in = inpolygon(xo, yo, p1(:,1), p1(:,2));
        ceq = [ceq; in];

        in = inpolygon(xo, yo, p2(:,1), p2(:,2));
        ceq = [ceq; in];

    end
end
% c = c + eps;
end