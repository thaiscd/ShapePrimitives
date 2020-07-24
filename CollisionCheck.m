function [bool, Q] = CollisionCheck(r, t, origin, obs)

% Goal -> check if there is collision between pose defined by joint angles
% t and desing r and obstacles

% INPUTS:

% r: vector (1 x nL)- link lengths
% t: vector (1 x nL)- joint angles defining pose
% origin: vector (1 x 2)- coordinates of origin of manipulator
% obs: matrix (# of obstacles x 3)- (x_center, y_center, radius)

% OUTPUTS:

% bool: boolean- 1 if there is collision and 0 if there isn't
% Q: matrix ((nL + 1) x 2): coordinates of each module's center and
% end-efector

P = FK(r, t, origin);
Q = P(end,:);
[np, ~] = size(P);
[nobs, ~] = size(obs);

bool = 0;

for i = 1:np-1
    p1 = P(i,:);
    p2 = P(i+1,:);
    for j = 1:nobs
        c = obs(j,1:2);
        r = obs(j,3);
        d1 = sqrt((p1(1) - c(1))^2 + (p1(2) - c(2))^2);
        d2 = sqrt((p2(1) - c(1))^2 + (p2(2) - c(2))^2);
        if d1 < r || d2 < r
            bool = 1;
            return
        else
            t = -dotproduct(c, p1, p1, p2)/dotproduct(p1, p2, p1, p2);
            if t >= 0 && t <= 1
                p_x = p1(1) + (p2(1) - p1(1))*t;
                p_y = p1(2) + (p2(2) - p1(2))*t;
                d = sqrt((p_x - c(1))^2 + (p_y - c(2))^2);
                if d < r
                    bool = 1;
                    return
                end
            end
        end
    end
end

end
