function [ex1,ex2] = ExtremitiesBetween3P(a, b, c, o)

axb = sign((a(1) - o(1))*(b(2) - o(2)) - (a(2) - o(2))*(b(1) - o(1)));
bxc = sign((b(1) - o(1))*(c(2) - o(2)) - (b(2) - o(2))*(c(1) - o(1)));
axc = sign((a(1) - o(1))*(c(2) - o(2)) - (a(2) - o(2))*(c(1) - o(1)));
cxb = -bxc;
bxa = - axb;
cxa = -axc;

if axb*bxc > 0 && axb*axc > 0 || cxb*bxa > 0 && cxb*cxa > 0
    ex1 = a;
    ex2 = c;
elseif axc*cxb > 0 && axc*axb > 0 || bxc*cxa > 0 && bxc*bxa > 0
    ex1 = a;
    ex2 = b;
else
    ex1 = b;
    ex2 = c;
end
    


% if position1*position2 > 0 % b in the midle
%     ex1 = a;
%     ex2 = b;
% else
%     position1 = sign((a(1) - o(1))*(c(2) - o(2)) - (a(2) - o(2))*(c(1) - o(1)));
%     position2 = sign((c(1) - o(1))*(b(2) - o(2)) - (c(2) - o(2))*(b(1) - o(1)));
%     if position1*position2 > 0 % b in the midle
%         ex1 = a;
%         ex2 = c;
%     else
%         ex1 = b;
%         ex2 = c;
%     end
% end

end