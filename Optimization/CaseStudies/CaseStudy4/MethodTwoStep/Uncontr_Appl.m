%Skripsie
%Tielman Nieuwoudt
%7 Oktober 2013
%This file creates a class for uncontrollable appliances

%Fields per appliance:
%.profile

classdef Uncontr_Appl
    properties 
        profile
    end
    methods
        function Appl = Uncontr_Appl(profile)
            Appl.profile = profile;
        end %function Appliance (Constructor)
    end %methods
end %classdef