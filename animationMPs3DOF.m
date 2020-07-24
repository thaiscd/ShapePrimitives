function [] = animationMPs3DOF(origin, config, MPs, Obs, t)
    
a = [0 0 0];
r = config(1,:);
[n, ~] = size(t);
[nMPs, ~] = size(MPs);

if ~isempty(Obs)
    viscircles(Obs(:,1:2), Obs(:,3), 'Color', [0.6350, 0.0780, 0.1840], 'Linewidth', 3);
    hold on;
end
% patch(p1(:,1),p1(:,2),[.7 .7 .7]);
hold on;
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
P2 = [P0(1) + r(1)*cos(t(1,1)) + r(2)*cos(t(1,1))*cos(t(1,2)) - r(2)*cos(a(1))*sin(t(1,1))*sin(t(1,2)),...
    P0(2) + r(1)*sin(t(1,1)) + r(2)*cos(t(1,2))*sin(t(1,1)) + r(2)*cos(a(1))*cos(t(1,1))*sin(t(1,2))];
P3 = [P0(1) + r(1)*cos(t(1,1)) + r(3)*cos(t(1,3))*(cos(t(1,1))*cos(t(1,2)) - cos(a(1))*sin(t(1,1))*sin(t(1,2))) + r(2)*cos(t(1,1))*cos(t(1,2)) - r(3)*sin(t(1,3))*(cos(a(2))*cos(t(1,1))*sin(t(1,2)) + cos(a(1))*cos(a(2))*cos(t(1,2))*sin(t(1,1))) - r(2)*cos(a(1))*sin(t(1,1))*sin(t(1,2)),...
    P0(2) + r(1)*sin(t(1,1)) + r(3)*cos(t(1,3))*(cos(t(1,2))*sin(t(1,1)) + cos(a(1))*cos(t(1,1))*sin(t(1,2))) - r(3)*sin(t(1,3))*(cos(a(2))*sin(t(1,1))*sin(t(1,2)) - cos(a(1))*cos(a(2))*cos(t(1,1))*cos(t(1,2))) + r(2)*cos(t(1,2))*sin(t(1,1)) + r(2)*cos(a(1))*cos(t(1,1))*sin(t(1,2))];

EF = zeros(n,2);
for j = 1:n
    P3 = [P0(1) + r(1)*cos(t(j,1)) + r(3)*cos(t(j,3))*(cos(t(j,1))*cos(t(j,2)) - cos(a(1))*sin(t(j,1))*sin(t(j,2))) + r(2)*cos(t(j,1))*cos(t(j,2)) - r(3)*sin(t(j,3))*(cos(a(2))*cos(t(j,1))*sin(t(j,2)) + cos(a(1))*cos(a(2))*cos(t(j,2))*sin(t(j,1))) - r(2)*cos(a(1))*sin(t(j,1))*sin(t(j,2)),...
    P0(2) + r(1)*sin(t(j,1)) + r(3)*cos(t(j,3))*(cos(t(j,2))*sin(t(j,1)) + cos(a(1))*cos(t(j,1))*sin(t(j,2))) - r(3)*sin(t(j,3))*(cos(a(2))*sin(t(j,1))*sin(t(j,2)) - cos(a(1))*cos(a(2))*cos(t(j,1))*cos(t(j,2))) + r(2)*cos(t(j,2))*sin(t(j,1)) + r(2)*cos(a(1))*cos(t(j,1))*sin(t(j,2))];
    EF(j,1) = P3(1);
    EF(j,2) = P3(2);
end
h1 = plot([P0(1) P1(1)], [P0(2), P1(2)], '-','Color',[0 0 0],'LineWidth', 4); % link
hold on;
h2 = plot([P1(1) P2(1)], [P1(2), P2(2)], '-','Color',[0 0 0],'LineWidth', 4); % link
hold on;
h3 = plot([P2(1) P3(1)], [P2(2), P3(2)], '-','Color',[0 0 0],'LineWidth', 4); % link
hold on;
h5 = plot([P0(1) P1(1) P2(1)], [P0(2) P1(2) P2(2)], 'o','MarkerEdgeColor','r',...
    'MarkerFaceColor','r',...
    'MarkerSize',4);
hold on;
grid on;
j = 1;
% pause(9);
while j <= n   
    P0 = origin;
    P1 = [P0(1) + r(1)*cos(t(j,1)), P0(2) + r(1)*sin(t(j,1))];
    P2 = [P0(1) + r(1)*cos(t(j,1)) + r(2)*cos(t(j,1))*cos(t(j,2)) - r(2)*cos(a(1))*sin(t(j,1))*sin(t(j,2)),...
        P0(2) + r(1)*sin(t(j,1)) + r(2)*cos(t(j,2))*sin(t(j,1)) + r(2)*cos(a(1))*cos(t(j,1))*sin(t(j,2))];
    P3 = [P0(1) + r(1)*cos(t(j,1)) + r(3)*cos(t(j,3))*(cos(t(j,1))*cos(t(j,2)) - cos(a(1))*sin(t(j,1))*sin(t(j,2))) + r(2)*cos(t(j,1))*cos(t(j,2)) - r(3)*sin(t(j,3))*(cos(a(2))*cos(t(j,1))*sin(t(j,2)) + cos(a(1))*cos(a(2))*cos(t(j,2))*sin(t(j,1))) - r(2)*cos(a(1))*sin(t(j,1))*sin(t(j,2)),...
        P0(2) + r(1)*sin(t(j,1)) + r(3)*cos(t(j,3))*(cos(t(j,2))*sin(t(j,1)) + cos(a(1))*cos(t(j,1))*sin(t(j,2))) - r(3)*sin(t(j,3))*(cos(a(2))*sin(t(j,1))*sin(t(j,2)) - cos(a(1))*cos(a(2))*cos(t(j,1))*cos(t(j,2))) + r(2)*cos(t(j,2))*sin(t(j,1)) + r(2)*cos(a(1))*cos(t(j,1))*sin(t(j,2))];

    h1.XData = [P0(1), P1(1)];

    h1.YData = [P0(2), P1(2)];

    h2.XData = [P1(1), P2(1)];

    h2.YData = [P1(2), P2(2)];

    h3.XData = [P2(1), P3(1)];

    h3.YData = [P2(2), P3(2)];

    h5.XData = [P0(1), P1(1), P2(1)];

    h5.YData = [P0(2), P1(2), P2(2)];

    plot(EF(1:j,1), EF(1:j,2), '-','Color',[0 0 0.7],'LineWidth', 1);            
    hold on;
    grid on;
    axis equal;
    xlabel('x (m)');
    ylabel('y (m)');
    pause(.1);
    drawnow;
    j=j+1;
end

end