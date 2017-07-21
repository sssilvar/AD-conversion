%% Clear all
clear
close all
clc

%% Add Paths and define variables
addpath(genpath('libs'));
parpool(6)

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
p.cellSize = 32;
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
    fprintf('\n\nTESTING SUBJECT %d OF %d\n', i, N);
    [trainingSet, testSet] = leaveOneOut(dataset, i);
    
    binMask     = load_nii(VOIDataset.Files{i});
    binMask.img = smooth3(binMask.img, 'box', thA);
    thI         = multithresh(binMask.img(:));
    binMask.img = thFilter(binMask.img, thA, thI);
    
    [trainingData, trainingLabels] = extractFeatsPar(binMask, trainingSet, p);
    trainingData    = double(trainingData);
    %trainingLabels  = double(trainingLabels);
    
    model = svmtrain(trainingLabels, trainingData, '-s 1 -b 1 -t 1 -d 4 -g 0.07');
    fprintf('\n\n');
    
    %Prediction
    [testData, testLabels] = extractFeatsPar(binMask, testSet, p);
    testData = double(testData);    
    [predictedLabel, accuracy, probValue] = svmpredict(testLabels, testData, model, '-b 1');
    
    
    out.realLabel(i)        = grp2idx(testSet.Labels);
    out.predictedLabels(i)  = predictedLabel;
    out.accuracy(i,:)       = accuracy;
    out.probValues(i,:)     = probValue;
    
    fprintf('S. %s, was labeled as %s\n\n', dataset.Categories(out.realLabel(i)), dataset.Categories(out.predictedLabels(i)));
end

%% Test code