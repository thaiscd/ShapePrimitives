function [x, y] = sortPoints(x, y)

xCenter = mean(x);
yCenter = mean(y);

angles = atan2((y-yCenter),(x-xCenter));

[~, sortIndexes] = sort(angles);
x = x(sortIndexes);  % Reorder x and y with the new sort order.
y = y(sortIndexes);

end