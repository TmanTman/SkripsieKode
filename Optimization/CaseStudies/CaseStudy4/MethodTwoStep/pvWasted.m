function [ waste_profile ] = pvWasted( optimize_profile, varargin )
%CALCGRID Calculates the PV energy not utilised
    %Receives the optimized profile and all contr&uncontr loads. 
    
timeslots = 48; 

%Insert battery profile into the grid profile
grid = optimize_profile(1:timeslots);

%Indexholders so that we can link optimize_profile and controllable loads
start_index = 49; %The first element after battery profile in optimize_prof
end_index = 0;

%Add contr and uncontr loads to optimization
for i=1:length(varargin)
    %Add all appliances contributions
    if isa(varargin{i},'Contr_Appl')
        %Add controllable appliances
        end_index = start_index+size(varargin{i}.d, 2)-1;
        tmp_prof = constrProfile(optimize_profile(start_index:end_index), varargin{i}.d, varargin{i}.demand);
    elseif isa(varargin{i}, 'Uncontr_Appl'  )
        %Add uncontrollable appliances
        tmp_prof = varargin{i}.profile;
    else
        %This condition should not be reached
        tmp_prof = zeros(1, 48);
    end
    grid = grid+tmp_prof(1, :);
    start_index = end_index+1;
end
waste_profile = zeros(1, 22);
for i=13:34
    if grid(i)<0
        waste_profile(i-12) = grid(i);
    end
end

end
