function [tg_SP, tg_arm] = OuterTang(cc, r, o, l1)

tg_SP = [];
tg_arm = [];

if r > l1
    a = cc(1);
    b = cc(2);
    c = o(1);
    d = o(2);
    r0 = r;
    r1 = l1;
    xp = (c*r0 - a*r1)/(r0 - r1);
    yp = (d*r0 - b*r1)/(r0 - r1);
    if (xp - a)^2 + (yp - b)^2 - r0^2 >= 0
        xt1 = ((xp - a)*r0^2 + r0*(yp - b)*sqrt((xp - a)^2 + (yp - b)^2 - r0^2))/((xp - a)^2 + (yp - b)^2) + a;
        xt2 = ((xp - a)*r0^2 - r0*(yp - b)*sqrt((xp - a)^2 + (yp - b)^2 - r0^2))/((xp - a)^2 + (yp - b)^2) + a;
        yt1 = ((yp - b)*r0^2 - r0*(xp - a)*sqrt((xp - a)^2 + (yp - b)^2 - r0^2))/((xp - a)^2 + (yp - b)^2) + b;
        yt2 = ((yp - b)*r0^2 + r0*(xp - a)*sqrt((xp - a)^2 + (yp - b)^2 - r0^2))/((xp - a)^2 + (yp - b)^2) + b;
        tg_SP = [xt1, yt1; xt2, yt2];
    end
    if (xp - c)^2 + (yp - d)^2 - r1^2 >= 0
        xt3 = ((xp - c)*r1^2 + r1*(yp - d)*sqrt((xp - c)^2 + (yp - d)^2 - r1^2))/((xp - c)^2 + (yp - d)^2) + c;
        xt4 = ((xp - c)*r1^2 - r1*(yp - d)*sqrt((xp - c)^2 + (yp - d)^2 - r1^2))/((xp - c)^2 + (yp - d)^2) + c;   
        yt3 = ((yp - d)*r1^2 - r1*(xp - c)*sqrt((xp - c)^2 + (yp - d)^2 - r1^2))/((xp - c)^2 + (yp - d)^2) + d;   
        yt4 = ((yp - d)*r1^2 + r1*(xp - c)*sqrt((xp - c)^2 + (yp - d)^2 - r1^2))/((xp - c)^2 + (yp - d)^2) + d;    
        tg_arm = [xt3, yt3; xt4, yt4];
    end
else
    a = o(1);
    b = o(2);
    c = cc(1);
    d = cc(2);
    r0 = l1;
    r1 = r;
    xp = (c*r0 - a*r1)/(r0 - r1);
    yp = (d*r0 - b*r1)/(r0 - r1);
    if (xp - a)^2 + (yp - b)^2 - r0^2 >= 0
        xt1 = ((xp - a)*r0^2 + r0*(yp - b)*sqrt((xp - a)^2 + (yp - b)^2 - r0^2))/((xp - a)^2 + (yp - b)^2) + a;
        xt2 = ((xp - a)*r0^2 - r0*(yp - b)*sqrt((xp - a)^2 + (yp - b)^2 - r0^2))/((xp - a)^2 + (yp - b)^2) + a;
        yt1 = ((yp - b)*r0^2 - r0*(xp - a)*sqrt((xp - a)^2 + (yp - b)^2 - r0^2))/((xp - a)^2 + (yp - b)^2) + b;
        yt2 = ((yp - b)*r0^2 + r0*(xp - a)*sqrt((xp - a)^2 + (yp - b)^2 - r0^2))/((xp - a)^2 + (yp - b)^2) + b;
        tg_arm = [xt1, yt1; xt2, yt2];
    end
    if (xp - c)^2 + (yp - d)^2 - r1^2 >= 0
        xt3 = ((xp - c)*r1^2 + r1*(yp - d)*sqrt((xp - c)^2 + (yp - d)^2 - r1^2))/((xp - c)^2 + (yp - d)^2) + c;
        xt4 = ((xp - c)*r1^2 - r1*(yp - d)*sqrt((xp - c)^2 + (yp - d)^2 - r1^2))/((xp - c)^2 + (yp - d)^2) + c;   
        yt3 = ((yp - d)*r1^2 - r1*(xp - c)*sqrt((xp - c)^2 + (yp - d)^2 - r1^2))/((xp - c)^2 + (yp - d)^2) + d;   
        yt4 = ((yp - d)*r1^2 + r1*(xp - c)*sqrt((xp - c)^2 + (yp - d)^2 - r1^2))/((xp - c)^2 + (yp - d)^2) + d;    
        tg_SP = [xt3, yt3; xt4, yt4];
    end
end

end