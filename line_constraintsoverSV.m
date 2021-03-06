function [c, ceq] = line_constraintsoverSV(a, r1, r2, bl1, bl2, pl1, pl2, Obs)

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

if t > 0 && t < 1
    % closest point inside reachable space
    c6 = (r1 - r2)^2 - ((plmin(1) - a(1))^2 + (plmin(2) - a(2))^2);
    c = [c; c6]; 
    if plmin(1) ~= a(1)
        
        % calculate blmin (elbow position to reach plmin)
        B1 = -(plmin(2) - a(2))/(plmin(1) - a(1));
        A1 = (r1^2 - r2^2 - (a(1)^2 - plmin(1)^2 + a(2)^2 - plmin(2)^2))/(2*(plmin(1) - a(1)));

        A2 = B1^2 + 1;
        B2 = -2*a(1)*B1 + 2*A1*B1 - 2*a(2);
        C2 = a(1)^2 + A1^2 + a(2)^2 - 2*a(1)*A1 - r1^2;

        y1 = (-B2 + sqrt(B2^2 - 4*A2*C2))/(2*A2);
        y2 = (-B2 - sqrt(B2^2 - 4*A2*C2))/(2*A2);
        x1 = B1*y1 + A1;
        x2 = B1*y2 + A1;

        % choose blmin such that elbow position is always the same
        blmin1 = [x1, y1];
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
    
    c7 = SelfColl1(r1, r2, a, blmin, plmin);
    c8 = -10;
    c = [c; c7; c8];
%     [elbow1,elbow2] = ExtremitiesBetween3P(bl1, bl2, blmin, a);
    
else
    c7 = SelfColl1(r1, r2, a, bl1, pl1);
    c8 = SelfColl1(r1, r2, a, bl2, pl2);
    c6 = -10;
    c = [c; c6; c7; c8];
%     elbow1 = bl1;
%     elbow2 = bl2; 
end

eps = .05;

if ~isempty(Obs) % collision avoidance constraints
    
    for j = 1:nobs

        xo = Obs(j,1);
        yo = Obs(j,2);
        ro = Obs(j,3) + eps;

        dist = sqrt((xo - a(1))^2 + (yo - a(2))^2);
        c1 = r1 + ro - dist;
        c = [c; c1];

        [SV, tangs] = OverSVline(pl1, pl2, a, r1);
        in = inpolygon(xo, yo, SV(:,1), SV(:,2));
        ceq = [ceq; in];
        [m,~] = size(tangs);
        for i = 1:4
            if i <= m
                q1 = dist_line_point(tangs(i,1:2), tangs(i,3:4), [xo, yo]);
                c1 = ro - q1;
                c = [c; c1];
            else
                c = [c; -10];
            end
        end
    end
end

end