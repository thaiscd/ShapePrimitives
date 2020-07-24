function [c,ceq] = constraints2DOFoverSV(x, MPs, Obs, OC)

% Goal -> constraints to find a design able to perform the trajectory
% composed by the shape primitives with a 2 link arm

% INPUTS:

% x: vector with the variables
% MPS: matrix (# of shape primitives x 8)- shape primitives
% Obs: matrix (# of obstacles x 3)- (x_center, y_center, radius)
% nitermax: integer- # maximum of iterations to try to find a design for 
% each # of possible dofs
% OC: matrix (# of rectangles x 4)- (xmin, ymin, xmax, ymax) - it defines
% the constraints on the origin of manipulator

% OUTPUTS:

% c: vector -> c <= 0 constraints
% ceq: vector -> ceq == 0 constraints


[nMPs, ~] = size(MPs);
eps = 0.01;
a = [x(1), x(2)];
r1 = x(3);
r2 = x(4);
y = x(5:end);

poseB = cell(nMPs,1);
poseE = cell(nMPs,1);

c = [];
ceq = [];

% constraints on origin
if ~isempty(OC)
    [nOC, ~] = size(OC);
    F = zeros(nOC,1);
    for i = 1:nOC
        F(i) = max([(a(1) - OC(i,2)),(a(2) - OC(i,4)),(OC(i,1) - a(1)),(OC(i,3) - a(2))]);
    end
    c = min(F);
end

for i = 1:nMPs
    if MPs(i,1) == 1

        varl = y(4*(i-1) + 1 : 4*i);
        bl1 = [varl(1), varl(2)];
        bl2 = [varl(3), varl(4)];
        pl1 = MPs(i,2:3);
        pl2 = MPs(i,4:5);
        
        [cl, ceql] = line_constraintsoverSV(a, r1, r2, bl1, bl2, pl1, pl2, Obs); % line segment constraints
        
        c = [c;cl];
        ceq = [ceq; ceql];
        
        pose_b = [a; bl1; pl1];
        pose_e = [a; bl2; pl2];
        poseB{i} = pose_b;
        poseE{i} = pose_e;
        
    elseif MPs(i,1) == 0
        
        varc = y(4*(i-1) + 1 : 4*i);
        bc = [varc(1), varc(2)];
        pc = MPs(i,5:6);
        center = MPs(i,2:3);
        radius = MPs(i,4);
        
        [cc, ceqc] = circle_constraintsoverSV(a, r1, r2, bc, pc, center, radius, Obs); % circle constraints
        
        c = [c;cc];
        ceq = [ceq; ceqc];
        
        pose_b = [a; bc; pc];
        pose_e = [a; bc; pc];
        poseB{i} = pose_b;
        poseE{i} = pose_e;
        
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
        
        [ca, ceqa] = arc_constraintsoverSV(dir, ang, a, r1, r2, ba1, ba2, pa1, pa2, center, radius, Obs); % arc constraints
        
        c = [c;ca];
        ceq = [ceq; ceqa];
        
        pose_b = [a; ba1; pa1];
        pose_e = [a; ba2; pa2];
        poseB{i} = pose_b;
        poseE{i} = pose_e;
    end   
end

for i = 1:nMPs - 1
    [ceq_cont] = continuity_constraints(poseE{i}, poseB{i+1}); 
    ceq = [ceq; ceq_cont];
end

c = real(c)+eps;
        
end 
        

