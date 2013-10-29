%Skripsie
%Tielman Nieuwoudt
%2 Augustus 2013
%Superflexible optimization, Case study 1
%This function initializes all the vectors (load profiles and the
%generation profile for the pv panel)
%It creates a vector to be optimized and calls the patternsearch
%optimization function
%
%MAJOR REVISION 1 on 27 September 2013
%Changed to 48 profile system
%
%MAJOR REVISION on 28 October 2013
%Adapted to Case Study 1 (No battery, no PV)
%Superflexible method

%Initialization
close all;
PV_in = -1*zeros(1, 48);
lights = [50*ones(1, 12) 63 63 226 59.5 40*ones(1, 2) 240*ones(1, 16) 40*ones(1, 2) 327.5 336.5 910 577 345 78.5*ones(1, 3) 72*ones(1, 2) 66 0];

%Configure pump appliance
%Initial schedule according to the database entries
%OORSPRONKLIKE SKEDULE tmp_X0 = [zeros(1, 23) 375*ones(1, 8) zeros(1, 2) 375*ones(1, 8) zeros(1, 7)];
tmp_X0 = 125*ones(1, 48);   
%The pump can at the very least use no electrity
tmp_LB = zeros(1, 48);
%The pump is rated at 750W and can use maximum 375Wh per halfhour
tmp_UB = ones(1, 48)*375;
%The energy spent on the pump must be between 6000W and 6100W
tmp_A = ones(2, 48);
tmp_A(2, :) = -1*tmp_A(2, :);
tmp_b = [6100; -6000];
pump = Appliance(tmp_LB, tmp_UB, tmp_A, tmp_b, tmp_X0);

%Configure geyser appliance
%Inital schedule according to the database entries
%OORSPRONKLIKE SKEDULE tmp_X0 = [zeros(1, 13) 1500*ones(1, 2) zeros(1, 22) 1500*ones(1, 6) zeros(1, 5) ];
tmp_X0 = 250*ones(1, 48);
%At the very least the pump can use zero electricity
tmp_LB = zeros(1, 48);
%At maximum, the 3000W rated geyser can use 1500W per half hour
tmp_UB = ones(1, 48)*1500;
%The total amount of energy must be between 12kWh and 12.5kWh
tmp_A = ones(3, 48);
tmp_A(2, :) = -1*tmp_A(2, :);
tmp_A(3, 24:48) = zeros(1, 25);
tmp_b = [12500; -12000; 3000];
geyser = Appliance(tmp_LB, tmp_UB, tmp_A, tmp_b, tmp_X0);

%Create the variable matrices from the configurable appliances
[LB, UB, A, b, X0] = CombineConfigAppl(pump, geyser);

%Set up TOU vector
TOU = ones(1, 48);
TOU(1, 1:14) = 55.10;
TOU(1, 15:20) = 174.87;
TOU(1, 21:36) = 55.1;
TOU(1, 37:40) = 174.87;
TOU(1, 41:48) = 55.1;

grid_init = (lights+pump.X0+geyser.X0);
grid_usage_init = zeros(1, 48);
for i=1:length(grid_init)
    if(grid_init(i)>0)
        grid_usage_init(i) = grid_init(i);
    end
end
%Calculate cost, 1000 factor due to cost per kWh and current dimen Wh
cost_init = (grid_usage_init.*TOU(1, :))/1000;
fprintf('Initial cost: %d\n', cost_init)

%Call necessary function handles to make call to patternsearch
OFHandle = @(x)object_function(x, TOU, PV_in, lights);

%Set up optimization options and run optimization
options = psoptimset('PlotFcns', {@(optimset, flags)constantplot(optimset, flags, PV_in, 'PV energy'), ...
    @(optimset, flags)constantplot(optimset, flags, lights, 'Uncontrollable Load Profile'), ...
    @(optimset, flags)ApplPlot(optimset, flags, 1, 'Pump Profile'), ...
    @(optimset, flags)ApplPlot(optimset, flags, 49, 'Geyser Profile'), ...
    @(optimset, flags)TotalControllable(optimset, flags),...
    @(optimset, flags)gridplot(optimset, flags, PV_in, lights), ...
    @(optimset, flags)constantplot(optimset, flags, TOU, 'Time-of-use Tariffs'), ...
    @psplotbestf...
    }, 'Display', 'iter', ...
    'InitialMeshSize',1000);
[x, fval] = patternsearch(OFHandle, X0, A, b, [], [], LB, UB, [], options);

fprintf('Pump: ')
pump = x(1:48)
fprintf('Geyser: ')
geyser = x(49:96)
fprintf('Optimized cost: %d\n', fval/1000)