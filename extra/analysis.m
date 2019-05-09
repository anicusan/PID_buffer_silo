% Andrei Leonard Nicusan, 2019
% University of Birmingham
% Chemical Engineering, 2nd year

% Script for the analysis
% of the buffer_silo_deadtime.mdl
% and buffer_silo_measure.mdl
% simulink files

% The mathematical derivation
% of the model used is in the
% "Buffer_Silo_Control.pdf"
% paper

clear; clc;

rho = 700;                      % kg/m3
AT = 4;                         % m2
AB = 0.05;                      % m2
beta = 46.5;                    % (kg/s)/m
%hs = 1;                        % m


% Height transform
Kh = 1.4;                       % mA/m


% process
taup = rho * AT / beta;         % s
Kp = 1/beta;                    % m/(kg/s)


% sensor (weighing scale)
taum = 0.5;                     % s
Km = 0.185;                     % mA / (kg/s)
tdelay = 1;                     % s
noiseamp = 0.00000001;          % noise amplitude
comp = 1;                       % compression gain (1 = no compression)


% chute
Kep_1 = 2;                      % psi / mA
Kc = 2;                         % kg / psi
tauc = 25;                      % s


% diverter
Kep_2 = 2;                      % psi / mA
Kd = 8;                         % kg / psi
taud = 25;                      % s


% PID controllers
% stable: 0.001 ; 0.01
% hand-tuned: 20, 0.1 ; 10, 1
% hand-tuned: 2.4 ; 0.08 ; 21.7 / 1.1
% K ultimate: inf, 260 // 200, 200
% final tuning: 2.2 , 0.065 , 15 // 7 , 0.1 , 14
Kp1 = 2.2;
Ki1 = 0.065;
Kd1 = 15;

Kp2 = 7;
Ki2 = 0.1;
Kd2 = 14;

% sim('buffer_silo_deadtime');


%%

% Open-loop response

% Step change in disturbance MT
Kp1 = 0;
Ki1 = 0;
Kd1 = 0;

Kp2 = 0;
Ki2 = 0;
Kd2 = 0;

MT_step = 1;
MT_amp = 0;
MT_freq = 0.08;

Mo_step = 0;
H_step = 0;

sim('buffer_silo_deadtime');

time = Mo_star_out.Time / taup;

Mo_OL_step = Mo_star_out.Data / MT_step;
H_OL_step = H_star_out.Data / MT_step / Kp;

% Sinusoidal change in MT
MT_step = 0;
MT_amp = 1;
MT_freq = 0.08;

sim('buffer_silo_deadtime');

time2 = Mo_star_out.Time / taup;

Mo_OL_sin = Mo_star_out.Data / MT_amp;
H_OL_sin = H_star_out.Data / MT_amp / Kp; 


figure('position', [0, 0, 400, 400]);

subplot(2,2,1);
plot(time, Mo_OL_step);
grid on
xlabel('Dimensionless Time');
ylabel('Dimensionless mo*');

subplot(2,2,2);
plot(time, H_OL_step);
grid on
xlabel('Dimensionless Time');
ylabel('Dimensionless h*');


subplot(2,2,3);
plot(time2, Mo_OL_sin);
grid on
xlabel('Dimensionless Time');
ylabel('Dimensionless mo*');

subplot(2,2,4);
plot(time2, H_OL_sin);
grid on
xlabel('Dimensionless Time');
ylabel('Dimensionless h*');




%%

% Closed-loop response

Kp1 = 2.2;
Ki1 = 0.065;
Kd1 = 15;

Kp2 = 7;
Ki2 = 0.1;
Kd2 = 14;

% Step change in disturbance MT

MT_step = 1;
MT_amp = 0;
MT_freq = 0.08;

Mo_step = 0;
H_step = 0;

sim('buffer_silo_deadtime');

time = Mo_star_out.Time / taup;

Mo_OL_step = Mo_star_out.Data / MT_step;
H_OL_step = H_star_out.Data / MT_step / Kp;

% Sinusoidal change in MT
MT_step = 0;
MT_amp = 1;
MT_freq = 0.08;

sim('buffer_silo_deadtime');

time2 = Mo_star_out.Time / taup;

Mo_OL_sin = Mo_star_out.Data / MT_amp;
H_OL_sin = H_star_out.Data / MT_amp / Kp; 


figure('position', [0, 0, 400, 400]);

subplot(2,2,1);
plot(time, Mo_OL_step);
grid on
xlabel('Dimensionless Time');
ylabel('Dimensionless mo*');

subplot(2,2,2);
plot(time, H_OL_step);
grid on
xlabel('Dimensionless Time');
ylabel('Dimensionless h*');


subplot(2,2,3);
plot(time2, Mo_OL_sin);
grid on
xlabel('Dimensionless Time');
ylabel('Dimensionless mo*');

subplot(2,2,4);
plot(time2, H_OL_sin);
grid on
xlabel('Dimensionless Time');
ylabel('Dimensionless h*');


info_mo_step = stepinfo(Mo_OL_step, time)
info_h_step = stepinfo(H_OL_step, time)

info_mo_sin = stepinfo(Mo_OL_sin, time2)
info_h_sin = stepinfo(H_OL_sin, time2)




%% Step change in set points of Mo* and H*

% Step change in Mo*

MT_step = 0;
MT_amp = 0;
MT_freq = 0.08;

Mo_step = 1;
H_step = 0;

sim('buffer_silo_deadtime');

time = Mo_star_out.Time / taup;

Mo_CL_stepm = Mo_star_out.Data / Mo_step;
H_CL_stepm = H_star_out.Data / Mo_step / Kp;

% Step change in H*
Mo_step = 0;
H_step = 1;

sim('buffer_silo_deadtime');

time2 = Mo_star_out.Time / taup;

Mo_CL_steph = Mo_star_out.Data;
H_CL_steph = H_star_out.Data; 


figure('position', [0, 0, 400, 400]);

subplot(2,2,1);
plot(time, Mo_CL_stepm);
grid on
xlabel('Dimensionless Time');
ylabel('Dimensionless mo*');

subplot(2,2,2);
plot(time, H_CL_stepm);
grid on
xlabel('Dimensionless Time');
ylabel('Dimensionless h*');


subplot(2,2,3);
plot(time2, Mo_CL_steph);
grid on
xlabel('Dimensionless Time');
ylabel('mo* (kg/s)');

subplot(2,2,4);
plot(time2, H_CL_steph);
grid on
xlabel('Dimensionless Time');
ylabel('h* (m)');


info_mo_stepm = stepinfo(Mo_CL_stepm, time)
info_h_stepm = stepinfo(H_CL_stepm, time)

info_mo_steph = stepinfo(Mo_CL_steph, time2)
info_h_steph = stepinfo(H_CL_steph, time2)


%% Time delay analysis

tdelay = 8;

MT_step = 1;
MT_amp = 0;
MT_freq = 0.08;

Mo_step = 0;
H_step = 0;

sim('buffer_silo_deadtime');

time = Mo_star_out.Time / taup;

Mo_CL_step = Mo_star_out.Data / MT_step;
H_CL_step = H_star_out.Data / MT_step / Kp;


tdelay = 16;

sim('buffer_silo_deadtime');

time2 = Mo_star_out.Time / taup;

Mo_CL_step2 = Mo_star_out.Data;
H_CL_step2 = H_star_out.Data; 


figure('position', [0, 0, 400, 400]);

subplot(2,2,1);
plot(time, Mo_CL_step);
grid on
xlabel('Dimensionless Time');
ylabel('Dimensionless mo*');

subplot(2,2,2);
plot(time, H_CL_step);
grid on
xlabel('Dimensionless Time');
ylabel('Dimensionless h*');


subplot(2,2,3);
plot(time2, Mo_CL_step2);
grid on
xlabel('Dimensionless Time');
ylabel('Dimensionless mo*');

subplot(2,2,4);
plot(time2, H_CL_step2);
grid on
xlabel('Dimensionless Time');
ylabel('Dimensionless h*');



info_mo_step8 = stepinfo(Mo_CL_step, time)
info_h_step8 = stepinfo(H_CL_step, time)

info_mo_step16 = stepinfo(Mo_CL_step2, time2)
info_h_step16 = stepinfo(H_CL_step2, time2)


%% Height inferring system

tdelay = 1;
noiseamp = 0.0000001;

MT_step = 1;
MT_amp = 0;
MT_freq = 0.08;

Mo_step = 0;
H_step = 0;

sim('buffer_silo_deadtime');

time = H_star_out.Time / taup;
time2 = Mo_star_out.Time / taup;

H_CL_step = H_star_out.Data / MT_step / Kp;
Hinf_CL_step = Inferred_H_out.Data / MT_step / Kp; 

info_h_step = stepinfo(H_CL_step, time)
info_hinf_step = stepinfo(Hinf_CL_step, time2)


figure('position', [0, 0, 600, 200]);

subplot(1,3,1);
plot(time, H_CL_step, time2, Hinf_CL_step);
grid on
legend('Real h','Inferred h');
xlabel('Dimensionless Time');
ylabel('Dimensionless h*');


MT_step = 0;
MT_amp = 1;
MT_freq = 0.08;

Mo_step = 0;
H_step = 0;

sim('buffer_silo_deadtime');

time = H_star_out.Time / taup;
time2 = Mo_star_out.Time / taup;

H_CL_step = H_star_out.Data / MT_amp / Kp;
Hinf_CL_step = Inferred_H_out.Data / MT_amp / Kp; 

info_h_step = stepinfo(H_CL_step, time)
info_hinf_step = stepinfo(Hinf_CL_step, time2)


subplot(1,3,2);
plot(time, H_CL_step, time2, Hinf_CL_step);
grid on
legend('Real h','Inferred h');
xlabel('Dimensionless Time');
ylabel('Dimensionless h*');



noiseamp = 1;

MT_step = 0;
MT_amp = 0;
MT_freq = 0.08;

Mo_step = 0;
H_step = 0;

sim('buffer_silo_deadtime');

time = H_star_out.Time / taup;
time2 = Mo_star_out.Time / taup;

H_CL_step = H_star_out.Data / noiseamp / Kp;
Hinf_CL_step = Inferred_H_out.Data / noiseamp / Kp; 


subplot(1,3,3);
plot(time, H_CL_step, 'Color', [0, 0.4470, 0.7410], 'Marker' , 'none');
hold on
plot(time2(Hinf_CL_step > 0.04), Hinf_CL_step(Hinf_CL_step > 0.04), 'Color' , [0.8500, 0.3250, 0.0980], 'Marker' , 'none');
plot(time2(Hinf_CL_step < -0.04), Hinf_CL_step(Hinf_CL_step < -0.04), 'Color' , [0.8500, 0.3250, 0.0980], 'Marker' , 'none');
grid on
legend('Real h','Inferred h');
xlabel('Dimensionless Time');
ylabel('Dimensionless h*');



tdelay = 1;
noiseamp = 0.0000001;

MT_step = 1;
MT_amp = 0;
MT_freq = 0.08;

Mo_step = 0;
H_step = 0;

sim('buffer_silo_measure');

time = H_star_out.Time / taup;
time2 = H_star_out.Time / taup;

H_CL_step = H_star_out.Data / MT_step / Kp;
Hinf_CL_step = Inferred_H_out.Data / MT_step / Kp; 

info_h_step = stepinfo(H_CL_step, time)
info_hinf_step = stepinfo(Hinf_CL_step, time2)


figure('position', [0, 0, 600, 200]);

subplot(1,3,1);
plot(time, H_CL_step, time2, Hinf_CL_step);
grid on
legend('Real h','Measured h');
xlabel('Dimensionless Time');
ylabel('Dimensionless h*');


MT_step = 0;
MT_amp = 1;
MT_freq = 0.08;

Mo_step = 0;
H_step = 0;

sim('buffer_silo_measure');

time = H_star_out.Time / taup;
time2 = H_star_out.Time / taup;

H_CL_step = H_star_out.Data / MT_amp / Kp;
Hinf_CL_step = Inferred_H_out.Data / MT_amp / Kp; 

info_h_step = stepinfo(H_CL_step, time)
info_hinf_step = stepinfo(Hinf_CL_step, time2)


subplot(1,3,2);
plot(time, H_CL_step, time2, Hinf_CL_step);
grid on
legend('Real h','Measured h');
xlabel('Dimensionless Time');
ylabel('Dimensionless h*');


noiseamp = 1;

MT_step = 0;
MT_amp = 0;
MT_freq = 0.08;

Mo_step = 0;
H_step = 0;

sim('buffer_silo_measure');

time = H_star_out.Time / taup;
time2 = H_star_out.Time / taup;

H_CL_step = H_star_out.Data / noiseamp / Kp;
Hinf_CL_step = Inferred_H_out.Data / noiseamp / Kp; 


subplot(1,3,3);
plot(time, H_CL_step, time2, Hinf_CL_step);
grid on
legend('Real h','Measured h');
xlabel('Dimensionless Time');
ylabel('Dimensionless h*');



%% Off-measurements

comp = 0.8;
tdelay = 1;
noiseamp = 0.0000001;

MT_step = 1;
MT_amp = 0;
MT_freq = 0.08;

Mo_step = 0;
H_step = 0;


sim('buffer_silo_deadtime');

time = Mo_star_out.Time / taup;

Mo_CL_step = Mo_star_out.Data / MT_step;
H_CL_step = H_star_out.Data / MT_step / Kp;


MT_step = 0;
MT_amp = 0;
MT_freq = 0.08;

Mo_step = 1;
H_step = 0;


sim('buffer_silo_deadtime');

time2 = Mo_star_out.Time / taup;

Mo_CL_stepm = Mo_star_out.Data / Mo_step;
H_CL_stepm = H_star_out.Data / Mo_step / Kp;




figure('position', [0, 0, 400, 400]);

subplot(2,2,1);
plot(time, Mo_CL_step);
grid on
xlabel('Dimensionless Time');
ylabel('Dimensionless mo*');

subplot(2,2,2);
plot(time, H_CL_step);
grid on
xlabel('Dimensionless Time');
ylabel('Dimensionless h*');


subplot(2,2,3);
plot(time2, Mo_CL_stepm);
grid on
xlabel('Dimensionless Time');
ylabel('Dimensionless mo*');

subplot(2,2,4);
plot(time2, H_CL_stepm);
grid on
xlabel('Dimensionless Time');
ylabel('Dimensionless h*');


info_mo_step = stepinfo(Mo_CL_step, time)
info_h_step = stepinfo(H_CL_step, time)

info_mo_stepm = stepinfo(Mo_CL_stepm, time2)
info_h_stepm = stepinfo(H_CL_stepm, time2)


