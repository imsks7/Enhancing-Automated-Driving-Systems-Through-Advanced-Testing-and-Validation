%% CLREAR ALL AND CLOSE ALL
close all
clear all
clc

%% NOMINAL PARAMETERS
% VEHICLE DYNAMICS PARAMETERS
m = 1430;                       %Vehicle's Mass [kg]
Af = 2.46;                      %Frontal area [m^2]
Cd = 0.29;                      %Air-drag coefficient
Cr = 1.75;                      %rolling resistance w.r.t. tyre type
c1 = 0.0328;                    %rolling resistance w.r.t. surface type
c2 = 4.575;                     %rolling resistance w.r.t. surface condition
g = 9.81;                       %gravity acceleration [m/s^2]
slope = 0;
rho_air = 1.2256;               %density air [kg/m^3]

% (ACC) CONTROLLER PARAMETER
time_gap        = 1.5;      % ACC time gap                          (s)
standstill_distance = 1.5;  % ACC default spacing                   (m)
verr_gain       = 0.5;      % ACC velocity error gain               (N/A)
xerr_gain       = 0.2;      % ACC spacing error gain                (N/A)
vx_gain         = 0.4;      % ACC relative velocity gain            (N/A)
max_ac          = 2;        % Maximum acceleration                  (m/s^2)
min_ac          = -3;       % Minimum acceleration                  (m/s^2)
actuation_delay = 0.05;          %actuator delay [s]
sigma_max = 0.025;               %communication/sensing delay [s]

% INITIAL CONDITIONS
x_ego = 0;                      % initial position [m]
v_ego = 22.22;
Insertion_Time = 600;          % we need to create congestion in the network

%% CREATE A MATRIX OF THE INPUT FACTORS
% 1) Define input parameters:  
%   m; Af; time_gap; standstill_distance; min_ac; sigma_max;
% 2) Define the bounds/range of variation of the parameters
% 3) Define the method to design an experiment.
%   3.1) Fixed and predefined values of the variables
%   3.2) Generate linearly spaced vectors
%   3.3) Employ sampling strategies


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1) Define input parameters:
% m; Af; time_gap; standstill_distance; min_ac; sigma_max;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2) Define the bounds/range of variation of the parameters
% On the basis of the results of exercise 1: 1) can exclude some variables;
% 2) can change the range of variation of the variables

range_m = 0.05;                 % range of variation of the vehicle mass m (value is between 0 and 1)
min_m = m-m*range_m;            % lower bound for the mass m
max_m = m+m*range_m;            % upper bound for the mass m

min_timegap = 1;                % lower bound for time gap
max_timegap = 2;                % upper bound for time gap

min_stdistance = 1;             % lower bound for standstill distance
max_stdistance = 2;             % upper bound for standstill distance

min_sigma = 0.01;               % lower bound for communication delay
max_sigma = 0.05;                % upper bound for communication delay

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3) LHS method.

N = 100;
X = lhsdesign(N,3);
X(:,1) = min_m + (max_m-min_m)*X(:,1);
X(:,2) = min_timegap + (max_timegap-min_timegap)*X(:,2);
X(:,3) = min_stdistance + (max_stdistance-min_stdistance)*X(:,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
cartella = strcat('OUTPUT_Simulations_1');
mkdir(cartella)
PathName = 'C:\Users\Angelo\OneDrive - Università di Napoli Federico II\Desktop\Universita\Didattica\TVARV_TestingandValidationofAutomatedRoadVehicles\Corso_2023\Final_Ex_2'; %cambiare percorso se necessario
addpath(PathName)  

%% SIMULATION LOOP
for i = 1:4%length(X(:,1))
    m = X(i,1);
    time_gap = X(i,2);
    standstill_distance = X(i,3);

    system(['sumo -c' 'C:\Users\Angelo\Es\Scenario_Traci_1.sumocfg&']);
    [traciVersion sumoVersion]= traci.init(8873);
    traci.vehicle.add('Ego_Vehicle','route1','car','60','free','0','22.22')
    traci.vehicle.setSpeedMode('Ego_Vehicle',0)
    for j = 1:100000
        traci.simulationStep();
        veicoli_in_rete = traci.vehicle.getIDList();
        if ismember('Ego_Vehicle',veicoli_in_rete)==1
            break
        else
        end
    end
    sim('Model_2023a.slx')        % run simulation
    traci.close()
    Input = [m time_gap standstill_distance sigma_max];

    % MOVE THE SIMULATION OUTPUT INTO A DEDICATED FOLDER
    attuale = cd;
    nome = strcat('Simulation_',num2str(i),'.mat');  
    save(nome)
    movefile(nome,cartella)
    system('"C:\Windows\System32\taskkill.exe" /F /im cmd.exe &');
end

