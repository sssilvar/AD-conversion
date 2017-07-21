function [maskMCIc, maskMCIs] = extractVOI(trainingSet)
    
    nii = load_nii(trainingSet.Files{1}); %img initialization
    maskMCIc = nii;
    maskMCIs = nii;
    dim = size(nii.img);
    
    N   = numel(trainingSet.Files);
    d   = [prod(dim), 1]; %prod([dx,dy,dx]) d-voxels vector dimension
    
    indexN = 0;
    for i=1:N
        if isequal(trainingSet.Labels(i), 'MCIc')
            nii = load_nii(trainingSet.Files{i}); % Load image
            img = nii.img;
            clear nii;
            
            indexN = indexN + 1;
            X(:, indexN) = reshape(img, d);
            fprintf('X1 - Adding model %d\r', indexN);
        end
    end
    H = ones(1,indexN);
    
    W = extractModel(X, H);
    clear X H;
    clc;
    
    maskMCIc.img    = reshape(W, dim) ./ mean(W(:));
    clear W;


    % Part 2
    indexN = 0;
    for i=1:N
        if isequal(trainingSet.Labels(i), 'MCIs')
            nii = load_nii(trainingSet.Files{i}); % Load image
            img = nii.img;
            clear nii;

            indexN = indexN + 1;
            X(:, indexN) = reshape(img, d);
            fprintf('X2 - Adding model %d\r', indexN);
        end
    end
    H = ones(1,indexN);
    
    W = extractModel(X, H);
    clear X H;
    clc;
    
    maskMCIs.img    = reshape(W, dim) ./ mean(W(:));
    
end