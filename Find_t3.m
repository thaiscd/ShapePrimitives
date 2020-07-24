function [t3] = Find_t3(a, d1, d2, r1, r2, r3, t1, t2)

% GOAL: Calculate second joint angle based on end-effector position of the
% second link (c)

% INPUTS:
%   a: [1 x 2] -> origin of manipulator
%   d1: [1 x 2] -> cartesian position of the end-effector
%   d2: [1 x 2] -> cartesian position of the end-effector
%   r1: float -> first link length
%   r2: float -> second link length
%   r3: float -> third link length
%   t1: float -> first joint angle
%   t2: float -> second joint angle

% OUTPUTS:
%   t3: float -> third joint angle


ct1 = cos(t1);
st1 = sin(t1);
ct2 = cos(t2);
st2 = sin(t2);

if ~isempty(d2)
    
    t3 = zeros(1,2);
    
    aux1 = (d1(1) - a(1))*ct1 + (d1(2) - a(2))*st1;
    aux2 = (d1(2) - a(2))*ct1 - (d1(1) - a(1))*st1;
    aux3 = aux1*ct2 + aux2*st2;
    aux4 = aux2*ct2 - aux1*st2;
    ct3 = (aux3 - r2 - r1*ct2)/r3;
    st3 = (aux4 + r1*st2)/r3;
    t3(1,1) = wrapTo2Pi(atan2(st3, ct3));

    aux1 = (d2(1) - a(1))*ct1 + (d2(2) - a(2))*st1;
    aux2 = (d2(2) - a(2))*ct1 - (d2(1) - a(1))*st1;
    aux3 = aux1*ct2 + aux2*st2;
    aux4 = aux2*ct2 - aux1*st2;
    ct3 = (aux3 - r2 - r1*ct2)/r3;
    st3 = (aux4 + r1*st2)/r3;
    t3(1,2) = wrapTo2Pi(atan2(st3, ct3));
    
else
    
    aux1 = (d1(1) - a(1))*ct1 + (d1(2) - a(2))*st1;
    aux2 = (d1(2) - a(2))*ct1 - (d1(1) - a(1))*st1;
    aux3 = aux1*ct2 + aux2*st2;
    aux4 = aux2*ct2 - aux1*st2;
    ct3 = (aux3 - r2 - r1*ct2)/r3;
    st3 = (aux4 + r1*st2)/r3;
    t3 = wrapTo2Pi(atan2(st3, ct3));
    
end
    

end