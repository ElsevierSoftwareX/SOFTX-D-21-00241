%% DEMO: Evaluation of clustering solutions generated by ACDE algorithm 
% ------------------------------------------------------------------------
% The Cluster Validity Index Tooolbox (CVIT) for automatic determination 
% of clusters from clustering solution contains more than 70 functions (m-files)
% This toolbox was developed with MATLAB R2014a.
%
% Developed by
%   Adan Jose-Garcia (adan.jose@cinvestav.mx)
%   Wilfrido Gomez Flores (wgomez@cinvestav.mx)
%
% IMPORTANT: First run "RUN_ME_FIRST.m" file to add this toolbox to search path.
% ------------------------------------------------------------------------
clc; clear all; close all;

addpath([pwd '/datasets']);
addpath([pwd '/proximity']);
addpath([pwd '/cvi']);
addpath([pwd '/clustering']);

% List of available cluster validity indices (CVIs)
CVInames = {'xb','ch','sf','pbm','cs','gd31','gd41','gd51','gd33','gd43',...
            'gd53','db2','db','cop','sil','dunn','sv','sym','sdunn','sdb',...
            'sdbw','cind'};

% List of available distances
Distnames = {'euc','neuc','cos','pcorr','scorr','lap'};
   
% List of datasets provided
DSnames = {'Data_4_3','Data_5_2','Moon', 'Iris'};

%%-------------------------------------------------------------------------
%% Parameters related to the automatic clustering problem
load('Data_5_2');
X = data(:,1:end-1); T = data(:,end); 

% load fisheriris; % Load the Iris dataset
% X = meas; T = [ones(50,1); ones(50,1)*2; ones(50,1)*3];

Kmax    = 10;               % Maximum number of clusters
NP      = 10*size(X,2);     % Population size
Gmax    = 100;              % Number of generations
CVI     = 'ch';             % CVI name
Dist    = 'euc';            % Distance funtion
% ------------------------------------------------------------------------
%% Run the ACDE algorithm
rng default; rng(1);
[Tb,Pb,bFit,mFit] = acde(X, Kmax, NP, Gmax, CVI, Dist);

%% Clustering performance
ARI_val = pairwiseindex(T,Tb)  % The adjusted rand index

% ------------------------------------------------------------------------
%% Figure 1: 2D-Scatter plot
figure(1)
dotp = 12; mg = [0.10 0.10 0.10];

pscat = scatter(X(:,1),X(:,2),dotp,'o','MarkerEdgeColor',mg,'MarkerFaceColor',mg);
pscat.MarkerFaceAlpha = .2;
pscat.MarkerEdgeAlpha = .5;
title('Unlabeled data');

niceplot(8);
set(gca,'xgrid','on','ygrid','on');

set(gcf, 'color','white');
set(gcf, 'renderer', 'painters');
figuresize(5,5,'centimeters');
% ------------------------------------------------------------------------
%% Figure 2: Line plot (CVI convergence)
figure(2)    

plot(bFit,'DisplayName','best value','LineWidth',1.5);hold on;
plot(mFit,'DisplayName','avg value','LineWidth',1.5);hold off; 
legend('Location','southeast');
title([upper(CVI) ': Convergence plot']);
ylabel([upper(CVI) ' value']); xlabel('number of iterations');

niceplot(7); box on; 
set(gca,'YGrid', 'on'); set(gca,'xGrid', 'on');

set(gcf, 'color','white');
set(gcf, 'renderer', 'painters');
figuresize(10,5,'centimeters');
% ------------------------------------------------------------------------
%% Figure 3: 2D-Scatter plot w/ clusters
figure(3)
dotp = 12;
map = colormap(lines);

kT = unique(Tb);
for i = 1:numel(kT)
    idx = Tb==kT(i);
    pscat = scatter(X(idx,1),X(idx,2),dotp,'o','MarkerEdgeColor',map(i,:),'MarkerFaceColor',map(i,:));
    pscat.MarkerFaceAlpha = .2;
    pscat.MarkerEdgeAlpha = .5;
    hold on;
end
title('Data clustering');
%ytickformat('%.1f'); xtickformat('%.1f');
%xlabel('x'); ylabel('y');
txt = ['ARI = ' num2str(ARI_val,'%.2f')]; text(0.55,0.05,txt);

niceplot(8);
%set(gca,'xTick',0:1,'yTick',0:1,'xLim', [0 1]);
set(gca,'xgrid','on','ygrid','on');

set(gcf, 'color','white');
set(gcf, 'renderer', 'painters');
figuresize(5,5,'centimeters');

