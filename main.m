%% Clear all
clear
close all
clc

%% Add Paths and define variables
addpath(genpath('libs'));

%sex = 'Male';
sex = 'Female';

ext = 'nii';
dataDir = ['/home/sssilvar/Documents/set2SVM/data', filesep, sex, filesep];
VOIDir  = ['/home/sssilvar/Documents/set2SVM/VOIs', filesep];
fprintf('Dataset was set in: %s\n', dataDir);

%% 1.1. load Dataset
dataset     = loadDatastore(dataDir, ext);
VOIDataset  = loadDatastore(VOIDir, ext);
N           = numel(dataset.Files); %Sample size
%N=1; %provisional
thA = 5;

%HOG parameters
p.thetaBins = 9;
p.phiBins = 9;
p.cellSize = 16;
p.blockSize = 2;
p.stepSize = 2;


%% Extract VOIs from all the dataset
%for i = 1 :N
    % 1.2. Leave one Out
    %[trainingSet, testSet] = leaveOneOut(dataset, i);
    
    %2. Extract model and VOI from trainingSet (Done)
    %binMask = extractVOI(trainingSet);
    %save_nii(binMask, ['/home/users/sssilvar/set2SVM/VOIs/', sex, filesep, num2str(i), '.nii']);
%end


%% LOOP
for i=1:N
    
    [trainingSet, testSet] = leaveOneOut(dataset, i);
    
    binMask     = load_nii(VOIDataset.Files{i});
    binMask.img = smooth3(binMask.img, 'box', thA);
    thI         = multithresh(binMask.img(:));
    binMask.img = thFilter(binMask.img, thA, thI);
    
    [trainingData, trainingLabels] = extractFeats(binMask, trainingSet, p);
    
    model = svmtrain(trainingLabels, trainingData, '-c 1 -g 0.07 -b 1');
    
    %Prediction
    [testData, testLabels] = extractFeats(binMask, testSet, p);
    [predictedLabel, accuracy, probValue] = svmpredict(testLabels, testData, model, '-b 1');
    
    out.predictedLabels(i) = predictedLabel;
    out.accuracy(i,:) = accuracy;
    out.probValues(i,:) = probValue;
end

%% Test code