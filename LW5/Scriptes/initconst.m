%% DPT 268214
% Variant 18
% DC motor parameters and calculations

clear;
clc;
close all;


%% 1. PASSPORT DATA

% Nominal armature voltage
U_nom = 24;                  % V

% Nominal rotational speed
n_nom_rpm = 8050;            % rpm

% No-load rotational speed
n_0_rpm = 8810;              % rpm

% Nominal torque
M_nom_mNm = 85.6;            % mN*m

% Armature resistance
R_a = 0.611;                 % Ohm

% Armature inductance
L_a_mH = 0.119;              % mH

% Torque constant
k_M_mNm_A = 25.9;            % mN*m/A

% Speed constant
k_n = 369;                   % rpm/V

% Total moment of inertia
J_g_cm2 = 33.5;              % g*cm^2


%% 2. CONVERSION TO SI UNITS

% Inductance
L_a = L_a_mH * 1e-3;         % H

% Torque constant
k_M = k_M_mNm_A * 1e-3;      % N*m/A

% Nominal torque
M_nom = M_nom_mNm * 1e-3;    % N*m

% Moment of inertia
J = J_g_cm2 * 1e-7;          % kg*m^2


%% 3. SPEED CONVERSION

% rpm -> rad/s

omega_nom = n_nom_rpm * 2*pi / 60;    % rad/s

omega_0 = n_0_rpm * 2*pi / 60;        % rad/s


%% 4. BACK EMF CONSTANT

% k_n = n / U
% k_e = E / omega
%
% k_e = 60 / (2*pi*k_n)

k_e = 1 / (k_n);        % V/(rad/s)


%% 5. CALCULATED NOMINAL CURRENT

% Steady-state equation:
%
% U = R_a*i + k_e*omega

I_nom_calc = (U_nom - k_e*omega_nom) / R_a;    % A


%% 6. CALCULATED NOMINAL TORQUE

% M = k_M*i

M_nom_calc = k_M * I_nom_calc;    % N*m


%% 7. REQUIRED SPEED

% According to the task:
%
% omega_task = (2/3)*omega_nom

n_task_rpm = (2/3) * n_nom_rpm;    % rpm

omega_task = (2/3) * omega_nom;    % rad/s


%% 8. BACK EMF AT REQUIRED SPEED

% E = k_e*omega

E_task = k_e * omega_task;          % V


%% 9. CURRENT AT REQUIRED SPEED

% U = R_a*i + E
%
% i = (U - E)/R_a

I_task = (U_nom - E_task) / R_a;    % A


%% 10. TORQUE AT REQUIRED SPEED

% M = k_M*i

M_task = k_M * I_task;              % N*m

% Conversion to mN*m
M_task_mNm = M_task * 1e3;           % mN*m





