function [c, ceq] = circle_constraints(a, r1, r2, bc, pc, ci, r, Obs)

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
eps = 1e-2;

daci = sqrt((a(1) - ci(1))^2 + (a(2) - ci(2))^2);
ptop = [ci(1) - (a(1) - ci(1))*r/daci, ci(2) - (a(2) - ci(2))*r/daci]; % farthest point to origin
pdown = [ci(1) + (a(1) - ci(1))*r/daci, ci(2) + (a(2) - ci(2))*r/daci]; % closest point to origin


%finding btop
A1 = (r2^2 - r1^2 + ((a(1)^2 - ptop(1)^2) + (a(2)^2 - ptop(2)^2)))/(2*(a(1) - ptop(1)));
B1 = (ptop(2) - a(2))/(a(1) - ptop(1));

A2 = B1^2 + 1;
B2 = 2*(A1*B1 - a(1)*B1 - a(2));
C2 = a(1)^2 + a(2)^2 + A1^2 - 2*a(1)*A1 - r1^2;

btop1y = (-B2 + sqrt(B2^2 - 4*A2*C2))/(2*A2);
btop2y = (-B2 - sqrt(B2^2 - 4*A2*C2))/(2*A2);
btop1x = A1 + B1*btop1y;
btop2x = A1 + B1*btop2y;

btop1 = [btop1x, btop1y];
btop2 = [btop2x, btop2y];

%finding bdown
A1 = (r2^2 - r1^2 + ((a(1)^2 - pdown(1)^2) + (a(2)^2 - pdown(2)^2)))/(2*(a(1) - pdown(1)));
B1 = (pdown(2) - a(2))/(a(1) - pdown(1));

A2 = B1^2 + 1;
B2 = 2*(A1*B1 - a(1)*B1 - a(2));
C2 = a(1)^2 + a(2)^2 + A1^2 - 2*a(1)*A1 - r1^2;

bdown1y = (-B2 + sqrt(B2^2 - 4*A2*C2))/(2*A2);
bdown2y = (-B2 - sqrt(B2^2 - 4*A2*C2))/(2*A2);
bdown1x = A1 + B1*bdown1y;
bdown2x = A1 + B1*bdown2y;

bdown1 = [bdown1x, bdown1y];
bdown2 = [bdown2x, bdown2y];

ceq1 = (a(1) - bc(1))^2 + (a(2) - bc(2))^2 - r1^2;
ceq2 = (bc(1) - pc(1))^2 + (bc(2) - pc(2))^2 - r2^2;

ceq = [ceq1; ceq2];

aux1 = crossproduct(a, bc, a, pc);
aux2 = crossproduct(a, btop1, a, ptop);
aux3 = crossproduct(a, bdown1, a, pdown);

% finding elbow positions to reach pdown and ptop

if aux1*aux2 > 0
    btop = btop1;
else
    btop = btop2;
end

if aux1*aux3 > 0
    bdown = bdown1;
else
    bdown = bdown2;
end

% ptop and pdown on reachable space
c1 = (r1 - r2)^2 - ((pdown(1) - a(1))^2 + (pdown(2) - a(2))^2);
c2 = ((ptop(1) - a(1))^2 + (ptop(2) - a(2))^2) - (r1 + r2)^2;

c = [c1; c2];

[c3] = SelfColl1(r1, r2, a, bdown, pdown);
c = [c;c3];

if ~isempty(Obs)
    
    elbow1 = bdown;
    elbow2 = btop;
    M = (elbow1 + elbow2)/2;
    t1 = 1 - r1/sqrt((M(1) - a(1))^2 + (M(2) - a(2))^2);
    T = M + (a - M)*t1;
   
    % calculate tangents from elbow1, T and elbow2
    [al, bl] = Tan2CircleFromP(a, elbow1);
    [ar, br] = Tan2CircleFromP(a, elbow2);
    [at, bt] = Tan2CircleFromP(a, T);

    [plt] = Intersect2InfLines(al, bl, at, bt);
    [prt] = Intersect2InfLines(ar, br, at, bt);
    
    points = real([a; elbow1; elbow2; plt; prt]);
    [x, y] = sortPoints(points(:,1), points(:,2));
    p = [x, y];
    k = unique(convhull(p));
    p1 = [p(k,1),p(k,2)];
    
    % calculate tangents from elbow1, elbow2, prt and plt
    [t11, t21] = FindTang(elbow1, ci, r);
    [t12, t22] = FindTang(elbow2, ci, r);
    [t1plt, t2plt] = FindTang(plt, ci, r);
    [t1prt, t2prt] = FindTang(prt, ci, r);
    g = [t11; t21; t12; t22; t1plt; t2plt; t1prt; t2prt];
    points = real([g; elbow1; elbow2; prt; plt]);
    [x, y] = sortPoints(points(:,1), points(:,2));
    p = [x, y];
    k = unique(convhull(p));
    p2 = [p(k,1),p(k,2)];
    
    for j = 1:nobs

        xo = Obs(j,1);
        yo = Obs(j,2);
        ro = Obs(j,3) + eps;

        c7 = ro - sqrt((xo - a(1))^2 + (yo - a(2))^2);
        c8 = ro - sqrt((xo - bc(1))^2 + (yo - bc(2))^2);
        c9 = ro - sqrt((xo - bdown(1))^2 + (yo - bdown(2))^2);
        c10 = ro - sqrt((xo - btop(1))^2 + (yo - btop(2))^2);

        q1 = dist_line_point(a, bdown, [xo, yo]);
        q2 = dist_line_point(a, btop, [xo, yo]);
        q3 = dist_line_point(elbow1, t11, [xo, yo]);
        q4 = dist_line_point(elbow1, t21, [xo, yo]);
        q5 = dist_line_point(elbow2, t12, [xo, yo]);
        q6 = dist_line_point(elbow2, t22, [xo, yo]);
        
        c11 = ro - q1;
        c12 = ro - q2;
        c13 = ro - q3;
        c14 = ro - q4;
        c15 = ro - q5;
        c16 = ro - q6;

        c = [c; c7; c8; c9; c10; c11; c12; c13; c14; c15; c16];
        
        in = inpolygon(xo, yo, p1(:,1), p1(:,2));
        ceq = [ceq; in];
        
        in = inpolygon(xo, yo, p2(:,1), p2(:,2));
        ceq = [ceq; in];

    end
end
c = c + eps;
end