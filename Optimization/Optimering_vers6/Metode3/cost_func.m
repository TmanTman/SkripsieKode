%Skripsie
%Cost Function
%7 October 2013
%This cost function specifies that the amount of
%energy withdrawn from the grid should be a minimum.
%List of inputs:
%Optimize Profile - the entire variable vector for optimization
%TOU - The TOU scheme
%varargin - profiles of 1) Controllable 2) Uncontrollable

function y = cost_func(optimize_profile, TOU, varargin)
%Initialize variables
timeslots = 48; 
grid = zeros(1, timeslots); %The grid profile

%Insert battery usage into grid profile
grid = grid+optimize_profile(1:timeslots);

%Indexholders
start_index = 1;
end_index = 0;

%Add contr and uncontr loads to optimization
for i=1:length(varargin)
    if isa(varargin{i},Contrl_Appl)
        end_index = start_index+length(varargin{i}.d)-1;
        tmp_prof = constrProfile(optimize_profile(start_index:end_index), varargin{i}.d);
    elseif isa(varargin{i}, Uncontr_Appl)
        tmp_prof = varargin{i}.profile;
    else
        disp('Unexpected object in Cost Function varargin, code failed');
    end
    grid = grid+tmp_prof;
end
    
%Assign grid_usage vector values
for i=1:length(grid)
    if(grid(i)>0)
        grid_usage(i) = grid(i);
    end
end
y = sum(grid_usage.*TOU);
