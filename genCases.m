function [MPs, Obs, OC] = genCases()
%% generating MPs
n1 = -.4;
n2 = .4;
nMP = randi([3,6]);
types = [-2,0,1,2];

MPs = zeros(nMP,8);

for i = 1:nMP
    type = randi(4);
    MPs(i,1) = types(type);
    if type == 1 || type == 4 % arc
        if i == 1
            MPs(i,4:7) = n1 + (n2-n1)*rand(1,4);
            p1 = MPs(i,4:5);
            p2 = MPs(i,6:7);
            dist = sqrt((p2(1)-p1(1))^2 + (p2(2)-p1(2))^2);
            MPs(i,8) = .5 + (pi - .5)*rand(1,1);
            alpha = MPs(i,8);
            r = dist/(2*sin(alpha/2));
            pm = (p1 + p2)/2; 
            A = pm(2) + pm(1)*(p2(1) - p1(1))/(p2(2) - p1(2));
            B = (-p2(1) + p1(1))/(p2(2) - p1(2));
            a = B^2 + 1;
            b = 2*A*B - 2*B*p1(2) - 2*p1(1);
            d = (A - p1(2))^2 + p1(1)^2 - r^2;
            cx = (-b + sqrt(b^2 - 4*a*d))/(2*a);
            cy = A + B*cx;
            MPs(i,2:3) = [cx cy];
        else
            if MPs(i-1,1) == 1
                MPs(i,4:5) = MPs(i-1,4:5);
            elseif MPs(i-1,1) == 0
                MPs(i,4:5) = MPs(i-1,5:6);
            else
                MPs(i,4:5) = MPs(i-1,6:7);
            end
            p1 = MPs(i,4:5);
            p2 = n1 + (n2-n1)*rand(1,2);
            MPs(i,6:7) = p2;
            dist = sqrt((p2(1)-p1(1))^2 + (p2(2)-p1(2))^2);
            MPs(i,8) = .5 + (pi - .5)*rand(1,1);
            alpha = MPs(i,8);
            r = dist/(2*sin(alpha/2));
            pm = (p1 + p2)/2; 
            A = pm(2) + pm(1)*(p2(1) - p1(1))/(p2(2) - p1(2));
            B = (-p2(1) + p1(1))/(p2(2) - p1(2));
            a = B^2 + 1;
            b = 2*A*B - 2*B*p1(2) - 2*p1(1);
            d = (A - p1(2))^2 + p1(1)^2 - r^2;
            cx = (-b + sqrt(b^2 - 4*a*d))/(2*a);
            cy = A + B*cx;
            MPs(i,2:3) = [cx cy];
        end     
    elseif type == 2 %circle
        if i == 1
            MPs(i,2:3) = n1 + (n2-n1)*rand(1,2);
            MPs(i,5:6) = n1 + (n2-n1)*rand(1,2);
        else
            MPs(i,2:3) = n1 + (n2-n1)*rand(1,2);
            if MPs(i-1,1) == 1
                MPs(i,5:6) = MPs(i-1,4:5);
            elseif MPs(i-1,1) == 0
                MPs(i,5:6) = MPs(i-1,5:6);
            else
                MPs(i,5:6) = MPs(i-1,6:7);
            end
        end
        MPs(i,4) = sqrt((MPs(i,2) - MPs(i,5))^2 + (MPs(i,3) - MPs(i,6))^2);
    else
        if i == 1
            MPs(i,2:5) = n1 + (n2-n1)*rand(1,4);
        else
            MPs(i,4:5) = n1 + (n2-n1)*rand(1,2);
            if MPs(i-1,1) == 1
                MPs(i,2:3) = MPs(i-1,4:5);
            elseif MPs(i-1,1) == 0
                MPs(i,2:3) = MPs(i-1,5:6);
            else
                MPs(i,2:3) = MPs(i-1,6:7);
            end
        end
    end
end

MPs = real(MPs);

%% generating obstacles

nobs = randi([1,4]);
Obs = zeros(nobs,3);
nmp = nMP;

m1 = 0.2;
m2 = 0.5;
eps = 0.05;

i = 0;
iter = 0;
while i ~= nobs && iter < 10e4
    iter = iter + 1;
    c = n1 + (n2-n1)*rand(1,2);
    r = m1 + (m2-m1)*rand(1,1);
    bools = zeros(1,nmp);
    for j = 1:nmp
        if MPs(j,1) == 0
            dist = sqrt((c(1) - MPs(j,2))^2 + (c(2) - MPs(j,3))^2);
            if dist < MPs(j,4) + r +eps
                bools(j) = 1;
                break;
            end
        elseif MPs(j,1) == 1
            dist = dist_line_point(MPs(j,2:3), MPs(j,4:5), c);
            if dist < r + eps
                bools(j) = 1;
                break;
            end
        else
            rmp = sqrt((MPs(j,2) - MPs(j,4))^2 + (MPs(j,3) - MPs(j,5))^2);
            dist = sqrt((c(1) - MPs(j,2))^2 + (c(2) - MPs(j,3))^2);
            if dist < r + rmp + eps
                bools(j) = 1;
                break;
            end
        end
    end
    if sum(bools) == 0
        i = i + 1;
        Obs(i,:) = [c, r];
    end
end

n1OC = -1;
n2OC = 1;

OC = [];

iter1 = 0;

bool = 0;
noc = 0;
while iter1 < 10e4 && noc < 4
    iter1 = iter1 + 1;
    boc = 0;
    while boc == 0
        max_x_OC = n1OC + (n2OC - n1OC)*rand(1,1);
        min_x_OC = n1OC + (max_x_OC - n1OC)*rand(1,1);
        max_y_OC = n1OC + (n2OC - n1OC)*rand(1,1);
        min_y_OC = n1OC + (max_y_OC - n1OC)*rand(1,1);
        if max_x_OC > min_x_OC && max_y_OC > min_y_OC 
            boc = 1;
        end
    end

    for j = 1:nmp
        if MPs(j,1) == 0
            dist1 = dist_line_point([min_x_OC min_y_OC], [min_x_OC max_y_OC], MPs(j,2:3));
            dist2 = dist_line_point([min_x_OC max_y_OC], [max_x_OC max_y_OC], MPs(j,2:3));
            dist3 = dist_line_point([max_x_OC max_y_OC], [max_x_OC min_y_OC], MPs(j,2:3));
            dist4 = dist_line_point([max_x_OC min_y_OC], [min_x_OC min_y_OC], MPs(j,2:3));
            dist = min([dist1, dist2, dist3, dist4]);
            if dist < MPs(j,4)
                bool = bool + 1;
            end
        elseif MPs(j,1) == 1
            b1 = intersect2lines(MPs(j,2:3), MPs(j,4:5), [min_x_OC min_y_OC], [min_x_OC max_y_OC]);
            b2 = intersect2lines(MPs(j,2:3), MPs(j,4:5), [min_x_OC max_y_OC], [max_x_OC max_y_OC]);
            b3 = intersect2lines(MPs(j,2:3), MPs(j,4:5), [max_x_OC max_y_OC], [max_x_OC min_y_OC]);
            b4 = intersect2lines(MPs(j,2:3), MPs(j,4:5), [max_x_OC min_y_OC], [min_x_OC min_y_OC]);
            bool = bool + b1 + b2 + b3 + b4;
            if (MPs(j,2) > min_x_OC && MPs(j,2) < max_x_OC && MPs(j,3) > min_y_OC && MPs(j,3) < max_y_OC)
                bool = bool + 1;
            end
            if (MPs(j,4) > min_x_OC && MPs(j,4) < max_x_OC && MPs(j,5) > min_y_OC && MPs(j,5) < max_y_OC)
                bool = bool + 1;
            end
        else
            dist1 = dist_line_point([min_x_OC min_y_OC], [min_x_OC max_y_OC], MPs(j,2:3));
            dist2 = dist_line_point([min_x_OC max_y_OC], [max_x_OC max_y_OC], MPs(j,2:3));
            dist3 = dist_line_point([max_x_OC max_y_OC], [max_x_OC min_y_OC], MPs(j,2:3));
            dist4 = dist_line_point([max_x_OC min_y_OC], [min_x_OC min_y_OC], MPs(j,2:3));
            dist = min([dist1, dist2, dist3, dist4]);
            if dist < sqrt((MPs(j,2)-MPs(j,4))^2 + (MPs(j,3)-MPs(j,5))^2)
                bool = bool + 1;
            end
        end        
    end        
    if  bool == 0
        noc = noc + 1;
        OC = [OC; min_x_OC, min_y_OC, max_x_OC, max_y_OC];
    end
end


if iter == 10e4 || iter1 == 10e4
    MPs = [];
    Obs = [];
    OC = [];
else
%     plotMPs(MPs, Obs, OC);
end
        
end


