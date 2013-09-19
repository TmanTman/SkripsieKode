function y = callabsval
    coder.ceval('absval_initialize');
    y = -2.75;
    y = coder.ceval('absval', y);
    coder.ceval('absval_terminate');
end

