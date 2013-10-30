%Skripsie
%Tielman Nieuwoudt
%2 Augustus 2013
%This function initializes all the vectors (load profiles and the
%generation profile for the pv panel)
%It creates a vector to be optimized and calls the patternsearch
%optimization function
%
%MAJOR REVISION 1 on 27 September 2013
%Changed to 48 profile system
%
%MAJOR REVISION 2 on 30 October 2013
%Adapted to case study 4

%Initialization
close all;
PV_in = -1*3*1000*[0,0,0,0,0,0,0,0,0,0,0,0,0.00688704565712588,0.0404407621075567,0.0786608646132515,0.116517109042290,0.152317742893929,0.184967440824007,0.213622202139249,0.237618079627612,0.256414912845400,0.269615083688224,0.276937258591661,0.278235144102209,0.273474980192136,0.262758046944637,0.246309411211251,0.224481677726057,0.197743735763098,0.166718270278300,0.132159255224324,0.0950382291769833,0.0567093443597108,0.0198921585619491,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
lights = [50*ones(1, 12) 63 63 226 59.5 40*ones(1, 2) 240*ones(1, 16) 40*ones(1, 2) 327.5 336.5 910 577 345 78.5*ones(1, 3) 72*ones(1, 2) 66 0];

%Configure pump appliance
%Use the same initial values as in case study 1
tmp_X0 = 125*ones(1, 48);
%At the very least the pump can use no electricity
tmp_LB = zeros(1, 48);
%At the most the pump can use 750Wh per halfhour
tmp_UB = ones(1, 48)*750;
%Set the pump to use between 6100 and 6000 Wh per day
tmp_A = ones(2, 48);
tmp_A(2, :) = -1*tmp_A(2, :);
tmp_b = [6100; -6000];
%Create the pump object
pump = Appliance(tmp_LB, tmp_UB, tmp_A, tmp_b, tmp_X0);

%Configure geyser appliance
%Use the same initial values as in case study 1
tmp_X0 = 250*ones(1, 48);
%At the very least the geyser can use no electricity
tmp_LB = zeros(1, 48);
%At the most the geyser can use 750Wh per halfhour
tmp_UB = ones(1, 48)*1500;
%Allow the geyser to use between 12000 an 12500 Wh per day
tmp_A = ones(2, 48);
tmp_A(2, :) = -1*tmp_A(2, :);
tmp_b = [12500; -12000];
%Create the geyser object
geyser = Appliance(tmp_LB, tmp_UB, tmp_A, tmp_b, tmp_X0);

%Configure battery
tmp_X0 = 500*ones(1, 48);
tmp_LB = -250*ones(1, 48);
tmp_UB = 250*ones(1, 48);
[tmp_A, tmp_b] = BatteryInequalityGenerator(4500);
battery = Appliance(tmp_LB, tmp_UB, tmp_A, tmp_b, tmp_X0);

%Create the variable matrices from the configurable appliances
[LB, UB, A, b, X0] = CombineConfigAppl(pump, geyser, battery);
Aeq = [zeros(1, 96) ones(1, 48)];
beq = 0;

%Set up TOU vector
TOU = ones(1, 48);
TOU(1, 1:14) = 55.10;
TOU(1, 15:20) = 174.87;
TOU(1, 21:36) = 55.1;
TOU(1, 37:40) = 174.87;
TOU(1, 41:48) = 55.1;

%display the cost for the system in database, before optimization is run
pump_init = [zeros(1, 24) 375*ones(1, 8) zeros(1, 2) 375*ones(1, 8) zeros(1, 6)];
geyser_init = [zeros(1, 14) 1500*ones(1, 2) zeros(1, 22) 1500*ones(1, 6) zeros(1, 4) ];
cost = sum(gridUsage(PV_in, lights, pump_init, geyser_init).*TOU);
fprintf('Cost for database load setup is: %d\n', cost);
%PV energy information to calculate PV usage efficiency
fprintf('PV energy received: %d\n', -1*sum(PV_in));
%The amount of PV energy pumped into grid before optimization
grid_pumped_back = pumpedBackProfile(PV_in, lights, pump_init, geyser_init);
fprintf('PV energy pumped back: %d\n', sum(grid_pumped_back));
%display the cost for the new initial values, before optimization is run
pump_init = 125*ones(1, 48);
geyser_init = 250*ones(1, 48);
cost = sum(gridUsage(PV_in, lights, pump_init, geyser_init).*TOU);
fprintf('Cost for new initial values: %d\n', cost);

%Call necessary function handles to make call to patternsearch
OFHandle = @(x)object_function(x, TOU, PV_in, lights);

%Set up optimization options and run optimization
options = psoptimset('PlotFcns', {@(optimset, flags)constantplot(optimset, flags, -1*PV_in, 'PV energy'), ...
    @(optimset, flags)constantplot(optimset, flags, lights, 'Lights'), ...
    @(optimset, flags)ApplPlot(optimset, flags, 1, 'Pump Profile'), ...
    @(optimset, flags)ApplPlot(optimset, flags, 49, 'Geyser Profile'), ...
    @(optimset, flags)ApplPlot(optimset, flags, 97, 'Battery Profile'), ...
    @(optimset, flags)TotalControllable(optimset, flags),...
    @(optimset, flags)gridplot(optimset, flags, PV_in, lights), ...
    @(optimset, flags)constantplot(optimset, flags, TOU, 'Time-of-use Tariffs'), ...
    @psplotbestf...
    }, 'Display', 'iter', ...
    'InitialMeshSize',10);
[x, fval] = patternsearch(OFHandle, X0, A, b, Aeq, beq, LB, UB, [], options);

%Display the results of the optimization
% fprintf('Pump: ')
pump = x(1:48);
% fprintf('Geyser: ')
geyser = x(49:96);
battery = x(97:144);
fprintf('Optimized cost: %d\n', fval/1000)
%The amount of PV energy pumped into grid before optimization
pv_not_used = pvWasted(PV_in, lights, pump, geyser, battery);
fprintf('PV energy pumped back: %d\n', sum(pv_not_used));