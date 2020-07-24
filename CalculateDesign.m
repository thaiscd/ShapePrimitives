function [bool, nL, o, r0, r, r1, r2, theta, ft] = CalculateDesign(nitermax, MPs, Obs, OC, maxlength)

% Goal -> given input from GUI, try to find a design. Fist, it tries with
% 2DOF then with 3DOF

% INPUTS:

% nitermax: integer- # maximum of iterations to try to find a design for 
% each # of possible dofs
% MPS: matrix (# of shape primitives x 8)- shape primitives
% Obs: matrix (# of obstacles x 3)- (x_center, y_center, radius)
% OC: matrix (# of rectangles x 4)- (xmin, ymin, xmax, ymax) - it defines
% the constraints on the origin of manipulator
% maxlength - real number- maximum link length allowed

% OUTPUTS:

% bool: boolean- 1 if found a design and 0 if it didn't
% nL: integer (2 or 3)- number of links in the solution
% o: vector (1x2)- coordinates of origin of manipulator
% r0: real number- first link length of a 3DOF or 4DOF
% r: real number- second link length of a 4 DOF
% r1: real number- first, second or third link length of a 2, 3, or 4 dof,
% respectively
% r2: real number- second, third or fourth link length of a 2, 3 or 4 DOF,
% respectively
% theta: matrix (n x nL)- joint angles to perform the trajectory


% initializing the variables
t = tic;
nL = 2;
o = 0;
r0 = 0;
r = 0;
r1 = 0;
r2 = 0;
bool = 0;
n = 50;
theta = 0;
% 
% first, try to find a 2 DOF
[exitflag, o, r1, r2, bl1, bl2, bc, ba1, ba2] = try2DOFoverSV(nitermax, MPs, Obs, OC, maxlength);
% exitflag = 0;
if exitflag == 1 % if it was found, calculate controls
    [theta] = FindThetasMPs2DOFOver(r1, r2, o, bl1, bl2, bc, ba1, ba2, MPs, n);
    bool = 1;
else
    nL = 3; % if no 2 DOF was found, find a 3 DOF
    [exitflag, o, r0, r1, r2, theta] = try3DOFoverSV(nitermax, MPs, Obs, OC, maxlength, n);
    if exitflag == 1 
        bool = 1;
    else
        [exitflag, o, r1, r2, theta] = try2DOF(nitermax, MPs, Obs, OC, maxlength);
        if exitflag == 1 % if it was found, calculate controls
            bool = 1;
        else
            nL = 3; % if no 2 DOF was found, find a 3 DOF
            [exitflag, o, r0, r1, r2, theta] = try3DOF(nitermax, MPs, Obs, OC, maxlength, n);
            if exitflag == 1 
                bool = 1;
            end
        end
    end
end



ft=toc(t);
dlmwrite('runtime.txt',ft)
end