function [ grid ] = calcGridIdealProfile( optimize_profile, varargin )
%CALCGRID Calculates the grid profile
    %Receives the profile being optimized and all contr&uncontr loads. 
    grid = optimize_profile;

    %Add contr and uncontr loads to optimization
    for i=1:length(varargin)
        if isa(varargin{i}, 'Uncontr_Appl'  )
            tmp_prof = varargin{i}.profile;
        else
            %This condition should not be reached
            disp('Error: Appliance could not be identified');
            break;
        end
        %fprintf('Appliance contribution: %d\n', sum(tmp_prof));
        grid = grid+tmp_prof(1, :);
    end
end

