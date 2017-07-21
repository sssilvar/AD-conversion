function [trainingData, trainingLabels] = extractFeats(binMask, trainingSet, p)
%% Feature extraction    
N = numel(trainingSet.Labels);    
%N=2;
    for i = 1:N
        currentSubject      = load_nii(trainingSet.Files{i});
        currentSubject.img  = currentSubject.img ./ max(currentSubject.img(:));

        % Apply mask
        img = currentSubject.img .* binMask.img;
        %figure;
        %imshow(img(:,:,128), []);
        

        %currentFeatures = hog3d(img, p.cellSize, p.blockSize, p.thetaBins, p.phiBins, p.stepSize);
        currentFeatures = hogMRI(img, p.cellSize);
        fprintf('Extracting features from S. %d of %d\n', i,N);
        trainingData(i,:) = [currentFeatures.paz, currentFeatures.pel];
        
       
        %for i = 1:numel(currentFeatures)
            %trainingData(N,:) = histcounts(currentFeatures(i).Features(:), 100);
        %end
        clear currentFeatures;
        %close;
    end
    
trainingLabels = grp2idx(trainingSet.Labels);
   
end