function [ profile ] = constrProfile( X, dur, demand)
%CONSTRPROFILE Constructs profile from start times and durations
%The following mechanism is applied:
%The first and last profiles are written, and those inbetween are filled in
%Different code is executed for one element and two+ elements
    
    %Preallocate profile vector   
    profile = zeros(1, 48);
        %fprintf('Number of cycles: %d\n', size(X, 2));

    %for each cycle in the appliance
    for i=1:size(X, 2)
            %fprintf('Current starttime and dur: %d, %d. ', X(1,i), dur(1,i));
        %Gather info regarding starting times
        index_start = floor(X(1, i)/1800)+1;
        halfhour_after_start = index_start*1800;
            %fprintf('index_start: %d ', index_start)
        
        %One element
        if ((X(1, i)+dur(1, i)) <= halfhour_after_start) 
            profile(index_start) = dur(1, i)*demand;
                %fprintf('Identified as single element\n');
        
        %If more than one element
        else
            %Make first and last element entry and then fill in the middle elements
            %First element entry
            profile(index_start) = (halfhour_after_start-X(1, i))*demand; 
            index_end = ceil((X(1, i)+dur(1, i))/1800);
                %fprintf('index_end: %d ', index_end);
            halfhour_before_end = (index_end-1)*1800;
            %Last element entry
            profile(index_end) = (X(1, i)+dur(1, i)-halfhour_before_end)*demand; 
            
            %Fill in the elements between start and end
            if (index_end - index_start) > 1
                    %fprintf('Then Filling middle elements');
                profile((index_start+1):(index_end-1)) = deal(1800*demand);
            end
            
        end
            %fprintf('\n');
    end
end

