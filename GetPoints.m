function [p] = GetPoints(MPs,n)

% Goal - discretize each shape primitive

% INPUTS:

% MPS: matrix (# of shape primitives x 8)- shape primitives
% n: integer- number of points in each shape primitive

% OUTPUTS:

% p: matrix ((# of shape primitive)*n) x 2- coordinates of points

[nmp,~] = size(MPs);
p = [];

for i = 1:nmp
    if MPs(i,1) == 1
        p1 = MPs(i,2:3);
        p2 = MPs(i,4:5);
        pm = (p1 + p2)/2;
        if i == nmp
            p = [p; p1; p2];
        else
            p = [p; p1; pm];
        end
    elseif MPs(i,1) == 0
        ci = MPs(i,2:3);
        r = MPs(i,4);
        pc = MPs(i,5:6);
        p2 = 2*ci - pc;
        p = [p; pc; p2];
    else
        direction = MPs(i,1);
        ca = MPs(i,2:3);
        p1 = MPs(i,4:5);
        p2 = MPs(i,6:7);
        pm = (p1 + p2)/2;
        a = (pm(2) - ca(2))/(pm(1) - ca(1));
        b = ca(2) - a*ca(1);
        ra = sqrt((p1(1) - ca(1))^2 + (p1(2) - ca(2))^2);
        A = 1 + a^2;
        B = 2*(-ca(1) + a*b - a*ca(2));
        C = ca(1)^2 + b^2 + ca(2)^2 - 2*b*ca(2) - ra^2;
        x1 = (-B + sqrt(B^2 - 4*A*C))/(2*A);
        y1 = a*x1 + b;
        x2 = (-B - sqrt(B^2 - 4*A*C))/(2*A);
        y2 = a*x2 + b;
        pa = [x1, y1];
        pb = [x2, y2];
        if direction*crossproduct(ca, p1, ca, pa) > 0 
            pt = pa;
        else
            pt = pb;
        end
        
        if i == nmp
            p = [p; p1; p2];
        else
            p = [p; p1; pt];
        end
    end
end
            
        
            
            
            

% for i = 1:nmp
%     if MPs(i,1) == 1
%         p1 = MPs(i,2:3);
%         p2 = MPs(i,4:5);
%         p_x = linspace(p1(1), p2(1), n)';
%         p_y = linspace(p1(2), p2(2), n)';
%         p = [p; p_x, p_y];
%     elseif MPs(i,1) == 0
%         ci = MPs(i,2:3);
%         r = MPs(i,4);
%         pc = MPs(i,5:6);
%         cangp = (pc(1) - ci(1))/r;
%         sangp = (pc(2) - ci(2))/r;
%         angp = wrapTo2Pi(atan2(sangp, cangp));
%         ang = linspace(angp, angp + 2*pi, n);
%         p_x = ci(1) + r*cos(ang);
%         p_y = ci(2) + r*sin(ang);
%         p = [p; p_x', p_y'];
%     else
%         direction = MPs(i,1);
%         ca = MPs(i,2:3);
%         p1 = MPs(i,4:5);
%         p2 = MPs(i,6:7);
%         ra = sqrt((p1(1) - ca(1))^2 + (p1(2) - ca(2))^2);
%         cangp1 = (p1(1) - ca(1))/ra;
%         sangp1 = (p1(2) - ca(2))/ra;
%         angp1 = wrapTo2Pi(atan2(sangp1, cangp1));
%         ang = linspace(angp1, angp1 + 2*pi, n);
%         p_x_aux = ca(1) + ra*cos(ang');
%         p_y_aux = ca(2) + ra*sin(ang');
%         v1 = [p1(1) - ca(1), p1(2) - ca(2)];
%         v2 = [p_x_aux(2) - ca(1), p_y_aux(2) - ca(2)];
%         v1xv2 = v1(1)*v2(2) - v1(2)*v2(1);
%         if direction*v1xv2 > 0
% 
%             p_x = p_x_aux;
%             p_y = p_y_aux;
%         else
% 
%             p_x_aux = [p1(1); flipud(p_x_aux(2:end))];
%             p_y_aux = [p1(2); flipud(p_y_aux(2:end))];
%             
%             p_x = flipud(p_x_aux);
%             p_y = flipud(p_y_aux);
% 
%         end
%         p = [p; p_x, p_y];
%     end
% end

end