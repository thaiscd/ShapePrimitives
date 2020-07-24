function [booltraj, theta] = TrajectoryCheckOver(n, MPs, Obs, o, a, r0, r1, r2, bl1, bl2, bc, ba1, ba2)
             
% GOAL: Calculate firt, second and third joint angles for full trajectory

% INPUTS:

%   n: integer - # of points in each motion primitive to calculate joint
%   angle
%   MPs: matrix (# shape primitives x 8): shape primitives
%   R0, R1, R2: link lengths
%   o: [1 x 2] -> origin of manipulator 
%   a: [# of shape primitives x 2] -> coordinates of end of first link for
%   each shape primitive
%   bl1: matrix [nlines x 2] -> cartesian position of the end of the first
%   link to reach pl1 for each line segment
%   bl2: matrix [nlines x 2] -> cartesian position of the end of the first
%   link to reach pl2 for each line segment
%   bc: matrix [ncircles x 2] -> cartesian position of the end of the first
%   link to reach pc for each circle
%   ba1: matrix [narcs x 2] -> cartesian position of the end of the first
%   link to reach pa1 for each arc
%   ba2: matrix [narcs x 2] -> cartesian position of the end of the first
%   link to reach pa2 for each arc

% OUTPUTS:
%   booltraj: 1 if there is trajectory without collision and 0 if there
%   isn't
%   theta: matrix [n x nL] -> joint angles 


[nMPs,~] = size(MPs);
theta_MP = []; 

il = 0;
ic = 0;
ia = 0;

for i = 1:nMPs
    bl1MP = [];
    bl2MP = [];
    bcMP = [];
    ba1MP = [];
    ba2MP = [];
    if MPs(i,1) == 1
        il = il + 1;
        bl1MP = bl1(il,:);
        bl2MP = bl2(il,:);
        thetaMP = FindThetasMPs3DOF_MP(r0, r1, r2, o, a(2*i-1:2*i)', bl1MP, bl2MP, bcMP, ba1MP, ba2MP, MPs(i,:), n);
        
    elseif MPs(i,1) == 0
        ic = ic + 1;
        bcMP = bc(ic,:);
        thetaMP = FindThetasMPs3DOF_MP(r0, r1, r2, o, a(2*i-1:2*i)', bl1MP, bl2MP, bcMP, ba1MP, ba2MP, MPs(i,:), n);
        
    else
        ia = ia + 1;
        ba1MP = ba1(ia,:);
        ba2MP = ba2(ia,:);
        thetaMP = FindThetasMPs3DOF_MP(r0, r1, r2, o, a(2*i-1:2*i)', bl1MP, bl2MP, bcMP, ba1MP, ba2MP, MPs(i,:), n);
        
    end
    theta_MP{i,1} = thetaMP;
end

if nMPs > 1
    theta = theta_MP{1,1};
    for i = 1:nMPs-1
        poseB = theta_MP{i,1}(end,:);
        poseE = theta_MP{i+1,1}(1,:);
        if poseB == poseE
            theta_trans = poseB;
            booltraj = 1;
        else
            [booltraj, theta_trans] = FindThetasMPs3DOF_trans(r0, r1, r2, o, poseB, poseE, Obs, n);
        end
        if booltraj == 1
            theta = [theta; theta_trans; theta_MP{i+1,1}];
        else
            theta =[];
            return;
        end

    end
else
    theta=thetaMP;
    booltraj=1;
end