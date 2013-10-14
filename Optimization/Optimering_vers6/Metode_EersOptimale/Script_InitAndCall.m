%Skripsie
%Tielman Nieuwoudt
%7 Oktober 2013
%This script optimizes the energy profile with the two step method

close all;

% Create uncontrollable loads as Uncontr_Appl objects
temp = [50 50 100 100 200 200 500 500 900 900 1000 1000];
temp = 0.5*-1*[zeros(1, 12) temp fliplr(temp) zeros(1, 12)];
PV_in = Uncontr_Appl(temp);
temp = [25 25 25 25 25 25 25 25 15 15 10 10 10 50 100 100 75 75 35 35 35 35 30 30 30 30 20 20 20 20 20 20 20 20 20 20 50 50 100 150 200 200 250 250 150 150 150 150];
lights = Uncontr_Appl(temp);

%Configure battery
tmp_X0 = [6*ones(1,24) -6*ones(1,24)];
tmp_LB = -800*ones(1, 48);
tmp_UB = 500*ones(1, 48);
[tmp_A, tmp_b] = BatteryInequalityGenerator(1500);
battery = Battery(tmp_LB, tmp_UB, tmp_A, tmp_b, tmp_X0);

%Configure Appliances. This should later be read in from the database
%Information hardcoded according to 4 October database entries
%Values recieved by running ExtractSingleSource.py in Optimizaiton
%version5, in folder toetsLoads
%Converted to value in seconds

%Swimming pool pump
tmp_X0 = [43200 61200]; %Starttime Initial
tmp_d = [14400 14400];  %Duration (fixed)
tmp_demand = 750;     %Kilowatt
pump = Contr_Appl(tmp_X0, tmp_d, tmp_demand);

%Geyser
tmp_X0 = [25200 68400];
tmp_d = [3600 10800];
tmp_demand = 1000;
geyser = Contr_Appl(tmp_X0, tmp_d, tmp_demand);

%Create constraints for initial optimization
%Lowest value determined by how much battery can supply to the system
LB = battery.LB;
%Highest value is battery+appliance maximum demand from system
all_appliances_on_demand = 0.5*(pump.demand+geyser.demand);
UB = battery.UB+0.5*all_appliances_on_demand*ones(1, 48);
Aeq = ones(1, 48);
%beq should be the total amount of energy required to power the loads
%Loop would be appropriate if more Appliances are declared
pump_duration_in_hours = sum(pump.d)/3600;
pump_energy = pump_duration_in_hours*pump.demand;
geyser_duration_in_hours = sum(geyser.d)/3600;
geyser_energy = geyser_duration_in_hours*geyser.demand;
beq = geyser_energy+pump_energy;
X0 = zeros(1, 48);

%Set up TOU vector
TOU = ones(1, 48);
TOU(1, 1:13) = 70;
TOU(1, 14:20) = 100;
TOU(1, 21:35) = 70;
TOU(1, 36:42) = 100;
TOU(1, 43:48) = 70;

%Call necessary function handles to make call to patternsearch
OFHandle = @(x)cost_func1(x, TOU, PV_in, lights);

%Set up optimization options and run optimization
options = psoptimset('PlotFcns', {@(optimset, flags)constantplot(optimset, flags, -1*PV_in.profile, 'PV energy'), ...
    @(optimset, flags)constantplot(optimset, flags, lights.profile, 'Lights'), ...
    @(optimset, flags)profilePlot(optimset, flags, 1), ...
    @(optimset, flags)gridplot(optimset, flags, PV_in, lights), ...
    @(optimset, flags)constantplot(optimset, flags, TOU, 'Time-of-use Tariffs'), ...
    @psplotbestf...
    }, 'Display', 'iter', 'MaxFunEvals', 200000,...
    'InitialMeshSize',10);

[x, fval] = patternsearch(OFHandle, X0, [], [], Aeq, beq, LB, UB, [], options);