function [popFraction, transitionRate] = RateComputation(iTemp, Outbreak)
    % Input: - iTemp: Time [days]
    % 
    % Computes fraction of population susceptible to changes from one state
    % to another with the associated rate of transition.
    
    % Time-invariant parameters
    lambdaI  = 0.16;
    lambdaF  = 0.49;
    muEI     = 0.09;    % [1/days]
    muIF     = 0.13;    % [1/days]
    muIRr    = 0.13;    % [1/days]
    muIRd    = 0.13;    % [1/days]
    muHRr    = 0.22;    % [1/days]
    muHRd    = 0.24;    % [1/days]
    muFRd    = 0.5;     % [1/days]
    deltaIRr = 0;
    deltaHRr = 0.46;
    deltaHRd = 0.54;
    
    % Time-varying parameters
    if(strcmp(Outbreak,'Aug'))
        timePhase1 = 150;
        timePhase2 = 151;
    elseif(strcmp(Outbreak,'May'))
        timePhase1 = 5;
        timePhase2 = 9;
    end
    if(iTemp < timePhase1)
        lambdaH  = 0.33;
        muIH     = 0.10; % [1/days]
        deltaIH  = 0.51;
        deltaIF  = 0.10;
        deltaIRd = 0.39;
    elseif(iTemp < timePhase2)
        lambdaH  = 0.02;
        muIH     = 0.20; % [1/days]
        deltaIH  = 0.80;
        deltaIF  = 0.05;
        deltaIRd = 0.15;
    else
        lambdaH  = 0.02;
        muIH     = 0.43; % [1/days]
        deltaIH  = 0.89;
        deltaIF  = 0.01;
        deltaIRd = 0.10;
    end
    
    popFraction = [deltaIH  ; ...    % Fraction of I -> H
                   deltaIF  ; ...    % Fraction of I -> F
                   deltaIRr ; ...    % Fraction of I -> Rr (Recovered)
                   deltaIRd ; ...    % Fraction of I -> Rd (Dead and buried)
                   deltaHRr ; ...    % Fraction of H -> Rr
                   deltaHRd ]';      % Fraction of H -> Rd
     
    transitionRate = [lambdaI ; ...  % Probability of infection by I
                      lambdaH ; ...  % Probability of infection by H
                      lambdaF ; ...  % Probability of infection by F
                      muEI    ; ...  % Rate of E -> I 
                      muIH    ; ...  % Rate of I -> H
                      muIF    ; ...  % Rate of I -> F
                      muIRr   ; ...  % Rate of I -> Rr
                      muIRd   ; ...  % Rate of I -> Rd
                      muHRr   ; ...  % Rate of H -> Rr
                      muHRd   ; ...  % Rate of H -> Rd
                      muFRd   ]';    % Rate of F -> Rd
                      
end