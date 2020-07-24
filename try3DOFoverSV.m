function [bool, o, r0, r1, r2, theta] = try3DOFoverSV(nitermax, MPs, Obs, OC, maxlength, n)

% Goal -> try to find a 2DOF design

% INPUTS:

% nitermax: integer- # maximum of iterations to try to find a design for 
% each # of possible dofs
% MPS: matrix (# of shape primitives x 8)- shape primitives
% Obs: matrix (# of obstacles x 3)- (x_center, y_center, radius)
% OC: matrix (# of rectangles x 4)- (xmin, xmax, ymin, ymax) - it defines
% the constraints on the origin of manipulator
% maxlength - real number- maximum link length allowed
% n: integer: number of discretization of a shape primitive to calculate
% joint angles (controls)

% OUTPUTS:

% bool: boolean- 1 if found a design and 0 if it didn't
% a: vector (1x2)- coordinates of origin of manipulator
% r0: real number- first link length 
% r1: real number- second link length 
% r2: real number- third link length 
% theta: matrix (n x 3)- joint angles (controls) to perform full trajectory

o = 0;
r0 = 0;
r1 = 0;
r2 = 0;
theta = 0;
nL = 3;

x0 = initguess4mps(MPs, nL, maxlength, Obs, 2, OC);
[nMPs, ~] = size(MPs);

[nv,~] = size(x0);
lb = zeros(nv,1);
ub = zeros(nv,1);
lb(:) = -1;
ub(:) = 1;
lb(3 + 2*nMPs) = .1;
lb(4 + 2*nMPs) = .1;
lb(5 + 2*nMPs) = .1;
ub(3 + 2*nMPs) = maxlength;
ub(4 + 2*nMPs) = maxlength;
ub(5 + 2*nMPs) = maxlength;
lb(1) = OC(1);
lb(2) = OC(3);
ub(1) = OC(2);
ub(2) = OC(4);

options = optimoptions('fmincon','MaxFunctionEvaluations',5.000000e+04,'Algorithm','sqp','ConstraintTolerance',1e-3);

nonlcon = @(x) constraints3DOFoverSV(x, MPs, Obs, OC);
fun = @(x) minL(x, nL, nMPs);
bool = 0;
indx = 0;
viol = 5e-2;

while bool ~= 1 && indx <= nitermax 
    indx = indx + 1;
    try 
        [x, ~, ~, ~] = fmincon(fun,x0,[],[],[],[],lb,ub,nonlcon,options);
        [c,ceq] = constraints3DOFoverSV(x, MPs, Obs, OC);
        c1 = max(c);
        ceq1 = abs(max(ceq));

        if c1 < viol && ceq1 < 1
            o = x(1 : 2)';
            a = x(3 : 2 + 2*nMPs);
            r0 = x(3 + 2*nMPs);
            r1 = x(4 + 2*nMPs);
            r2 = x(5 + 2*nMPs);
            y = x(6 + 2*nMPs : end);

            bl1 = [];
            bl2 = [];
            bc = [];
            ba1 = [];
            ba2 = [];

            for i = 1:nMPs
                if MPs(i,1) == 1
                    bl1p = y(4*i-3:4*i-2)';
                    bl2p = y(4*i-1:4*i)';
                    bl1 = [bl1; bl1p];
                    bl2 = [bl2; bl2p];
                elseif MPs(i,1) == 0
                    bcp = y(4*i-3:4*i-2)';
                    bc = [bc; bcp];
                else
                    ba1p = y(4*i-3:4*i-2)';
                    ba2p = y(4*i-1:4*i)';
                    ba1 = [ba1; ba1p];
                    ba2 = [ba2; ba2p];
                end
            end

            [bool, theta] = TrajectoryCheckOver(n, MPs, Obs, o, a, r0, r1, r2, bl1, bl2, bc, ba1, ba2);
            if bool == 0
                fun = @(x) minL(x, nL, nMPs);
                nonlcon = @(x) constraints3DOFoverSV(x, MPs, Obs, OC);
                x0 = initguess4mps(MPs, nL, maxlength, Obs, nitermax, OC);
            end
        else
            fun = @(x) minL(x, nL, nMPs);
            nonlcon = @(x) constraints3DOFoverSV(x, MPs, Obs, OC);
            x0 = initguess4mps(MPs, nL, maxlength, Obs, nitermax, OC);

        end
    catch
    end

end


end