% Andrei Leonard Nicusan, 2019
% University of Birmingham
% Chemical Engineering, 2nd year

% Base script for the simulation
% of the buffer_silo.mdl
% simulink file

% The mathematical derivation
% of the model used is in the
% "Buffer_Silo_Control.pdf"
% paper

clear; clc;

% Granular fluid properties
rho = 700;                      % kg/m3
AT = 4;                         % m2
AB = 0.05;                      % m2
beta = 46.5;                    % (kg/s)/m


% Height transform
Kh = 1.4;                       % mA/m


% Process
taup = rho * AT / beta;         % s
Kp = 1/beta;                    % m/(kg/s)


% Sensor (weighing scale)
taum = 0.5;                     % s
Km = 0.185;                     % mA / (kg/s)
tdelay = 1;                     % s
noiseamp = 0.1;                 % noise amplitude
comp = 1;                       % compression gain (1 = no compression)


% Chute Final Control Element (FCE)
Kep_1 = 2;                      % psi / mA
Kc = 2;                         % kg / psi
tauc = 25;                      % s


% Diverter Valve Final Control Element (FCE)
Kep_2 = 2;                      % psi / mA
Kd = 8;                         % kg / psi
taud = 25;                      % s


% PID controllers
% K ultimate: inf, 260 // 200, 200
% final tuning: 2.2 , 0.065 , 15 // 7 , 0.1 , 14
Kp1 = 2.2;
Ki1 = 0.065;
Kd1 = 15;

Kp2 = 7;
Ki2 = 0.1;
Kd2 = 14;


% Step change in disturbance MT
MT_step = 1;

% Sinusoidal change in disturbance MT
MT_amp = 0;
MT_freq = 0.08;

% Step change in mass outflow Mo
Mo_step = 0;

% Step change in height h
H_step = 0;

% Run the Simulink model
sim('buffer_silo');


% Plotting
time = Mo_star_out.Time / taup;

Mo_step = Mo_star_out.Data / MT_step;
H_step = H_star_out.Data / MT_step / Kp;

figure;

subplot(1,2,1);
plot(time, Mo_step);
grid on
xlabel('Dimensionless Time');
ylabel('Dimensionless mo*');

subplot(1,2,2);
plot(time, H_step);
grid on
xlabel('Dimensionless Time');
ylabel('Dimensionless h*');


% Analysis
info_mo_step = stepinfo(Mo_step, time)
info_h_step = stepinfo(H_step, time)


