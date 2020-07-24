function [dist] = minL(x, nL, nMPs)

% Goal -> minimize link lengths

% INPUTS:

% x: vector (# of variables)- initial guess for each variable
% nL: integer (2 or 3)- number of links in the solution
% nMPs: integer- number of shape primitives

% OUTPUTS:

% dist: real number: sum of the link lengths to be minimized


if nL == 2
    r1 = x(3);
    r2 = x(4);
    L = [abs(r1-0.2539),abs(r2-0.18755)];
elseif nL == 3
    r0 = x(3 + 2*nMPs);
    r1 = x(4 + 2*nMPs);
    r2 = x(5 + 2*nMPs);
    L = [r0,r1,r2];
elseif nL == 4
    r0 = x(3 + 4*nMPs);
    r = x(4 + 4*nMPs);
    r1 = x(5 + 4*nMPs);
    r2 = x(6 + 4*nMPs);
    L = [r0, r, r1, r2];
end
dist = sum(L);
end