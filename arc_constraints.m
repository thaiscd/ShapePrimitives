function [c, ceq] = arc_constraints(dir, ang, a, r1, r2, ba1, ba2, pa1, pa2, ca, r, Obs)

% Goal -> apply arc constraints in the candidate 2 link design

% INPUTS

% dir: +2 for counter clockwise or -2 for clockwise
% a: vector (1x2)- coordinates of origin of manipulator
% r1: real number- first link length 
% r2: real number- second link length 
% ba1: vector (1x2)- position of elbow for the 
% initial point that define an arc shape primitive
% ba2: vector (1x2)- position of elbow for the 
% final point that define an arc shape primitive
% pa1: vector (1x2)- initial point that define arc
% pa2: vector (1x2)- final point that define arc
% ca: vector (1x2)- center of arc
% r: real number- radius of arc
% Obs: matrix (# of obstacles x 3)- (x_center, y_center, radius)

% OUTPUTS:

% c: vector -> c <= 0 constraints
% ceq: vector -> ceq == 0 constraints

[nobs, ~] = size(Obs);

eps = 1e-2;

% link lengths

ceq1 = sqrt((a(1) - ba1(1))^2 + (a(2) - ba1(2))^2) - r1;
ceq2 = sqrt((a(1) - ba2(1))^2 + (a(2) - ba2(2))^2) - r1;
ceq3 = sqrt((ba1(1) - pa1(1))^2 + (ba1(2) - pa1(2))^2) - r2;
ceq4 = sqrt((ba2(1) - pa2(1))^2 + (ba2(2) - pa2(2))^2) - r2;

ceq = [ceq1; ceq2; ceq3; ceq4];

aux1 = crossproduct(a, ba1, a, pa1);
aux2 = crossproduct(a, ba2, a, pa2);

c1 = -aux1*aux2; % same direction
c = c1;

daca = sqrt((a(1) - ca(1))^2 + (a(2) - ca(2))^2);
patop = [ca(1) - (a(1) - ca(1))*r/daca, ca(2) - (a(2) - ca(2))*r/daca];
padown = [ca(1) + (a(1) - ca(1))*r/daca, ca(2) + (a(2) - ca(2))*r/daca];

% checking if patop and padown are on arc

bool1 = PointsOnArc(dir, pa1, pa2, ca, patop);
bool2 = PointsOnArc(dir, pa1, pa2, ca, padown);

if bool1 == 1
    % guaranteeing that patop is reachable
    c1 = sqrt((patop(1) - a(1))^2 + (patop(2) - a(2))^2) - (r1 + r2);
    c = [c; c1];
else
    c = [c; -10];
end

if bool2 == 1
    % guaranteeing that padown is reachable
    c1 = (r1 - r2)^2 - ((padown(1) - a(1))^2 + (padown(2) - a(2))^2);  
    c = [c; c1];
else
    c = [c; -10];
end

% pa1 and pa2 are reachable
c1 = sqrt((pa1(1) - a(1))^2 + (pa1(2) - a(2))^2) - (r1 + r2);
c2 = sqrt((pa2(1) - a(1))^2 + (pa2(2) - a(2))^2) - (r1 + r2);
c3 = (r1 - r2)^2 - ((pa1(1) - a(1))^2 + (pa1(2) - a(2))^2);  
c4 = (r1 - r2)^2 - ((pa2(1) - a(1))^2 + (pa2(2) - a(2))^2);  
c = [c; c1; c2; c3; c4];



c2 = SelfColl1(r1, r2, a, ba1, pa1);
c3 = SelfColl1(r1, r2, a, ba2, pa2);
c = [c; c2; c3];


% calculating batop and badown
%finding btop
A1 = (r2^2 - r1^2 + ((a(1)^2 - patop(1)^2) + (a(2)^2 - patop(2)^2)))/(2*(a(1) - patop(1)));
B1 = (patop(2) - a(2))/(a(1) - patop(1));

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
A1 = (r2^2 - r1^2 + ((a(1)^2 - padown(1)^2) + (a(2)^2 - padown(2)^2)))/(2*(a(1) - padown(1)));
B1 = (padown(2) - a(2))/(a(1) - padown(1));

A2 = B1^2 + 1;
B2 = 2*(A1*B1 - a(1)*B1 - a(2));
C2 = a(1)^2 + a(2)^2 + A1^2 - 2*a(1)*A1 - r1^2;

bdown1y = (-B2 + sqrt(B2^2 - 4*A2*C2))/(2*A2);
bdown2y = (-B2 - sqrt(B2^2 - 4*A2*C2))/(2*A2);
bdown1x = A1 + B1*bdown1y;
bdown2x = A1 + B1*bdown2y;

bdown1 = [bdown1x, bdown1y];
bdown2 = [bdown2x, bdown2y];

aux3 = crossproduct(a, bdown1, a, padown);
aux4 = crossproduct(a, btop1, a, patop);

if aux1*aux3 > 0
    badown = bdown1;
else
    badown = bdown2;
end

if aux1*aux4 > 0
    batop = btop1;
else
    batop = btop2;
end

if bool2 == 1
    c1 = SelfColl1(r1, r2, a, badown, padown);
    c = [c; c1];
else
    c = [c; -10];
end

if ~isempty(Obs)

    if bool1 == 1 && bool2 == 1 % both on arc
        [e1,e2] = ExtremitiesBetween3P(ba1, ba2, batop, a);
        [elbow1,elbow2] = ExtremitiesBetween3P(e1, e2, badown, a);
    elseif bool1 == 1 && bool2 == 0
        [elbow1,elbow2] = ExtremitiesBetween3P(ba1, ba2, batop, a);
    elseif bool1 == 0 && bool2 == 1
        [elbow1,elbow2] = ExtremitiesBetween3P(ba1, ba2, badown, a);
    elseif bool1 == 0 && bool2 == 0
        elbow1 = ba1;
        elbow2 = ba2;
    end
    
    M = (elbow1 + elbow2)/2;
    t1 = 1 - r(1)/sqrt((M(1) - a(1))^2 + (M(2) - a(2))^2);
    T = M + (a - M)*t1;
    % calculate tangents from elbow1, T and elbow2
    [al, bl] = Tan2CircleFromP(a, elbow1);
    [ar, br] = Tan2CircleFromP(a, elbow2);
    [at, bt] = Tan2CircleFromP(a, T);

    [plt] = Intersect2InfLines(al, bl, at, bt);
    [prt] = Intersect2InfLines(ar, br, at, bt);

    points = real([a; elbow1; elbow2; prt; plt]);
    [x, y] = sortPoints(points(:,1), points(:,2));
    p = [x, y];
    k = unique(convhull(p));
    p1 = [p(k,1),p(k,2)];
    
    % calculate tangents from elbow1, elbow2, prt and plt
    [t11, t21] = FindTang(elbow1, ca, r);
    [t12, t22] = FindTang(elbow2, ca, r);
    [t1plt, t2plt] = FindTang(plt, ca, r);
    [t1prt, t2prt] = FindTang(prt, ca, r);
    points = [];
    g = [t11; t21; t12; t22; t1plt; t2plt; t1prt; t2prt; prt; plt];
    tang = [elbow1, t11; elbow1, t21; elbow2, t12; elbow2, t22; plt, t1plt; plt, t2plt; prt, t1prt; prt, t2prt];
    tangs = [];
    for j = 1:8
        bool1 = PointsOnArc(dir, pa1, pa2, ca, g(j,:));
        if bool1 == 1
            points = [points; g(j,:)];
            tangs = [tangs; tang(j,:)];
        end
    end
    points = real([points; ba1; ba2; elbow1; elbow2; prt; plt; pa1; pa2]);
    [x, y] = sortPoints(points(:,1), points(:,2));
    p = [x, y];
    k = unique(convhull(p));
    p2 = [p(k,1),p(k,2)];
    
    for j = 1:nobs

        xo = Obs(j,1);
        yo = Obs(j,2);
        ro = Obs(j,3);
        
        c7 = ro - sqrt((xo - a(1))^2 + (yo - a(2))^2);
        c8 = ro - sqrt((xo - elbow1(1))^2 + (yo - elbow1(2))^2);
        c9 = ro - sqrt((xo - elbow2(1))^2 + (yo - elbow2(2))^2);
        

        q1 = dist_line_point(a, elbow1, [xo, yo]);
        q2 = dist_line_point(a, elbow2, [xo, yo]);
        q3 = dist_line_point(elbow1, pa1, [xo, yo]);
        q4 = dist_line_point(elbow2, pa1, [xo, yo]);
        q5 = dist_line_point(elbow1, pa2, [xo, yo]);
        q6 = dist_line_point(elbow2, pa2, [xo, yo]);
        
        c10 = ro - q1;
        c11 = ro - q2;
        c12 = ro - q3;
        c13 = ro - q4;
        c14 = ro - q5;
        c15 = ro - q6;
        
        c = [c; c7; c8; c9; c10; c11; c12; c13; c14; c15];
        
        c1 = ro - sqrt((xo - ba1(1))^2 + (yo - ba1(2))^2);
        c2 = ro - sqrt((xo - ba2(1))^2 + (yo - ba2(2))^2);
        c = [c; c1; c2];
        
        [m,~] = size(tangs);
        for i = 1:8
            if i > m
                c = [c; -10];
            else
                q3 = dist_line_point(tangs(i,1:2), tangs(i,3:4), [xo, yo]);
                c12 = ro - q3;
                c = [c; c12];
            end
        end  
        
        in = inpolygon(xo, yo, p1(:,1), p1(:,2));
        ceq = [ceq; in];
        
        in = inpolygon(xo, yo, p2(:,1), p2(:,2));
        ceq = [ceq; in];        
        
    end
end
c = eps + c;
end