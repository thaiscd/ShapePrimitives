function [] = animationMPs2DOF(r, MPs, t, origin, Obs)

a = [0 0];
[n, ~] = size(t);
[nMPs, ~] = size(MPs);

if ~isempty(Obs)
    [nobs, ~] = size(Obs);
    for i = 1:nobs
        th = linspace(0,2*pi,50);
        x = Obs(i,3)*cos(th) + Obs(i,1);
        y = Obs(i,3)*sin(th) + Obs(i,2);
        plot(x,y,'LineStyle', '-','Color','red','Linewidth', 3);
        hold on;
    end
end

for i = 1:nMPs    
    if MPs(i,1) == 1
        plot([MPs(i,2) MPs(i,4)], [MPs(i,3) MPs(i,5)],'Color', [0.5, 0.5, 0.5], 'Linewidth', 3);
        hold on;
    else
        
        plot(MPs(i,2), MPs(i,3), 'o', 'MarkerSize',5,...
            'MarkerEdgeColor',[0.5, 0.5, 0.5],...
            'MarkerFaceColor',[0.5, 0.5, 0.5]);
        hold on;
    end    
end

grid on;
hold on;   
P0 = origin;
P1 = [P0(1) + r(1)*cos(t(1,1)), P0(2) + r(1)*sin(t(1,1))];
P2n = [P0(1) + r(1)*cos(t(1,1)) + r(2)*cos(t(1,1))*cos(t(1,2)) - r(2)*cos(a(1))*sin(t(1,1))*sin(t(1,2)),...
    P0(2) + r(1)*sin(t(1,1)) + r(2)*cos(t(1,2))*sin(t(1,1)) + r(2)*cos(a(1))*cos(t(1,1))*sin(t(1,2))];
EF = zeros(n,2);
for j = 1:n
    P2 = [P0(1) + r(1)*cos(t(j,1)) + r(2)*cos(t(j,1))*cos(t(j,2)) - r(2)*cos(a(1))*sin(t(j,1))*sin(t(j,2)),...
    P0(2) + r(1)*sin(t(j,1)) + r(2)*cos(t(j,2))*sin(t(j,1)) + r(2)*cos(a(1))*cos(t(j,1))*sin(t(j,2))];
    EF(j,1) = P2(1);
    EF(j,2) = P2(2);
end

h1 = plot([P0(1) P1(1)], [P0(2), P1(2)], '-','Color',[0 0 0],'LineWidth', 4); % link
hold on;
h2 = plot([P1(1) P2n(1)], [P1(2), P2n(2)], '-','Color',[0 0 0],'LineWidth', 4); % link
hold on;

h5 = plot([P0(1) P1(1)], [P0(2) P1(2)], 'o','MarkerEdgeColor','r',...
    'MarkerFaceColor','r',...
    'MarkerSize',4);
hold on;
grid on;
j = 2;
while j <= n
    
    P0 = origin;
    P1 = [P0(1) + r(1)*cos(t(j,1)), P0(2) + r(1)*sin(t(j,1))];
    P2 = [P0(1) + r(1)*cos(t(j,1)) + r(2)*cos(t(j,1))*cos(t(j,2)) - r(2)*cos(a(1))*sin(t(j,1))*sin(t(j,2)),...
        P0(2) + r(1)*sin(t(j,1)) + r(2)*cos(t(j,2))*sin(t(j,1)) + r(2)*cos(a(1))*cos(t(j,1))*sin(t(j,2))];

    h1.XData = [P0(1), P1(1)];

    h1.YData = [P0(2), P1(2)];

    h2.XData = [P1(1), P2(1)];

    h2.YData = [P1(2), P2(2)];

    h5.XData = [P0(1), P1(1)];

    h5.YData = [P0(2), P1(2)];    

    plot(EF(1:j,1), EF(1:j,2), '-','Color',[0 0 0.7],'LineWidth', 1);
    hold on;
    grid on;
    axis equal;
    pause(.1);
    drawnow;
    j=j+1;
end