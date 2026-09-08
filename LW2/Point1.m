my_excel_files = dir("./*.xlsx");



for i=1:length(my_excel_files)
    my_file_table = readtable(my_excel_files(i).name);
    
    time = my_file_table.time;
    position = my_file_table.position;
    velocity = my_file_table.velocity;

    f=figure;
    grid on;
    xlabel('Время, с');
    ylabel('Координата, м');
    hold on;
    plot(time , position, 'Color', 'r', 'LineStyle', '-', 'Marker', 'o', 'LineWidth', 1, 'DisplayName', 'Line1')
    exportgraphics(f, 'graphics.png', 'Resolution', 300);

    g=figure;
    grid on;
    xlabel('Время, с');
    ylabel('Скорость, м/c');
    hold on;
    plot(time , velocity, 'Color', 'b', 'LineStyle', '--', 'Marker', 'x', 'LineWidth', 1.5, 'DisplayName', 'Line2')
    exportgraphics(g, 'graphics1.png', 'Resolution', 300);
end

