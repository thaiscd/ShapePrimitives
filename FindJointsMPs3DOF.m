function [theta1, theta2] = FindJointsMPs3DOF(r1, r2, r3, a, b, MPs, n)

eps = 1e-7;

[nMPs,~] = size(MPs);

il = 0;
ic = 0;
ia = 0;

r = [r1, r2];

theta1 = [];
theta2 = [];

for i = 1:nMPs
    
    if MPs(i,1) == 1
        
        il = il + 1;
        p1 = MPs(i,2:3);
        p2 = MPs(i,4:5);
        p_x = linspace(p1(1), p2(1), n);
        p_y = linspace(p1(2), p2(2), n);
        t1 = zeros(n,3);
        t2 = zeros(n,3);
        
        for j = 1:n

            [j1, j2] = IK3DOF(a, b(i,:), r1, r2, r3, p_x(j), p_y(j));
            t1(j,:) = j1;
            t2(j,:) = j2;
        end
        theta1 = [theta1; t1];
        theta2 = [theta2; t2];
        
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
        t1 = zeros(n,3);
        t2 = zeros(n,3);
        
        for j = 1:n

            [j1, j2] = IK3DOF(a, b(i,:), r1, r2, r3, p_x(j), p_y(j));
            t1(j,:) = j1;
            t2(j,:) = j2;
        end
        theta1 = [theta1; t1];
        theta2 = [theta2; t2];
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
        narc = length(p_x);
        t1 = zeros(narc,3);
        t2 = zeros(narc,3);
        
        for j = 1:narc

            [j1, j2] = IK3DOF(a, b(i,:), r1, r2, r3, p_x(j), p_y(j));
            t1(j,:) = j1;
            t2(j,:) = j2;
        end
        theta1 = [theta1; t1];
        theta2 = [theta2; t2];
    end

end
end