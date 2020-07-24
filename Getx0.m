function [x0] = Getx0(x, n, MPs, nL)

% Goal -> from the results (x) of the initial guess optimization with 
% discretization, get the x0 (initial guess) for the shape primitive
% problem

% INPUTS:

% x: vector (# of variables)- initial guess for each variable
% n: integer - number of discretized points in each shape primitive
% MPS: matrix (# of shape primitives x 8)- shape primitives
% nL: integer (2 or 3)- number of links in the solution

% OUTPUTS:

% x0: vector (# of variables)- initial guess for each variable for the
% problem with shape primitives

[nmp,~] = size(MPs);

r = x(1:nL);
o = x(nL+1:nL+2);
% separate points
y = x(nL + 3 : end); % same size as n*nmp*2*nL

p = {};
a = [];
b = [];
q = [];
for i = 1:nmp
    p{i} = y((i-1)*n*(2*nL)+1:i*n*(2*nL)); 
    if nL == 2
        a = [a; p{i}(1:2)];
        q = [q; p{i}(end-3:end-2)];
    elseif nL == 3
        a = [a; p{i}(1:2)];
        q = [q; p{i}(3:4); p{i}(end-3:end-2)];
    elseif nL == 4
        a = [a; p{i}(1:2)];
        b = [b; p{i}(3:4)];
        q = [q; p{i}(5:6); p{i}(end-3:end-2)];
    end
        
end

x0 = [o;a;r;b;q];

end