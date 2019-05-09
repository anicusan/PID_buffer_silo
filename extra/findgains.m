% Andrei Leonard Nicusan, 2019
% University of Birmingham
% Chemical Engineering, 2nd year


% Find stable PID proportional gains
% running can take quite a bit of time
% because no pain no (proportional) gain

clear; clc;

rho = 700;                      % kg/m3
AT = 4;                         % m3
AB = 0.05;                      % m3
beta = 46.5;                    % (kg/s)/m

% Height transform
Kh = 1.4;                       % mA/m

% process
taup = rho * AT / beta;         % s
Kp = 1/beta;                    % m/(kg/s)

% sensor (weighing scale)
taum = 0.5;                     % s
Km = 0.185;                     % mA / kg/s

% chute
Kep_1 = 2;                      % psi / mA
Kc = 2;                         % kg / psi
tauc = 25;                      % s

% diverter
Kep_2 = 2;                      % psi / mA
Kd = 8;                         % kg / psi
taud = 25;                      % s


%%

% Normalised Kp1 and Kp2
% for unity integral gain

figure
xlabel("Normalised Kp1");
ylabel("Normalised Kp2");
hold on


syms s

for Kp1 = linspace(0.01, 50, 5)
    for Kp2 = linspace(0.01, 300, 5) 

        KC1 = Kp1+1/s;
        KC2 = Kp2+1/s;
        PID = [KC1 0 ; 0 KC2];
        KEP = [Kep_1 0 ; 0 Kep_2];
        FCE = [Kc/(tauc * s + 1) 0 ; 0 Kd/(taud * s + 1)];
        GP = [-taup * s / (taup * s + 1) , -1/ (taup * s + 1) ; Kp/ (taup * s + 1) , -Kp/ (taup * s + 1)];
        GM = [Km / (taum * s + 1) 0 ; 0 Kh / (taum * s + 1)];

        A = det(eye(2) - PID * KEP * FCE * GP * GM);
        lambdas = vpa(solve(A));
        
        % check if stable
        if all(real(lambdas) < 0)
            plot(Kep_1*Kc*Kp1, Kep_2*Kd*Kp2, 'xb');
        else
            plot(Kep_1*Kc*Kp1, Kep_2*Kd*Kp2, 'xr');
        end

    end
end

grid on
