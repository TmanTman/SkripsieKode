function [ grid ] = calcGrid( optimize_profile, varargin )
%CALCGRID Calculates the grid profile
    %Receives the profile being optimized and all contr&uncontr loads. 
    
timeslots = 48; 
grid = zeros(1, timeslots);

%Insert battery usage into grid profile
grid = grid+optimize_profile(1:timeslots);

%Indexholders so that we can link optimize_profile and controllable loads
start_index = 49; %The first element after battery profile in optimize_prof
end_index = 0;

%Add contr and uncontr loads to optimization
for i=1:length(varargin)
    if isa(varargin{i},'Contr_Appl')
        end_index = start_index+size(varargin{i}.d, 2)-1;
        tmp_prof = constrProfile(optimize_profile(start_index:end_index), varargin{i}.d, varargin{i}.demand);
    elseif isa(varargin{i}, 'Uncontr_Appl'  )
        tmp_prof = varargin{i}.profile;
    else
        disp('Unexpected object in Cost Function varargin, code failed');
    end
    grid = grid+tmp_prof;
    start_index = end_index+1;
end

end

