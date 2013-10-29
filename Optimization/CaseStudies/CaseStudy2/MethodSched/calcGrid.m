function [ grid ] = calcGrid( optimize_profile, varargin )
%CALCGRID Calculates the grid profile
    %Receives the profile being optimized and all contr&uncontr loads. 

%Insert battery profile into the grid profile
grid = zeros(1, 48);

%Indexholders so that we can link optimize_profile and controllable loads
start_index = 1; %The first element after battery profile in optimize_prof
end_index = 0;

%Add contr and uncontr loads to optimization
for i=1:length(varargin)
    if isa(varargin{i},'Contr_Appl')
        end_index = start_index+size(varargin{i}.d, 2)-1;
        %%%%%fprintf('Start index, End index, length of varargin: %d, %d and %d.\n', start_index, end_index, size(varargin{i}.d, 2));
        optimize_profile(start_index:end_index)
        varargin{i}.d
        varargin{i}.demand
        tmp_prof = constrProfile(optimize_profile(start_index:end_index), varargin{i}.d, varargin{i}.demand)
        %%%%%fprintf('Length of tmp_prof in contr appl: %d\n', length(tmp_prof));
    elseif isa(varargin{i}, 'Uncontr_Appl'  )
        tmp_prof = varargin{i}.profile;
    else
        %This condition should not be reached
        tmp_prof = zeros(1, 48);
    end
    %fprintf('Appliance contribution: %d\n', sum(tmp_prof));
    fprintf('tmp_prof dimensions: %d, varargin number: %d\n', size(tmp_prof, 2), i);
    grid = grid+tmp_prof(1, :);
    start_index = end_index+1;
end

end

