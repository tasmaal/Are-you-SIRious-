function EVD_Network(Parameters,fileID)
        % Input: - Network: Structure containing the network
        %        - fileID: Reference to output file 
        %
        % Calls Activity_distribution to initialize the nodes' activity potential.
        % Calls ADNTempIter to iterate over time.

    % Creating a network of size N
    N = Parameters(1);
    Network.parameters = Parameters;                        % Parameters set in Batch
    Network.nodes = 1:N;                                    % Cardinality of node
    Network.edges = spalloc(N,N,1);                         % Edges of node
    Network.state = cell(1,N);                              % State of node
    Network.active = false(1,N);                            % Activity of node
    Network.populations = {'S','E','I','H','F','R','D'};    % States
    Network.populationscount = zeros(1,7);                  % Count of each populations
    Network.changed = false(1,N);                           % Determine if a node has changed its state
    Network.cumcases = 0;                                   % Cumulative cases
    
    % Associate each node an activity potential distributed by power law
    gamma = 2.1;   % power factor
    Network.activity_potential = Activity_distribution(N, gamma);
    
    % Evolution of the network
    ADNTempIter(Network, fileID);
end
