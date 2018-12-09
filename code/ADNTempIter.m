function ADNTempIter(Network, fileID)
    % Input: - Network: Structure containing the network
    %        - fileID: Reference to output file 
    %
    % Iterates network over time: create edges between nodes, calls
    % RateComputation, spreads the infection, update population states and 
    % calls PrintOutput.
        
    N = Network.parameters(1);
    s = RandStream('mlfg6331_64');      % Reproducibility
    for iTemp = 1:Network.parameters(4)       
        %% 0. Initialization
        if (iTemp == 1)
            % Initial cases
            initialCases = Network.parameters(2);
            initialDead = Network.parameters(3);
            Network.cumcases = Network.cumcases + initialCases;
            indexes = randsample(N, initialCases + initialDead);
            indexesCases = datasample(s, indexes, initialCases, 'Replace', false);
            
            % Iterations over the nodes
            for iNode = 1:N
                if (~isempty(nonzeros(iNode == indexes)))
                    if (~isempty(nonzeros(iNode == indexesCases)))
                        Network.state{iNode} = 'I';
                    else
                        Network.state{iNode} = 'D';
                    end
                else
                    Network.state{iNode} = 'S';
                end
            end
            
            % Counting the population
            for iPop = 1:7  % 7 different populations
                Network.populationscount(iPop) = sum(ismember(Network.state, Network.populations{iPop}));
            end
            % Print out results
            PrintOutput(0, Network.populationscount, Network.cumcases, fileID)
        end
        
        % Increase the performance: check if solution can not evolve
        if ((Network.populationscount(1) + Network.populationscount(6) + Network.populationscount(7)) ~= N)
            %% 1. Creation of the edges 

            % Determine which nodes are active
            for iNode = 1:N
                eta = 0;
                if ((Network.state{iNode} == 'S') || (Network.state{iNode} == 'E'))
                    eta = Network.parameters(6);
                elseif (Network.state{iNode} == 'I')
                    eta = Network.parameters(7);
                end
                u = rand();
                if (eta*Network.activity_potential(iNode) >= u)
                    Network.active(iNode) = true;
                end
            end
            activesIndices = find(Network.active == true);

            % Link each active node to m other nodes
            m = Network.parameters(5);
            numberEdges = zeros(1,N);

            for iNode = 1:length(activesIndices)        % For each active node
                randOther = randsample(N, m);           % Randomly choose m other nodes to create edges with
                for jNode = 1:length(randOther)         % Loop over the randomly chosen nodes
                    % Cannot create edge with itself 
                    if (activesIndices(iNode) ~= randOther(jNode) && (numberEdges(activesIndices(iNode)) < m))
                       % Check if edge has already been created and if jNode has already created m edges
                       if ((Network.edges(activesIndices(iNode),randOther(jNode)) == 0) && (numberEdges(randOther(jNode)) < m))   
                            Network.edges(activesIndices(iNode),randOther(jNode)) = 1;
                            Network.edges(randOther(jNode),activesIndices(iNode)) = 1; % Create edge
                            numberEdges(activesIndices(iNode)) = numberEdges(activesIndices(iNode)) + 1;
                            numberEdges(randOther(jNode)) = numberEdges(randOther(jNode)) + 1;    % Actualize numberEdges
                       end
                    end
                end

                % While the node has not created m edges
                while (numberEdges(activesIndices(iNode)) < m)  
                    jNode = randsample(N,1);
                    if (activesIndices(iNode) ~= jNode)   
                        if ((Network.edges(activesIndices(iNode),jNode) == 0) && (numberEdges(jNode) < m))   
                            Network.edges(activesIndices(iNode),jNode) = 1;
                            Network.edges(jNode,activesIndices(iNode)) = 1; 
                            numberEdges(activesIndices(iNode)) = numberEdges(activesIndices(iNode)) + 1;
                            numberEdges(jNode) = numberEdges(jNode) + 1;   
                        end
                    end
                end
            end

            %% 2. Change of state

            %% 2.1 Stochastic compartemental model (cf Table 2)
            [popFraction, transitionRate] = RateComputation(iTemp);

            for iNode = randperm(length(activesIndices))  % For each active node                
                state = Network.state{activesIndices(iNode)};
                switch state
                    case 'S'
                        % Infection spreading
                        connectedNodes = find(Network.edges(activesIndices(iNode),:) ~= 0); % Nodes connected
                        for iNodeCon = 1:length(connectedNodes)
                            stateConnected = Network.state{connectedNodes(iNodeCon)};
                            if (stateConnected == 'I')
                                u = rand(); 
                                if ((transitionRate(1) >= u) && (Network.changed(activesIndices(iNode)) == false))
                                    Network.state{activesIndices(iNode)} = 'E';  % I infects S
                                    Network.changed(activesIndices(iNode)) = true;
                                    Network.cumcases = Network.cumcases + 1;
                                end
                            elseif (stateConnected == 'H')                            
                                u = rand(); 
                                if ((transitionRate(2) >= u) && (Network.changed(activesIndices(iNode)) == false))
                                    Network.state{activesIndices(iNode)} = 'E';  % H infects S
                                    Network.changed(activesIndices(iNode)) = true;
                                    Network.cumcases = Network.cumcases + 1;
                                end
                            elseif (stateConnected == 'F')
                                u = rand(); 
                                if ((transitionRate(3) >= u) && (Network.changed(activesIndices(iNode)) == false))
                                    Network.state{activesIndices(iNode)} = 'E';  % F infects S
                                    Network.changed(activesIndices(iNode)) = true;
                                    Network.cumcases = Network.cumcases + 1;
                                end
                            end
                        end                     
                    case 'E'
                        % Do nothing
                    case 'I'
                        % Infection spreading
                        connectedNodes = find(Network.edges(activesIndices(iNode),:) ~= 0); % Nodes connected
                        for iNodeCon = 1:length(connectedNodes)
                            stateConnected = Network.state{connectedNodes(iNodeCon)};
                            if (stateConnected == 'S')
                                u = rand(); 
                                if ((transitionRate(1) >= u) && (Network.changed(connectedNodes(iNodeCon)) == false))
                                    Network.state{connectedNodes(iNodeCon)} = 'E';  % I infects S
                                    Network.changed(connectedNodes(iNodeCon)) = true;
                                    Network.cumcases = Network.cumcases + 1;
                                end
                            end
                        end 
                    case 'H'
                        % Infection spreading
                        connectedNodes = find(Network.edges(activesIndices(iNode),:) ~= 0); % Nodes connected
                        for iNodeCon = 1:length(connectedNodes)                      
                            stateConnected = Network.state{connectedNodes(iNodeCon)};
                            if (stateConnected == 'S')                            
                                u = rand(); 
                                if ((transitionRate(2) >= u) && (Network.changed(connectedNodes(iNodeCon)) == false))
                                    Network.state{connectedNodes(iNodeCon)} = 'E';  % H infects S
                                    Network.changed(connectedNodes(iNodeCon)) = true;
                                    Network.cumcases = Network.cumcases + 1;
                                end
                            end
                        end                  
                    case 'F'
                        % Infection spreading
                        connectedNodes = find(Network.edges(activesIndices(iNode),:) ~= 0); % Nodes connected
                        for iNodeCon = 1:length(connectedNodes)
                            stateConnected = Network.state{connectedNodes(iNodeCon)};
                            if (stateConnected == 'S')
                                u = rand(); 
                                if ((transitionRate(3) >= u) && (Network.changed(connectedNodes(iNodeCon)) == false))
                                    Network.state{connectedNodes(iNodeCon)} = 'E';  % F infects S
                                    Network.changed(connectedNodes(iNodeCon)) = true;
                                    Network.cumcases = Network.cumcases + 1;
                                end
                            end
                        end
                    case 'R'
                        % Do nothing
                    case 'D'
                        % Do nothing
                end
            end

            % Counting the population
            for iPop = 1:6 
                Network.populationscount(iPop) = sum(ismember(Network.state, Network.populations{iPop}));
            end
            % I and H populations are fractioned depending on the state they may change to
            cumPopFraction = [1 cumsum(round(Network.populationscount(3)*popFraction(1:3).*ones(1,3))) ...
                              Network.populationscount(3) ...
                              1 round(Network.populationscount(4)*popFraction(5)) ...
                              Network.populationscount(4) ];
            % Making sure cumPopFraction does not contain 0
            for iTest = 1:length(cumPopFraction)
                if (cumPopFraction(iTest) == 0)
                    cumPopFraction(iTest) = 1;
                end
            end

            %% 2.2 Spontaneous change of state

            % Exposed nodes, 1 possibility: E -> I
            exposedNodes = find([Network.state{:}] == 'E');
            if (~isempty(exposedNodes))
                for iNode = 1:length(exposedNodes)
                    u = rand(); 
                    if ((transitionRate(4) >= u) && (Network.changed(iNode) == false))
                        Network.state{exposedNodes(iNode)} = 'I';
                        Network.changed(exposedNodes(iNode)) = true;
                    end
                end
            end

            % Infected nodes, 4 possiblities: I -> H, F, R, D
            newStates = {'H', 'F', 'R', 'D'};
            infectedNodes = datasample(s, find([Network.state{:}] == 'I'), Network.populationscount(3), 'Replace', false);   % Infected nodes indices in random order
            if (~isempty(infectedNodes))
                for iPoss = 1:4
                    infectedNodesFrac = infectedNodes(cumPopFraction(iPoss):cumPopFraction(iPoss + 1));
                    for iNode = 1:length(infectedNodesFrac)
                        u = rand();
                        if ((transitionRate(iPoss + 4) >= u) && (Network.changed(infectedNodesFrac(iNode)) == false))
                            Network.state{infectedNodesFrac(iNode)} = newStates{iPoss};
                            Network.changed(infectedNodesFrac(iNode)) = true;
                        end
                    end
                end
            end

            % Hospitalized nodes, 2 possibilities: H -> R, D
            newStates = {'R', 'D'};
            hospitalizedNodes = datasample(s, find([Network.state{:}] == 'H'), Network.populationscount(4), 'Replace', false);   % Hospitalized nodes indices in random order
            if (~isempty(hospitalizedNodes))
                for iPoss = 1:2
                    hospitalizedNodesFrac = hospitalizedNodes(cumPopFraction(iPoss + 5):cumPopFraction(iPoss + 6));
                    for iNode = 1:length(hospitalizedNodesFrac)
                        u = rand();
                        if ((transitionRate(iPoss + 8) >= u) && (Network.changed(hospitalizedNodesFrac(iNode)) == false))
                            Network.state{hospitalizedNodesFrac(iNode)} = newStates{iPoss};
                            Network.changed(hospitalizedNodesFrac(iNode)) = true;
                        end
                    end            
                end
            end

            % Buried (not safely, F) nodes, 1 possibility: F -> Rd
            buriedNodes = find([Network.state{:}] == 'F');
            if (~isempty(buriedNodes))
                for iNode = 1:length(buriedNodes)
                    u = rand(); 
                    if ((transitionRate(11) >= u) && (Network.changed(buriedNodes(iNode)) == false))
                        Network.state{buriedNodes(iNode)} = 'D';
                        Network.changed(buriedNodes(iNode)) = true;
                    end
                end
            end
        end
        %% 3. Exporting data
        
        % Counting the population
        for iPop = 1:7  
            Network.populationscount(iPop) = sum(ismember(Network.state, Network.populations{iPop}));
        end       
        % Print out results
        PrintOutput(iTemp, Network.populationscount, Network.cumcases, fileID)
        
        % Reset graph
        clear Network.active Network.edges Network.changed
        Network.active = false(1,N);    
        Network.edges = spalloc(N,N,1);
        Network.changed = false(1,N);
        
    end   
end
