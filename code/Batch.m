function Batch
    % Main function
    % Set the parameters of the network and run the simulation
    
    %% 1. Parameters
        % 1.1 Network parameters
        N     = 1e4;        % Size of the population
        nc    = 43;         % Number of initial cases
        nd    = 33;         % Number of initial dead
        tEnd  = 123;        % Number of time steps [days]
        m     = 7;          % Number of edges created
        etaSE = 6.5;        % Activation factor for states S and E
        etaI  = 4.5;        % Activation factor for state I
        
        Parameters = [N, nc, nd, tEnd, m, etaSE, etaI];
        
        % 1.2 Reproducibility parameters
        rng('default');
 
        % 1.3 Output
        if ~exist('OutputEbola', 'dir')
            mkdir('OutputEbola')
        end
        rootDir = pwd;
        relDir = 'OutputEbola';
        delete('OutputEbola\*') % Clean directory (make sure to keep your data elsewhere!)
        
    %% 2. Light test
%     numberLTest = 20;    % Number of trials
%     parfor iTest = 1:numberLTest
%         rng(100 + iTest);   % Reproducibility
%         fileID = fopen(fullfile(rootDir, relDir, strcat(['Data_Test' num2str(iTest) '.txt'])), 'w');
%         fprintf(fileID,'%8s %8s %8s %8s %8s %8s %8s %8s %8s\n','Time','S','E','I','H','F','R','D','Cumul');
%         EVD_Network(Parameters,fileID);
%         fclose(fileID);
%     end
%     
%     OutputInterpreter(rootDir, relDir, 'LightTest', tEnd, numberLTest)
    %% 3. Full test
    m_range = 5:8;
    etaSE_range = 5:0.5:7;
    etaI_range = 4:0.5:6;  
    numberFTest = 10;
    
    parfor im = 1:length(m_range)
        for iSE = 1:length(etaSE_range)
            for iI = 1:length(etaI_range)
                for iTest = 1:numberFTest
                    rng(200 + iTest);   % Reproducibility
                    Parameters = [N, nc, nd, tEnd, m_range(im), etaSE_range(iSE), etaI_range(iI)];
                    fileID = fopen(fullfile(rootDir, relDir,strcat(['data_m' num2str(m_range(im)) '_SE' num2str(etaSE_range(iSE)) '_I' num2str(etaI_range(iI)) '_Test' num2str(iTest) '.txt'])),'w');
                    fprintf(fileID,'%8s %8s %8s %8s %8s %8s %8s %8s %8s\n','Time','S','E','I','H','F','R','D','Cum');
                    EVD_Network(Parameters,fileID);
                    fclose(fileID);
                end
            end
        end
    end
    
    OutputInterpreter(rootDir, relDir, 'FullTest', tEnd, numberFTest, m_range, etaSE_range, etaI_range)
end
