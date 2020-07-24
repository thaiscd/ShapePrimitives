function [c,ceq] = constraints3DOFoverSV(x, MPs, Obs, OC)
   
% Goal -> constraints to find a design able to perform the trajectory
% composed by the shape primitives with a 3 link arm

% INPUTS:

% x: vector with the variables
% MPS: matrix (# of shape primitives x 8)- shape primitives
% Obs: matrix (# of obstacles x 3)- (x_center, y_center, radius)
% OC: matrix (# of rectangles x 4)- (xmin, ymin, xmax, ymax) - it defines
% the constraints on the origin of manipulator

% OUTPUTS:

% c: vector -> c <= 0 constraints
% ceq: vector -> ceq == 0 constraints

[nMPs,~] = size(MPs);

o = [x(1), x(2)];
a = x(3 : 2 + 2*nMPs);
r0 = x(3 + 2*nMPs);
r1 = x(4 + 2*nMPs);
r2 = x(5 + 2*nMPs);
y = x(6 + 2*nMPs : end);

poseMP = cell(nMPs,2);

c = [];
ceq = [];

% constraints on origin
if ~isempty(OC)
    [nOC, ~] = size(OC);
    F = zeros(nOC,1);
    for i = 1:nOC
        F(i) = max([(o(1) - OC(i,2)),(o(2) - OC(i,4)),(OC(i,1) - o(1)),(OC(i,3) - o(2))]);
    end
    c = min(F);
end

% constraints on a
for i = 1:nMPs
    ceq1 = (a(2*i-1) - o(1))^2 + (a(2*i) - o(2))^2 - r0^2;
    ceq = [ceq; ceq1];
end

% constraints on the first set of MPs
for i = 1:nMPs
    if MPs(i,1) == 1

        varl = y(4*(i-1) + 1 : 4*i);
        bl1 = [varl(1), varl(2)];
        bl2 = [varl(3), varl(4)];
        pl1 = MPs(i,2:3);
        pl2 = MPs(i,4:5);
        
        [cl, ceql] = line_constraintsoverSV(a(2*i-1:2*i)', r1, r2, bl1, bl2, pl1, pl2, Obs);
        [cself] = SelfColl2l(pl1, pl2, o, a(2*i-1:2*i)');
        
        c = [c;cl;cself];
        ceq = [ceq; ceql];
        
        pose_b = [o; a(2*i-1:2*i)'; bl1; pl1];
        pose_e = [o; a(2*i-1:2*i)'; bl2; pl2];
        poseMP{i,1} = pose_b;
        poseMP{i,2} = pose_e;
        
    elseif MPs(i,1) == 0
        
        varc = y(4*(i-1) + 1 : 4*i);
        bc = [varc(1), varc(2)];
        pc = MPs(i,5:6);
        center = MPs(i,2:3);
        radius = MPs(i,4);
        
        [cc, ceqc] = circle_constraintsoverSV(a(2*i-1:2*i)', r1, r2, bc, pc, center, radius, Obs);
        [cself] = SelfColl2c(center, radius, o, a(2*i-1:2*i)');
        
        c = [c;cc;cself];
        ceq = [ceq; ceqc];
        
        pose_b = [o; a(2*i-1:2*i)'; bc; pc];
        pose_e = [o; a(2*i-1:2*i)'; bc; pc];
        poseMP{i,1} = pose_b;
        poseMP{i,2} = pose_e;
        
    else
        dir = MPs(i,1);
        vara = y(4*(i-1) + 1 : 4*i);
        ba1 = [vara(1), vara(2)];
        ba2 = [vara(3), vara(4)];
        pa1 = MPs(i,4:5);
        pa2 = MPs(i,6:7);
        ang = MPs(i,8);
        center = MPs(i,2:3);
        pa = MPs(i,4:5);
        radius = sqrt((center(1) - pa(1))^2 + (center(2) - pa(2))^2);
        ang = abs(MPs(i,8));
        
        [ca, ceqa] = arc_constraintsoverSV(dir, ang, a(2*i-1:2*i)', r1, r2, ba1, ba2, pa1, pa2, center, radius, Obs);
        [cself] = SelfColl2a(center, radius, pa1, pa2, ang, o, a(2*i-1:2*i)');
        
        c = [c;ca;cself];
        ceq = [ceq; ceqa];
        
        pose_b = [o; a(2*i-1:2*i)'; ba1; pa1];
        pose_e = [o; a(2*i-1:2*i)'; ba2; pa2];
        poseMP{i,1} = pose_b;
        poseMP{i,2} = pose_e;
    end   
end


if nMPs > 1
    for i = 1:nMPs - 1
        [ct,ceqt] = transition_constraints4barlinkage(r0, r1, r2, poseMP{i,2}, poseMP{i+1,1}, Obs);
        c = [c; ct];
        ceq = [ceq; ceqt];
    end
end

c = real(c);
        
end 