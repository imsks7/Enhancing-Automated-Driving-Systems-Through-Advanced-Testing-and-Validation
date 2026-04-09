%% Pulizia 
clear all
close all
clc

%%
PathName = 'C:\Users\sksar\Desktop\github\TVARV\Final_Ex_2\OUTPUT_Simulations_1'; %cambiare percorso se necessario
addpath(PathName)                   % Add the Output folder to Math Path
file_all = dir(fullfile(PathName,'*.mat'));
matfile = file_all([file_all.isdir] == 0); 
clear file_all
sim_ciclo = 1;   

%% MATRIX CREATION
N = 200;                        % Number of simulation runs
T = 2;                          % Number of Outputs (Minimum Distance, Aggregate Distance Error, Aggregate Speed Error, Minimum TTC)
Input_Matrix = (zeros(N,3));
Output_Matrix = (zeros(N,T));

%% LOOP

for i=1:length(matfile)
    load(matfile(i).name)
    Output_Matrix(i,1) = min(ans.Relative_Distance);
    TTC = (Relative_Distance)./(ans.Ego_Speed-ans.Leader_Speed);
    Output_Matrix(i,2) = min(TTC(TTC > 0));
    Input_Matrix(i,:) = Input(1,:);
end

clearvars -except Input_Matrix Output_Matrix PathName


%% PASS-FAIL RATE
% Since we want to know if there was a crash or not, we need to analyse the
% Min_distance. If Min_distance< thresholf (e.g. < 0.01 m), then a crash
% occurred. Once this is done, we could then conduct the analyzes on the
% entire sample or only on the cases where there was no accident. 
% But this at least allows us to identify them

threshold_1 = 0.01;
Crash = Output_Matrix(:,1) < threshold_1;
Fail_Rate_crash = (sum(Crash)/length(Crash))*100;

threshold_2 = 0.5;
Danger = Output_Matrix(:,4) < threshold_2;
Fail_Rate_danger = (sum(Danger)/length(Danger))*100;

figure(1)
subplot(1,2,1)
ecdf(Output_Matrix(:,1),'Alpha',0.05,"Bounds","on");
xlabel({'Minimum Distance [m]'})
ylabel('F(x)')
xline(threshold_1,'LineWidth',2)
set(gca,'FontName','Times New Roman','FontSize',20)
subplot(1,2,2)
ecdf(Output_Matrix(:,4),'Alpha',0.05,"Bounds","on");
xlabel({'Minimum TTC [s]'})
ylabel('F(x)')
xline(threshold_2,'LineWidth',2)
set(gca,'FontName','Times New Roman','FontSize',20)


%% ANALYSIS OF DISTRIBUTION 
figure()
subplot(1,2,1)
histogram(Output_Matrix(:,1))
xlabel({'Minimum Distance [m]'})
ylabel("Estimated PDF")
subplot(1,2,2)
histogram(Output_Matrix(:,2))
xlabel({'Minimum TTC [s]'})
ylabel("Estimated PDF")

Statistical = zeros(5,2);
Statistical(1,:) = mean(Output_Matrix);
Statistical(2,:) = median(Output_Matrix);
Statistical(3,:) = std(Output_Matrix);
Statistical(4,:) = skewness(Output_Matrix);
Statistical(5,:) = kurtosis(Output_Matrix);


%% ANALYSIS OF INPUT-OUTPUT RELATIONSHIP
% plotmatrix(X,Y) creates a matrix of subaxes containing scatter plots of the columns of X against the columns of Y.
% If X is p-by-n and Y is p-by-m, then plotmatrix produces an n-by-m matrix of subaxes.

figure()
plotmatrix([Input_Matrix,Output_Matrix(:,1)])
title("I/O RELATIONSHIP: Min Distance")

figure()
plotmatrix([Input_Matrix,Output_Matrix(:,2)])
title("I/O RELATIONSHIP: Min TTC")

% Correlation Analysis
[R1,P1] = corrcoef([Input_Matrix,Output_Matrix(:,1)],'Alpha',0.05);
[R2,P2] = corrcoef([Input_Matrix,Output_Matrix(:,2)],'Alpha',0.05);


% Multiple linear regression (and standardised version). TO DO



%% REMOVE PATH
%Remove the folder of Outputs from the Math Path
rmpath(PathName)