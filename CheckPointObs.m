function [bool] = CheckPointObs(p, Obs)

% Goal -> check if point p is inside any obstacle

% INPUTS:

% p: vector (1 x 2)- coordinates of point
% Obs: matrix (# of obstacles x 3)- (x_center, y_center, radius)

% OUTPUTS:

% bool: boolean- 1 if point is inside and 0 if it isn't

bool = 0;
[nobs, ~] = size(Obs);

for i = 1:nobs
    c = Obs(i,1:2);
    r = Obs(i,3);
    dist = sqrt((c(1) - p(1))^2 + (c(2) - p(2))^2);
    if dist < r
        bool = 1;
        return;
    end
end

end