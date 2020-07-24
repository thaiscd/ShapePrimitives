function [dist] = dist_line_point(u1, u2, p)

% Goal -> calculate the distance between a line segment defined by the
% points u1 and u2 to the point p

% INPUTS:

% u1: vector (1x2) -> initial point on the line segment
% u2: vector (1x2) -> final point on the line segment

% OUTPUTS:

% dist: real number -> distance between point p and line segment u1u2

eps = 1e-5;
err = 5e-2;
dist1 = sqrt((u1(1) - p(1))^2 + (u1(2) - p(2))^2); 
dist2 = sqrt((u2(1) - p(1))^2 + (u2(2) - p(2))^2); 
distu1u2 = sqrt((u2(1) - u1(1))^2 + (u2(2) - u1(2))^2); 

if abs(distu1u2 - dist1 - dist2) < eps
    dist = -10; % on line segment
else
    t = -dotproduct(u1, u2, p, u1)/dotproduct(u1, u2, u1, u2);
    u = [u1(1) + (u2(1) - u1(1))*t, u1(2) + (u2(2) - u1(2))*t];

    if t >= 0 && t <= 1
        dist = sqrt((u(1) - p(1))^2 + (u(2) - p(2))^2) - err; 
    else       
        if dist1 < dist2
            dist = dist1 - err;
        else
            dist = dist2 - err;
        end
    end
end

end