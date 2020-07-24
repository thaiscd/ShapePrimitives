function [c,ceq] = transition_constraints4barlinkage(r1, r2, r3, pose1, pose2, Obs)

% GOAL: apply constraints so there is transition motion for a 3 link arm
% between 2 consecutive shape primitives

% INPUTS:

%   R1, R2, R3: link lengths
%   pose1: vector ((nL + 1) x 2)- coordinates of module's center of arm at
%   the end of current shape primitive
%   pose2: vector ((nL + 1) x 2)- coordinates of module's center of arm at
%   the beginning of next shape primitive
%   Obs: matrix (# of obstacles x 3)- (x_center, y_center, radius)

% OUTPUTS:
% c: vector -> c <= 0 constraints
% ceq: vector -> ceq == 0 constraints

o = pose1(1,:);
a1 = pose1(2,:);
a2 = pose2(2,:);
b1 = pose1(3,:);
b2 = pose2(3,:);
ef = pose1(end,:);

g = sqrt((ef(1) - o(1))^2 + (ef(2) - o(2))^2);

d_a1ef = (a1(1) - ef(1))^2 + (a1(2) - ef(2))^2; 
ct1 = (r1^2 + g^2 - d_a1ef)/(2*r1*g);
t1 = acos(ct1);
d_a2ef = (a2(1) - ef(1))^2 + (a2(2) - ef(2))^2; 
ct2 = (r1^2 + g^2 - d_a2ef)/(2*r1*g);
t2 = acos(ct2);

d_ob1 = (b1(1) - o(1))^2 + (b1(2) - o(2))^2; 
cf1 = (d_ob1 - (r3^2 + g^2))/(2*r3*g);
f1 = acos(cf1);
d_ob2 = (b2(1) - o(1))^2 + (b2(2) - o(2))^2; 
cf2 = (d_ob2 - (r3^2 + g^2))/(2*r3*g);
f2 = acos(cf2);

T1 = g - r1 + r2 - r3;
T2 = g - r1 - r2 + r3;
T3 = r2 + r3 - g - r1;

ctmin = ((g^2 + r1^2) - (r2 - r3)^2)/(2*r1*g);
ctmax = ((g^2 + r1^2) - (r2 + r3)^2)/(2*r1*g);
cfmin = ((r2 + r1)^2 - (g^2 + r3^2))/(2*r3*g);
cfmax = ((r2 - r1)^2 - (g^2 + r3^2))/(2*r3*g);

c = [];
ceq = [];
if T1 > 0 && T2 > 0 && T3 > 0
    fmin = acos(cfmin);
    fmax = acos(cfmax);
    if f1 >= fmin && f1 <= fmax
        c1 = fmin - f2;
        c2 = f2 - fmax;
        c3 = -10;
        c4 = -10;
        c = [c; c1; c2; c3; c4];
        ceq1 = 0;
        ceq2 = 0;
        ceq3 = 0;
        ceq4 = 0;
        ceq = [ceq; ceq1;ceq2;ceq3;ceq4];
    elseif f1 >= -fmax && f1 <= -fmin
        c1 = fmin + f2;
        c2 = -f2 - fmax;
        c3 = -10;
        c4 = -10;
        c = [c; c1; c2; c3; c4];
        ceq1 = 0;
        ceq2 = 0;
        ceq3 = 0;
        ceq4 = 0;
        ceq = [ceq; ceq1;ceq2;ceq3;ceq4];
    else
        c1 = -10;
        c2 = -10;
        c3 = -10;
        c4 = -10;
        c = [c; c1; c2; c3; c4];
        ceq1 = a1(1) - a2(1);
        ceq2 = a1(2) - a2(2);
        ceq3 = b1(1) - b2(1);
        ceq4 = b1(2) - b2(2);
        ceq = [ceq; ceq1;ceq2;ceq3;ceq4];
    end
elseif T1 > 0 && T2 < 0 && T3 < 0
    tmin = acos(ctmin);
    tmax = acos(ctmax);
    if t1 >= tmin && t1 <= tmax
        c1 = tmin - t2;
        c2 = t2 - tmax;
        c3 = -10;
        c4 = -10;
        c = [c; c1; c2; c3; c4];
        ceq1 = 0;
        ceq2 = 0;
        ceq3 = 0;
        ceq4 = 0;
        ceq = [ceq; ceq1;ceq2;ceq3;ceq4];
    elseif t1 >= -tmax && t1 <= -tmin
        c1 = tmin + t2;
        c2 = -t2 - tmax;
        c3 = -10;
        c4 = -10;
        c = [c; c1; c2; c3; c4];
        ceq1 = 0;
        ceq2 = 0;
        ceq3 = 0;
        ceq4 = 0;
        ceq = [ceq; ceq1;ceq2;ceq3;ceq4];
    else
        c1 = -10;
        c2 = -10;
        c3 = -10;
        c4 = -10;
        c = [c; c1; c2; c3; c4];
        ceq1 = a1(1) - a2(1);
        ceq2 = a1(2) - a2(2);
        ceq3 = b1(1) - b2(1);
        ceq4 = b1(2) - b2(2);
        ceq = [ceq; ceq1;ceq2;ceq3;ceq4];
    end
elseif T1 < 0 && T2 < 0 && T3 > 0
    cross1 = crossproduct(ef, a1, ef, b1);
    cross2 = crossproduct(ef, a2, ef, b2);
    c1 = - cross1*cross2;
    c2 = -10;
    c3 = -10;
    c4 = -10;
    c = [c; c1; c2; c3; c4];
    ceq1 = 0;
    ceq2 = 0;
    ceq3 = 0;
    ceq4 = 0;
    ceq = [ceq; ceq1;ceq2;ceq3;ceq4];
elseif T1 < 0 && T2 > 0 && T3 < 0
    tmin = acos(ctmin);
    tmax = acos(ctmax);
    fmin = acos(cfmin);
    fmax = acos(cfmax);
    if t1 >= tmin && t1 <= tmax && t2 >= tmin && t2 <= tmax
        c1 = fmin - f1;
        c2 = f1 - fmax;
        c3 = fmin - f2;
        c4 = f2 - fmax;
        c = [c; c1; c2; c3; c4];
        ceq1 = 0;
        ceq2 = 0;
        ceq3 = 0;
        ceq4 = 0;
        ceq = [ceq; ceq1;ceq2;ceq3;ceq4];
    elseif t1 >= -tmax && t1 <= -tmin && t2 >= -tmax && t2 <= -tmin
        c1 = tmin + t1;
        c2 = -t1 - tmax;
        c3 = tmin + t2;
        c4 = -t2 - tmax;
        c = [c; c1; c2; c3; c4];
        ceq1 = 0;
        ceq2 = 0;
        ceq3 = 0;
        ceq4 = 0;
        ceq = [ceq; ceq1;ceq2;ceq3;ceq4];
    else
        c1 = -10;
        c2 = -10;
        c3 = -10;
        c4 = -10;
        c = [c; c1; c2; c3; c4];
        ceq1 = a1(1) - a2(1);
        ceq2 = a1(2) - a2(2);
        ceq3 = b1(1) - b2(1);
        ceq4 = b1(2) - b2(2);
        ceq = [ceq; ceq1;ceq2;ceq3;ceq4];
    end
        
elseif T1 < 0 && T2 < 0 && T3 < 0
    tmax = acos(ctmax);
    fmax = acos(cfmax);
    if t1 >= - tmax && t1 <= tmax && t2 >= - tmax && t2 <= tmax
        c1 = -f1 - fmax;
        c2 = f1 - fmax;
        c3 = -f2 - fmax;
        c4 = f2 - fmax;
        c = [c; c1; c2; c3; c4];
        ceq1 = 0;
        ceq2 = 0;
        ceq3 = 0;
        ceq4 = 0;
        ceq = [ceq; ceq1;ceq2;ceq3;ceq4];
    else
        c1 = -10;
        c2 = -10;
        c3 = -10;
        c4 = -10;
        c = [c; c1; c2; c3; c4];
        ceq1 = a1(1) - a2(1);
        ceq2 = a1(2) - a2(2);
        ceq3 = b1(1) - b2(1);
        ceq4 = b1(2) - b2(2);
        ceq = [ceq; ceq1;ceq2;ceq3;ceq4];
    end
elseif T1 > 0 && T2 > 0 && T3 < 0
    tmax = acos(ctmax);
    fmin = acos(cfmin);
    if t1 >= - tmax && t1 <= tmax && t2 >= - tmax && t2 <= tmax
        c1 = -f1 - fmin;
        c2 = f1 - fmin;
        c3 = -f2 - fmin;
        c4 = f2 - fmin;
        c = [c; c1; c2; c3; c4];
        ceq1 = 0;
        ceq2 = 0;
        ceq3 = 0;
        ceq4 = 0;
        ceq = [ceq; ceq1;ceq2;ceq3;ceq4];
    else
        c1 = -10;
        c2 = -10;
        c3 = -10;
        c4 = -10;
        c = [c; c1; c2; c3; c4];
        ceq1 = a1(1) - a2(1);
        ceq2 = a1(2) - a2(2);
        ceq3 = b1(1) - b2(1);
        ceq4 = b1(2) - b2(2);
        ceq = [ceq; ceq1;ceq2;ceq3;ceq4];
    end
elseif T1 > 0 && T2 < 0 && T3 > 0
    tmin = acos(ctmin);
    fmax = acos(cfmax);
    if t1 >= - tmin && t1 <= tmin && t2 >= - tmin && t2 <= tmin
        c1 = -f1 - fmax;
        c2 = f1 - fmax;
        c3 = -f2 - fmax;
        c4 = f2 - fmax;
        c = [c; c1; c2; c3; c4];
        ceq1 = 0;
        ceq2 = 0;
        ceq3 = 0;
        ceq4 = 0;
        ceq = [ceq; ceq1;ceq2;ceq3;ceq4];
    else
        c1 = -10;
        c2 = -10;
        c3 = -10;
        c4 = -10;
        c = [c; c1; c2; c3; c4];
        ceq1 = a1(1) - a2(1);
        ceq2 = a1(2) - a2(2);
        ceq3 = b1(1) - b2(1);
        ceq4 = b1(2) - b2(2);
        ceq = [ceq; ceq1;ceq2;ceq3;ceq4];
    end
elseif T1 < 0 && T2 > 0 && T3 > 0
    tmin = acos(ctmin);
    fmin = acos(cfmin);
    if t1 >= - tmin && t1 <= tmin && t2 >= - tmin && t2 <= tmin
        c1 = -f1 - fmin;
        c2 = f1 - fmin;
        c3 = -f2 - fmin;
        c4 = f2 - fmin;
        c = [c; c1; c2; c3; c4];
        ceq1 = 0;
        ceq2 = 0;
        ceq3 = 0;
        ceq4 = 0;
        ceq = [ceq; ceq1;ceq2;ceq3;ceq4];
    else
        c1 = -10;
        c2 = -10;
        c3 = -10;
        c4 = -10;
        c = [c; c1; c2; c3; c4];
        ceq1 = a1(1) - a2(1);
        ceq2 = a1(2) - a2(2);
        ceq3 = b1(1) - b2(1);
        ceq4 = b1(2) - b2(2);
        ceq = [ceq; ceq1;ceq2;ceq3;ceq4];
    end
else
    c1 = -10;
    c2 = -10;
    c3 = -10;
    c4 = -10;
    c = [c; c1; c2; c3; c4];
    ceq1 = a1(1) - a2(1);
    ceq2 = a1(2) - a2(2);
    ceq3 = b1(1) - b2(1);
    ceq4 = b1(2) - b2(2);
    ceq = [ceq; ceq1;ceq2;ceq3;ceq4];
end

[nobs,~]=size(Obs);

for j = 1:nobs

    xo = Obs(j,1);
    yo = Obs(j,2);
    ro = Obs(j,3);

    % origin outside obstacle
    c1 = ro^2 - ((xo - o(1))^2 + (yo - o(2))^2);

    q1 = dist_line_point(o, a1, [xo, yo]);
    q2 = dist_line_point(o, a2, [xo, yo]);
    q3 = dist_line_point(o, b1, [xo, yo]);
    q4 = dist_line_point(o, b2, [xo, yo]);

    c2 = ro - q1;
    c3 = ro - q2;
    c4 = ro - q3;
    c5 = ro - q4;

    c = [c; c1; c2; c3; c4; c5];
    in = inpolygon(xo, yo, [o(1), a1(1), a2(1)], [o(2), a1(2), a2(2)]);
    ceq = [ceq; in];
    in = inpolygon(xo, yo, [a1(1), a2(1), b2(1), b1(1)], [a1(2), a2(2), b2(2), b1(2)]);
    ceq = [ceq; in];
    in = inpolygon(xo, yo, [a1(1), a2(1), b1(1), b2(1)], [a1(2), a2(2), b1(2), b2(2)]);
    ceq = [ceq; in];
    in = inpolygon(xo, yo, [ef(1), b1(1), b2(1)], [ef(2), b1(2), b2(2)]);
    ceq = [ceq; in];

end

end