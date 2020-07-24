function [a, b] = Tan2CircleFromP(C, T)

a = (T(1) - C(1))/(C(2) - T(2));
b = T(2) - T(1)*a;

end