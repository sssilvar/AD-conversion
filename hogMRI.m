function [ features ] = hogMRI(img, cellSize)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[dx, dy, dz] = size(img);

[Gmag,Gazimuth,Gelevation] = imgradient3(img);

subMat.mag = zeros(cellSize,cellSize,cellSize);
subMat.az = zeros(cellSize,cellSize,cellSize);
subMat.el = zeros(cellSize,cellSize,cellSize);

ii = 0;
for i = 0:cellSize:(dx-cellSize)
    cellIndexX = i+1:i+cellSize;
    
    for j = 0:cellSize:(dy-cellSize)
        cellIndexY = j+1:j+cellSize;
        
        for k = 0:cellSize:(dz-cellSize)
            cellIndexZ = k+1:k+cellSize;
            
            subMat.mag  = Gmag(cellIndexX, cellIndexY, cellIndexZ);
            subMat.az   = Gazimuth(cellIndexX, cellIndexY, cellIndexZ);
            subMat.el   = Gelevation(cellIndexX, cellIndexY, cellIndexZ);
            
            %preferred direction pd
            features.window = [cellIndexX; cellIndexY; cellIndexZ];
            ii = ii + 1;
            
            pd                  = max(subMat.mag(:));
            [r,c,v]             = ind2sub(size(subMat.mag),find(subMat.mag == pd));
            features.paz(ii)    = subMat.az(r(1),c(1),v(1));
            features.pel(ii)    = subMat.el(r(1),c(1),v(1));
        end
    end
end
end

