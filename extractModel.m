% This function extracts the W matrix of k columns (depending on the
% number of clases).
%
% W corresponds to the solution from the eq.:
% X = W * H
% Where:
%   X: All data grouped as N column vectors of d-dimention
%   H: The matrix of coefficients, wich repesents the class membership
%   W: The cla

function W = extractModel(X, H)
    W = X*H'*(H*H')^-1; % Model Extraction
end