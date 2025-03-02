function result = has_close_elements(numbers, threshold)
    // Check if any two elements in the given list are closer than threshold
    n = length(numbers);
    for i = 1:n-1
        for j = i+1:n
            if abs(numbers(i) - numbers(j)) < threshold then
                result = %T;
                return;
            end
        end
    end
    result = %F;
endfunction


// Compute result and print it
disp(has_close_elements([1.0, 2.0, 3.9, 4.0, 5.0, 2.2], 0.3))
