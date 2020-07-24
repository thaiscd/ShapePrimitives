function [theta] = FindThetasMPs3DOF_MP(r0, r1, r2, o, a, bl1, bl2, bc, ba1, ba2, MPs, n)

% GOAL: Calculate firt, second and third joint angles for full trajectory

% INPUTS:

%   R0, R1, R2: link lengths
%   o: [1 x 2] -> origin of manipulator 
%   a: [# of shape primitives x 2] -> coordinates of end of first link for
%   each shape primitive
%   bl1: matrix [nlines x 2] -> cartesian position of the end of the first
%   link to reach pl1 for each line segment
%   bl2: matrix [nlines x 2] -> cartesian position of the end of the first
%   link to reach pl2 for each line segment
%   bc: matrix [ncircles x 2] -> cartesian position of the end of the first
%   link to reach pc for each circle
%   ba1: matrix [narcs x 2] -> cartesian position of the end of the first
%   link to reach pa1 for each arc
%   ba2: matrix [narcs x 2] -> cartesian position of the end of the first
%   link to reach pa2 for each arc
%   MPs: matrix (# shape primitives x 8): shape primitives
%   n: integer - # of points in each motion primitive to calculate joint
%   angle

% OUTPUTS:
%   theta: matrix [n x 3] -> joint angles 

eps = 1e-7;

[nMPs,~] = size(MPs);

il = 0;
ic = 0;
ia = 0;

r = [r0, r1, r2];

theta = [];

for i = 1:nMPs
    
    if MPs(i,1) == 1
        
        il = il + 1;
        p1 = MPs(i,2:3);
        p2 = MPs(i,4:5);
        p_x = linspace(p1(1), p2(1), n);
        p_y = linspace(p1(2), p2(2), n);
        t1 = zeros(n,1);
        t2 = zeros(n,1);
        t3 = zeros(n,1);
        
        % find theta1
       
        theta1 = Find_t1(o, a, r0);
        t1(:,1) = theta1;
        
        % find theta2
        c = bl1(il,:);
        theta2 = Find_t2(o, c, r0, r1, theta1);
        t2(1,1) = theta2;
        
        % find theta3
        d1 = p1;
        d2 = [];
        theta3 = Find_t3(o, d1, d2, r0, r1, r2, theta1, theta2);
        t3(1,1) = theta3;
        
%         [P] = FK([r1, r2, r3], [theta1, theta2, theta3], a);
        
        for j = 2:n

            [theta2, theta3] = Find_t2t3(r0, r1, r2, p_x(j), p_y(j), o, theta1, theta2, theta3);
            t2(j,1) = theta2;
            t3(j,1) = theta3;
        end
        theta = [theta; t1, t2, t3];
        
    elseif MPs(i,1) == 0 
        
        ic = ic + 1;
        
        ci = MPs(i,2:3);
        r = MPs(i,4);
        p = MPs(i,5:6);
        cangp = (p(1) - ci(1))/r;
        sangp = (p(2) - ci(2))/r;
        angp = wrapTo2Pi(atan2(sangp, cangp));
        ang = linspace(angp, angp + 2*pi, n);
        p_x = ci(1) + r*cos(ang);
        p_y = ci(2) + r*sin(ang);
        t1 = zeros(n,1);
        t2 = zeros(n,1);
        t3 = zeros(n,1);
        
        % find theta1
       
        theta1 = Find_t1(o, a, r0);
        t1(:,1) = theta1;
        
        % find theta2
        c = bc(ic,:);
        theta2 = Find_t2(o, c, r0, r1, theta1);
        t2(1,1) = theta2;
        
        % find theta3
        d1 = p;
        d2 = [];
        theta3 = Find_t3(o, d1, d2, r0, r1, r2, theta1, theta2);
        t3(1,1) = theta3;
        
        for j = 2:n
            
            [theta2, theta3] = Find_t2t3(r0, r1, r2, p_x(j), p_y(j), o, theta1, theta2, theta3);
            t2(j,1) = theta2;
            t3(j,1) = theta3;
            
        end
        theta = [theta; t1, t2, t3];
       
    else

        ia = ia + 1;
        
        direction = MPs(i,1);
        ca = MPs(i,2:3);
        p1 = MPs(i,4:5);
        p2 = MPs(i,6:7);
        ra = sqrt((p1(1) - ca(1))^2 + (p1(2) - ca(2))^2);
        angp1p2 = MPs(i,8);
        nt = abs(round(2*pi*n/angp1p2));
        cangp1 = (p1(1) - ca(1))/ra;
        sangp1 = (p1(2) - ca(2))/ra;
        angp1 = wrapTo2Pi(atan2(sangp1, cangp1));
        ang = linspace(angp1, angp1 + 2*pi, nt);
        p_x_aux = ca(1) + ra*cos(ang');
        p_y_aux = ca(2) + ra*sin(ang');
        v1 = [p1(1) - ca(1), p1(2) - ca(2)];
        v2 = [p_x_aux(2) - ca(1), p_y_aux(2) - ca(2)];
        v1xv2 = v1(1)*v2(2) - v1(2)*v2(1);
        if direction*v1xv2 > 0
            dists = sum(([p_x_aux,p_y_aux] - p2).^2,2);
            [~,indx] = min(dists);
            p_x = [p_x_aux(1:indx(1));p2(1)];
            p_y = [p_y_aux(1:indx(1));p2(2)];
        else
            p_x_aux = [p1(1); flipud(p_x_aux(2:end))];
            p_y_aux = [p1(2); flipud(p_y_aux(2:end))];
            dists = sum(([p_x_aux,p_y_aux] - p2).^2,2);
            [~,indx] = min(dists);
            p_x = [p_x_aux(1:indx(1));p2(1)];
            p_y = [p_y_aux(1:indx(1));p2(2)];
        end
        t1 = zeros(length(p_x),1);
        t2 = zeros(length(p_x),1);
        t3 = zeros(length(p_x),1);
        
        % find theta1
       
        theta1 = Find_t1(o, a, r0);
        t1(:,1) = theta1;
        
        % find theta2
        c = ba1(ia,:);
        theta2 = Find_t2(o, c, r0, r1, theta1);
        t2(1,1) = theta2;
        
        % find theta3
        d1 = p1;
        d2 = [];
        theta3 = Find_t3(o, d1, d2, r0, r1, r2, theta1, theta2);
        t3(1,1) = theta3;
         
        for j = 2:length(p_x)
            
            [theta2, theta3] = Find_t2t3(r0, r1, r2, p_x(j), p_y(j), o, theta1, theta2, theta3);
            t2(j,1) = theta2;
            t3(j,1) = theta3;
            
        end
        theta = [theta; t1, t2, t3];
        
    end

end

end