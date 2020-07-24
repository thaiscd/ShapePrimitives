function [bool] = PointsOnArc(dir, p_i, p_f, c, p)

bool = 0;
pixp = sign((p_i(1) - c(1))*(p(2) - c(2)) - (p_i(2) - c(2))*(p(1) - c(1)));
pxpf = sign((p(1) - c(1))*(p_f(2) - c(2)) - (p(2) - c(2))*(p_f(1) - c(1)));
if pixp*dir > 0 && pxpf*dir >0
    bool = 1;
end

end