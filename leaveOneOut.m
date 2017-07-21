%% leaveOneOut.m
% dataset: structure with: Files, Labels, Categories
% nSubject: subject to leave out

function [trainingSet, testSet] = leaveOneOut(dataset, nSubject)
    
    N = numel(dataset.Files);
    
    trainIndex  = setdiff(1:N,nSubject); %Leave one out
    testIndex   = nSubject;
    
    trainingSet.Files       = dataset.Files(trainIndex);
    trainingSet.Labels      = dataset.Labels(trainIndex);
    trainingSet.Categories  = dataset.Categories;
    
    testSet.Files       = dataset.Files(testIndex);
    testSet.Labels      = dataset.Labels(testIndex);
    testSet.Categories  = dataset.Categories;
end