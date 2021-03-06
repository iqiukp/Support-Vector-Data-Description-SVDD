%{
    Demonstration of nSVDD parameter optimization.
%}

clc
clear all
close all
addpath(genpath(pwd))

% training data and test data
[data, label] = DataSet.generate('dim', 3, 'num', [200, 200], 'display', 'off');
[trainData, trainLabel, testData, testLabel] = DataSet.partition(data, label, 'type', 'hybrid');

% parameter setting
kernel = Kernel('type', 'gaussian', 'gamma', 0.04);
cost = 0.3;

% optimization setting 
optimization.method = 'bayes'; % bayes, ga  pso 
optimization.variableName = { 'cost', 'gamma'};
optimization.variableType = {'real', 'real'}; % 'integer' 'real'
optimization.lowerBound = [10^-2, 2^-6];
optimization.upperBound = [10^0, 2^6];
optimization.maxIteration = 20;
optimization.points = 10;
optimization.display = 'on';

svddParameter = struct('cost', cost,...
                       'kernelFunc', kernel,...
                       'KFold', 10,... % 10-folds
                       'optimization', optimization);
               
% creat an SVDD object
svdd = BaseSVDD(svddParameter);
% train SVDD model
svdd.train(trainData, trainLabel);
% test SVDD model
results = svdd.test(testData, testLabel);

% Visualization 
svplot = SvddVisualization();
svplot.boundary(svdd);
svplot.ROC(svdd);
svplot.distance(svdd, results);
svplot.testDataWithBoundary(svdd, results);
