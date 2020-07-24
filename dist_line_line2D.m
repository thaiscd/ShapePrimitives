function [dist] = dist_line_line2D(v1, v2, u1, u2)

% Goal -> calculate the distance between two line segments 

% INPUTS:

% v1: vector (1x2) -> initial point on the first line segment
% v2: vector (1x2) -> final point on the first line segment
% u1: vector (1x2) -> initial point on the second line segment
% u2: vector (1x2) -> final point on the second line segment

% OUTPUTS:

% dist: real number -> distance between line segments v1v2 and u1u2


bool = intersect2lines(u1,u2,v1,v2); % if bool == 1, they intersect

if bool == 0

    distv1 = dist_line_point(u1, u2, v1);
    distv2 = dist_line_point(u1, u2, v2);
    distu1 = dist_line_point(v1, v2, u1);
    distu2 = dist_line_point(v1, v2, u2);

    dist = min([distv1, distv2, distu1, distu2]);
    
else
    dist = 0;
    
end

end