function [c, ceq] = arc_constraintsoverSV(dir, ang, a, r1, r2, ba1, ba2, pa1, pa2, ca, r, Obs)

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
err = 0;
eps = .05;

% link lengths

ceq1 = (a(1) - ba1(1))^2 + (a(2) - ba1(2))^2 - r1^2;
ceq2 = (a(1) - ba2(1))^2 + (a(2) - ba2(2))^2 - r1^2;
ceq3 = (ba1(1) - pa1(1))^2 + (ba1(2) - pa1(2))^2 - r2^2;
ceq4 = (ba2(1) - pa2(1))^2 + (ba2(2) - pa2(2))^2 - r2^2;

ceq = [ceq1; ceq2; ceq3; ceq4];

aux1 = crossproduct(a, ba1, a, pa1);
aux2 = crossproduct(a, ba2, a, pa2);

c1 = -aux1*aux2; % same direction
c = c1;

daca = sqrt((a(1) - ca(1))^2 + (a(2) - ca(2))^2);
patop = [ca(1) - (a(1) - ca(1))*r/daca, ca(2) - (a(2) - ca(2))*r/daca];
padown = [ca(1) + (a(1) - ca(1))*r/daca, ca(2) + (a(2) - ca(2))*r/daca];

dirtop1 = crossproduct(ca, pa1, ca, patop);
dirtop2 = crossproduct(ca, patop, ca, pa2);
dirdown1 = crossproduct(ca, pa1, ca, padown);
dirdown2 = crossproduct(ca, padown, ca, pa2);

% finding tangents
at = (ca(2) - a(2))/(ca(1) - a(1));
bt = (ca(1)*a(2) - ca(2)*a(1))/(ca(1) - a(1));
if ca(1) == a(1) && ca(1) ~= 0
    bt = 0;
    at = ca(2)/ca(1);
elseif ca(1) == a(1) && ca(1) == 0
    bt = 0;
    at = 0;
end
et = -1/at;
dt = ca(2) + ca(1)*(ca(1) - a(1))/(ca(2) - a(2));
A = 1 + et^2;
B = 2*et*dt - 2*et*ca(2) - 2*ca(1);
C = (ca(2) - dt)^2 + ca(1)^2 - r^2;
xt1 = (-B + sqrt(B^2 - 4*A*C))/(2*A);
yt1 = et*xt1 + dt;
xt2 = (-B - sqrt(B^2 - 4*A*C))/(2*A);
yt2 = et*xt2 + dt;

t1 = [xt1, yt1];
t2 = [xt2, yt2];

dirt11 = crossproduct(ca, pa1, ca, t1);
dirt12 = crossproduct(ca, t1, ca, pa2);

if dir < 0
    if dirt11 < err && dirt12 < err
        tadown = t1;
    else
        tadown = pa1;
    end
else
    if dirt11 > err && dirt12 > err
        tadown = t1;
    else
        tadown = pa1;
    end
end

dirt21 = crossproduct(ca, pa1, ca, t2);
dirt22 = crossproduct(ca, t2, ca, pa2);

if dir < 0
    if dirt21 < err && dirt22 < err
        tatop = t2;
    else
        tatop = pa2;
    end
else
    if dirt21 > err && dirt22 > err
        tatop = t2;
    else
        tatop = pa2;
    end
end

[left, right, pleft, pright, T] = extremSV([dir, ca, pa1, pa2, ang], [r1, r2], a, ba1, ba2);
if isempty(T)
    M = (left + right)/2;
    t = 1 - r1/sqrt((M(1) - a(1))^2 + (M(2) - a(2))^2);
    T = M + (a - M)*t;
end

if dir < 0
    if dirtop1 < err && dirtop2 < err
        if dirdown1 < err && dirdown2 < err % both points are on the arc
            % guaranteeing that patop and padown are reachable
            
            c2 = (r1 - r2)^2 - ((padown(1) - a(1))^2 + (padown(2) - a(2))^2);          
            c3 = ((patop(1) - a(1))^2 + (patop(2) - a(2))^2) - (r1 + r2)^2;

            c = [c; c2; c3];
            
        else % only top on the arc
            % guaranteeing that patop is reachable
            c2 = ((patop(1) - a(1))^2 + (patop(2) - a(2))^2) - (r1 + r2)^2;
            c = [c; c2];
            
            % need find badown
            distpa1 = (a(1) - pa1(1))^2 + (a(2) - pa1(2))^2;
            distpa2 = (a(1) - pa2(1))^2 + (a(2) - pa2(2))^2;
            
            if distpa2 < distpa1
                c3 = r1^2 + r2^2 - ((pa2(1) - a(1))^2 + (pa2(2) - a(2))^2);
                c = [c; c3];
            else
  
                c3 = r1^2 + r2^2 - ((pa1(1) - a(1))^2 + (pa1(2) - a(2))^2);
                c = [c; c3];
            end         

        end
        
    else 
        if dirdown1 < err && dirdown2 < err % only down on the arc
            % guaranteeing that padown is reachable
            
            c2 = (r1 - r2)^2 - ((padown(1) - a(1))^2 + (padown(2) - a(2))^2);          
            c = [c; c2];
            
            % need find batop
            distpa1 = (a(1) - pa1(1))^2 + (a(2) - pa1(2))^2;
            distpa2 = (a(1) - pa2(1))^2 + (a(2) - pa2(2))^2;
            
            if distpa2 > distpa1

                c3 = ((pa2(1) - a(1))^2 + (pa2(2) - a(2))^2) - (r1 + r2)^2;
                c = [c; c3];
            else

                c3 = ((pa1(1) - a(1))^2 + (pa1(2) - a(2))^2) - (r1 + r2)^2;
                c = [c; c3];
            end     
            
        
        else % top and down not on the arc

            % need find batop and badown
            distpa1 = (a(1) - pa1(1))^2 + (a(2) - pa1(2))^2;
            distpa2 = (a(1) - pa2(1))^2 + (a(2) - pa2(2))^2;
            
            if distpa2 > distpa1

                c2 = r1^2 + r2^2 - ((pa1(1) - a(1))^2 + (pa1(2) - a(2))^2);
                c3 = ((pa2(1) - a(1))^2 + (pa2(2) - a(2))^2) - (r1 + r2)^2;
                c = [c; c2; c3];
            else

                c2 = r1^2 + r2^2 - ((pa2(1) - a(1))^2 + (pa2(2) - a(2))^2);
                c3 = ((pa1(1) - a(1))^2 + (pa1(2) - a(2))^2) - (r1 + r2)^2;
                c = [c; c2; c3];
            end     

        end
        
    end
    
else
    if dirtop1 > err && dirtop2 > err
        if dirdown1 > err && dirdown2 > err % both points are on the arc
            % guaranteeing that patop and padown are reachable
           
            c2 = (r1 - r2)^2 - ((padown(1) - a(1))^2 + (padown(2) - a(2))^2);          
            c3 = ((patop(1) - a(1))^2 + (patop(2) - a(2))^2) - (r1 + r2)^2;

            c = [c; c2; c3];
            
            
        else % only top on the arc
            % guaranteeing that patop is reachable
            
            c2 = ((patop(1) - a(1))^2 + (patop(2) - a(2))^2) - (r1 + r2)^2;
            c = [c; c2];
            
            distpa1 = (a(1) - pa1(1))^2 + (a(2) - pa1(2))^2;
            distpa2 = (a(1) - pa2(1))^2 + (a(2) - pa2(2))^2;
            
            if distpa2 < distpa1

                c3 = r1^2 + r2^2 - ((pa2(1) - a(1))^2 + (pa2(2) - a(2))^2);
                c = [c; c3];
            else

                c3 = r1^2 + r2^2 - ((pa1(1) - a(1))^2 + (pa1(2) - a(2))^2);
                c = [c; c3];
            end           

        end
        
    else 
        if dirdown1 > err && dirdown2 > err % only down on the arc
            % guaranteeing that padown is reachable
            
            c2 = (r1 - r2)^2 - ((padown(1) - a(1))^2 + (padown(2) - a(2))^2);          
            c = [c; c2];
            
            distpa1 = (a(1) - pa1(1))^2 + (a(2) - pa1(2))^2;
            distpa2 = (a(1) - pa2(1))^2 + (a(2) - pa2(2))^2;
            
            if distpa2 > distpa1

                c3 = ((pa2(1) - a(1))^2 + (pa2(2) - a(2))^2) - (r1 + r2)^2;
                c = [c; c3];
            else
                c3 = ((pa1(1) - a(1))^2 + (pa1(2) - a(2))^2) - (r1 + r2)^2;
                c = [c; c3];
            end     
            
        else % top and down not on the arc
    
            % need find batop and badown
            distpa1 = (a(1) - pa1(1))^2 + (a(2) - pa1(2))^2;
            distpa2 = (a(1) - pa2(1))^2 + (a(2) - pa2(2))^2;
            
            if distpa2 > distpa1
 
                c2 = (r1 - r2)^2 - ((pa1(1) - a(1))^2 + (pa1(2) - a(2))^2);
                c3 = ((pa2(1) - a(1))^2 + (pa2(2) - a(2))^2) - (r1 + r2)^2;
                c = [c; c2; c3];
            else

                c2 = (r1 - r2)^2 - ((pa2(1) - a(1))^2 + (pa2(2) - a(2))^2);
                c3 = ((pa1(1) - a(1))^2 + (pa1(2) - a(2))^2) - (r1 + r2)^2;
                c = [c; c2; c3];
            end     
        end
        
    end
    
end

[c4] = SelfColl1(r1, r2, a, left, pleft);
[c5] = SelfColl1(r1, r2, a, right, pright);
c = [c;c4;c5];

if ~isempty(Obs)
    
    for j = 1:nobs

        xo = Obs(j,1);
        yo = Obs(j,2);
        ro = Obs(j,3) + eps;

        dist = sqrt((xo - a(1))^2 + (yo - a(2))^2);
        c1 = r1 + ro - dist;
        c = [c; c1];

        [SV, tangs] = OverSVarc(dir, pa1, pa2, ca, a, r1);
        in = inpolygon(xo, yo, SV(:,1), SV(:,2));
        ceq = [ceq; in];
        [m,~] = size(tangs);
        for i = 1:8
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