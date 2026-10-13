%% БФС ДРК: Матрица в явном виде и моделирование распределения упоров
clear; clc; close all;

%% 1. Геометрические параметры (Рис. 2)
Lx = 0.40;             % Плечо по оси X, м
Lz = 0.30;             % Плечо по оси Z, м
alpha = deg2rad(45.0); % Угол установки маршево-лаговых движителей

c = cos(alpha);
s = sin(alpha);

%% 2. Матрица конфигурации B (6 x 8) в явном виде
%  Строки v: [Fx; Fy; Fz; Mx; My; Mz]
%  Столбцы u: [МПЛ; МПП; МЗЛ; МЗП; ВПЛ; ВПП; ВЗЛ; ВЗП]
B = [
    % МПЛ              МПП             МЗЛ              МЗП          ВПЛ   ВПП   ВЗЛ   ВЗП
       c,               c,              c,               c,           0,    0,    0,    0;   % Fx
       0,               0,              0,               0,           1,    1,    1,    1;   % Fy
      s,               -s,             -s,               s,           0,    0,    0,    0;   % Fz
       0,               0,              0,               0,        Lz,   -Lz,  -Lz,   Lz;   % Mx
  (-Lz*c + Lx*s),  (Lz*c - Lx*s), (-Lz*c - Lx*s),  (Lz*c + Lx*s),     0,    0,    0,    0;   % My
       0,               0,              0,               0,        Lx,  Lx,  - Lx,  - Lx    % Mz
];

% Псевдообратная матрица Мура-Пенроуза: B^+ = B' * inv(B * B')
B_pinv = pinv(B);

%% 3. Параметры нелинейностей (Рис. 1, Рис. 3)
u_deadzone = 0.5;    % Порог нечувствительности, Н
u_max = 40.0;        % Максимальный упор одного движителя, Н
limit_mode = 'clip'; % 'clip' - обрезка (насыщение), 'scale' - масштабирование

%% 4. Временное моделирование
t = linspace(0, 12, 1000);
N = length(t);

u_lin_hist = zeros(8, N);
u_act_hist = zeros(8, N);

for k = 1:N
    tk = t(k);
    
    % Вектор требуемых сил и моментов v
    Fx = 35.0;
    Fy = 0 ;
    Fz = 0;
    Mx = 0;
    My = 0;
    Mz = 0;
    
    v = [Fx; Fy; Fz; Mx; My; Mz];
    
    % Шаг 1: Линейное распределение через псевдообратную матрицу
    u_lin = B_pinv * v;
    u_lin_hist(:, k) = u_lin;
    
    % Шаг 2: Учет зоны нечувствительности (Dead Zone)
    u_dz = sign(u_lin) .* max(0, abs(u_lin) - u_deadzone);
    
    % Шаг 3: Ограничение упоров движителей (Saturation / Scaling)
    if strcmp(limit_mode, 'clip')
        u_act = min(max(u_dz, -u_max), u_max);
    elseif strcmp(limit_mode, 'scale')
        max_val = max(abs(u_dz));
        if max_val > u_max
            u_act = u_dz * (u_max / max_val);
        else
            u_act = u_dz;
        end
    end
    
    u_act_hist(:, k) = u_act;
end

%% 5. Визуализация результатов
thruster_labels = {'МПЛ', 'МПП', 'МЗЛ', 'МЗП', 'ВПЛ', 'ВПП', 'ВЗЛ', 'ВЗП'};

figure('Name', 'БФС ДРК: Распределение упоров движителей', ...
       'Color', 'w', 'Units', 'normalized', 'Position', [0.08, 0.05, 0.84, 0.88]);

for i = 1:8
    subplot(4, 2, i);
    hold on; grid on; box on;
    
    plot(t, u_lin_hist(i, :), '--', 'Color', [0.55, 0.55, 0.55], 'LineWidth', 1.0, ...
        'DisplayName', 'B^+ \cdot v');
    plot(t, u_act_hist(i, :), '-', 'Color', [0.00, 0.45, 0.74], 'LineWidth', 1.6, ...
        'DisplayName', 'Выход БФС');
    
    yline(u_max, ':r', 'LineWidth', 1.2, 'DisplayName', '\pm U_{max}');
    yline(-u_max, ':r', 'LineWidth', 1.2, 'HandleVisibility', 'off');
    
    title(['Движитель: ', thruster_labels{i}], 'FontSize', 10, 'FontWeight', 'bold');
    ylabel('Упор, Н', 'FontSize', 9);
    ylim([-u_max * 1.35, u_max * 1.35]);
    
    if i == 1
        legend('Location', 'northeast', 'FontSize', 8);
    end
    if i >= 7
        xlabel('Время t, с', 'FontSize', 9);
    end
end

sgtitle('Моделирование БФС ДРК (8 движителей, матрица B в явном виде)', ...
        'FontSize', 12, 'FontWeight', 'bold');