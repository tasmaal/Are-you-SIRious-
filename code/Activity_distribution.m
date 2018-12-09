function [x] = Activity_distribution(N, gamma)
    % Input: - N: Size of the population
    %        - gamma: Exponant of the power law
    %
    % Computes the activity potential x in ADN of N nodes with respect to
    % the PDF:
    %       f(x) = x^(-gamma)
    % using inverse transform sampling.
    
    x_sampling = 1e-3 : 1e-4 : 1;   % Avoid singularity at x = 0 of power law
    
    PowerLawPDF = x_sampling.^(-gamma);         % PDF f(x)
    PowerLawCDF = cumsum(PowerLawPDF);          % CDF F(x)
    PowerLawCDF = PowerLawCDF/PowerLawCDF(end); % Normalization
    
    % Generating random numbers based on uniform random distribution U ~ [0,1]    
    U_distribution = rand(N,1);
    x = zeros(N,1);
    
    for i = 1:N
        index = find(PowerLawCDF >= U_distribution(i), 1, 'first');
        x(i) = x_sampling(index);
    end
end