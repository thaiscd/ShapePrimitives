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

[left, right, pleft, pright, T] = extremSV([1, pl1, pl2, 0 0 0], [r1, r2], a, bl1, bl2);

if isempty(T)
    M = (left + right)/2;
    t = 1 - r1/sqrt((M(1) - a(1))^2 + (M(2) - a(2))^2);
    T = M + (a - M)*t;
end

if t > 0 && t < 1
    % closest point inside reachable space
    c6 = (r1 - r2)^2 - ((plmin(1) - a(1))^2 + (plmin(2) - a(2))^2);
    c = [c; c6];   
else
    
    c6 = -10;
    c = [c; c6];
end

c7 = SelfColl1(r1, r2, a, left, pleft);
c8 = SelfColl1(r1, r2, a, right, pright);
c = [c; c7; c8];
eps = .05;

position = sign((pl1(1) - a(1))*(pl2(2) - a(2)) - (pl1(2) - a(2))*(pl2(1) - a(1)));
if position > 0
    Pright = pl1;
    Pleft = pl2;
elseif position < 0
    Pright = pl2;
    Pleft = pl1;
end 

if ~isempty(Obs) % collision avoidance constraints
    
    [al, bl] = Tan2CircleFromP(a, left);
    [ar, br] = Tan2CircleFromP(a, right);
    [at, bt] = Tan2CircleFromP(a, T);
    
    [plt] = Intersect2InfLines(al, bl, at, bt);
    [prt] = Intersect2InfLines(ar, br, at, bt);
    
    for j = 1:nobs

        xo = Obs(j,1);
        yo = Obs(j,2);
        ro = Obs(j,3) + eps;

        c8 = ro - sqrt((xo - a(1))^2 + (yo - a(2))^2);
        c9 = ro - sqrt((xo - left(1))^2 + (yo - left(2))^2);
        c10 = ro - sqrt((xo - right(1))^2 + (yo - right(2))^2);
        c11 = ro - sqrt((xo - pl1(1))^2 + (yo - pl1(2))^2);
        c12 = ro - sqrt((xo - pl2(1))^2 + (yo - pl2(2))^2);

        c = [c; c8; c9; c10; c11; c12];
 
        q1 = dist_line_point(a, left, [xo, yo]);
        q2 = dist_line_point(a, right, [xo, yo]);
        q3 = dist_line_point(left, Pleft, [xo, yo]);
        q4 = dist_line_point(right, Pright, [xo, yo]);

        c13 = ro - q1;
        c14 = ro - q2;
        c15 = ro - q3;
        c16 = ro - q4;
        c = [c; c13; c14; c15; c16];
        
        P = real([a; left; plt; prt; right]);
        k = convhull(P);
        p = [P(k,1),P(k,2)];
        p = unique(p, 'rows');
        in = inpolygon(xo, yo, p(:,1), p(:,2));
        ceq = [ceq; in];
        %%%%%%%%%%%%%%%%%%%%%%%%%
        
        P = real([left; Pleft; Pright; right]);
        k = convhull(P);
        p = [P(k,1),P(k,2)];
        p = unique(p, 'rows');
        in = inpolygon(xo, yo, p(:,1), p(:,2));
        ceq = [ceq; in];

    end
end

end