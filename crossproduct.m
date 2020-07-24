function [cross] = crossproduct(u1, u2, v1, v2)
% Goal -> calculate the cross product between 2 2D vectors

% INPUTS:

% v1: vector (1x2) -> initial point on the first vector
% v2: vector (1x2) -> final point on the first vector
% u1: vector (1x2) -> initial point on the second vector
% u2: vector (1x2) -> final point on the second vector

% OUTPUTS:

% cross: real number -> cross product between v1v2 and u1u2

cross = (u2(1) - u1(1))*(v2(2) - v1(2)) - (u2(2) - u1(2))*(v2(1) - v1(1));

end