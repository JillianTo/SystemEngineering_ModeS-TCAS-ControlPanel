clf;
positions = [30 40 14000; 35 45 13500; 60 80 10500];
id = 2; pos_i = positions(id, :);

figure('Name', 'TCAS Panel - Aircraft 2', 'NumberTitle', 'off');
uicontrol('Style', 'popupmenu', 'Position', [120 450 100 25], 'String', {'Stand-by', 'TA Only', 'Auto'});

ax = axes('Units', 'pixels', 'Position', [50, 150, 400, 250]);
axis([0 100 0 100]); hold on; title('Airspace Map');
xlabel('X (nmi)'); ylabel('Y (nmi)');

advisory = ''; 
for j = 1:3
    pos_j = positions(j,1:2); dz = pos_i(3) - positions(j,3);
    dist = norm(pos_i(1:2) - pos_j);

    if j == id
        fill([pos_j(1), pos_j(1)-1, pos_j(1)+1], [pos_j(2)+1.5, pos_j(2)-1, pos_j(2)-1], 'k');
    elseif dist < 15 && abs(dz) < 2000
        theta = linspace(0, 2*pi, 100);
        fill(pos_j(1) + cos(theta)*1.5, pos_j(2) + sin(theta)*1.5, 'y');
        text(pos_j(1)+2, pos_j(2), sprintf('%.1f ft', dist), 'Color', 'k');
        advisory = sprintf('TA %.1f nmi, %d ft', dist, dz);
    else
        plot([pos_j(1), pos_j(1)+1, pos_j(1), pos_j(1)-1, pos_j(1)], ...
             [pos_j(2)+1, pos_j(2), pos_j(2)-1, pos_j(2), pos_j(2)+1], 'k-', 'LineWidth', 1.5);
    end
end

uicontrol('Style', 'text', 'Position', [20 100 400 30], 'String', 'Advisory:', 'FontWeight', 'bold');
uicontrol('Style', 'edit', 'Position', [20 50 400 50], 'String', advisory, 'Enable', 'inactive');
