%Tests various classes and scripts to ensure operation as expected.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Test CombineConfig - 7 October
% 
% %Build battery
% A1=[0 1 0; 1 0 1; 1 1 1];
% b1=[1;0;1];
% LB1=[0 0 1];
% UB1=[1 0 0];
% X01=[0 0 0];
% bat = Battery(LB1, UB1, A1, b1, X01);
% 
% %Build appliance 1
% appl1 = Contr_Appl([21699 64800], [3600 7200]);
% 
% %Build appliance 2
% appl2 = Contr_Appl(28800, 7200);
% 
% [LBf, UBf, Af, bf, X0f] = CombineConfigAppl(bat, appl1, appl2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Test constrProfile - 9 October
%Simple start/end - not on half hour
%Test all simple and half hour conditions for 1)single 2)two elements
%3)more than two elements

% %%%%%%%%%%%%%%More than 2 elements%%%%%%%%%%%%%%%
% start_time = zeros(1, 4);
% duration = zeros(1, 4);
% %Calculate start index: eg 1800 to 3599.99 is index 2, so floor(X/1800)+1
% %Calculate stop index: eg 1800.001 to 3600 is index 2 so ceil(X/1800)
%
% %Simple start time, end time, more than 2 elements
% start = 1900;  %index 2
% stop = 5500; %index 4
% start_time(1) = start;
% duration(1) = stop-start;
% 
% %Start time on half hour, simple end
% start = 10800;  %index 6
% %end index 9
% start_time(2) = start;
% duration(2) = 4000;
% 
% %Simple start, end time on half hour
% start = 18900;  %start index 11
% stop = 25200;   %end index 14
% start_time(3) = start;
% duration(3) = stop-start;
% 
% %Start and stop on half hour
% start = 28800; %halfhour 16
% stop = 37800; %halfhour 21
% start_time(4) = start;
% duration(4) = stop-start;
% 
% %Plot
% bar(constrProfile(start_time, duration, 750));
% set(gca, 'XTick', 0:1:50);
% set(gca, 'XTickLabel', 0:1:50);

% %%%%%%%%%%%%%%%%%One element%%%%%%%%%%%%%%%%%%%
% start_time = zeros(1, 4);
% duration = zeros(1, 4);
% %Calculate index: floor(X/1800)+1
% 
% %Simple start time, end time
% start_time(1, 1) = 1900; %start index2
% duration(1, 1) = 100;
% 
% %Start time on half hour, simple end
% start_time(1, 2) = 5400; %start index 4
% duration(1, 2) = 800;
% 
% %Simple start time, end time on half hour
% start_time(1, 3) = 10000; %start index 6
% end_time = 10800;
% duration(1, 3) = end_time-start_time(1, 3);
% 
% %Start time, End time on half hour
% start_time(1, 4) = 18000; %start index 11
% duration(1, 4) = 1800;
% 
% %Plot
% bar(constrProfile(start_time, duration, 750));
% set(gca, 'XTick', 0:1:50);
% set(gca, 'XTickLabel', 0:1:50);

%%%%%%%%%%%%%%%%%%Two elements%%%%%%%%%%%%%%%%%
% start_time = zeros(1, 4);
% duration = zeros(1, 4);
% 
% %Simple start time, end time
% start_time(1, 1) = 2000;    %start index 2
% endtime = 4000;             %end index 3
% duration(1, 1) = endtime - start_time(1, 1);
% 
% %Start time on half hour, simple end
% start_time(1, 2) = 9000;
% duration(1, 2) = 2500;
% 
% %Simple start time, end time on half hour
% start_time(1, 3) = 15000;
% endtime = 18000;
% duration(1, 3) = endtime-start_time(1, 3);
% 
% %Start time, End time on half hour
% start_time(1, 4) = 27000;
% duration(1, 4) = 3600;
% 
% %Plot
% bar(constrProfile(start_time, duration, 750));
% set(gca, 'XTick', 0:1:50);
% set(gca, 'XTickLabel', 0:1:50);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Test cost_func - 9 October
%Set up TOU vector
TOU = ones(1, 48);
TOU(1, 1:13) = 70;
TOU(1, 14:20) = 100;
TOU(1, 21:35) = 70;
TOU(1, 36:42) = 100;
TOU(1, 43:48) = 70;

%Hardcode the optimize_profile vector
var_vector = ones(1, 53);
%battery
var_vector(1, 1:30) = 500*ones(1, 30);
var_vector(1, 31:48) = -100*ones(1, 18);
%controlled loads
var_vector(1, 49:50) = [9000 18000];
var_vector(1, 51:53) = [3600 7500 15000];
%Create controlled load objects
%appl1
tmp_X0 = [3000 9000]; %start indexes: 2, 6
tmp_D = [3800 5000]; 
tmp_demand = 0.750;
appl1 = Contr_Appl(tmp_X0, tmp_D, tmp_demand);
%appl2
tmp_X0 = [4000 8000 12000];
tmp_D = [3800 2500 1000];
tmp_demand = 0.1000;
appl2 = Contr_Appl(tmp_X0, tmp_D, tmp_demand);
%Noncontrollable load
temp = [25 25 25 25 25 25 25 25 15 15 10 10 10 50 100 100 75 75 35 35 35 35 30 30 30 30 20 20 20 20 20 20 20 20 20 20 50 50 100 150 200 200 250 250 150 150 150 150];
lights = Uncontr_Appl(temp);

%Call cost_func
cost_func(var_vector, TOU, appl1, appl2, lights);

