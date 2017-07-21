clear
clc
close all

%load Results_classification.mat
load('results/20170705-Female_results.mat')
[X,Y,T,AUC] = perfcurve(out.realLabel,out.probValues(:,1), 1);
plot(X,Y, 'LineWidth', 2)
grid on
lgd = legend(['AUC = ', num2str(AUC)])
lgd.FontSize = 13;

title('ROC curve for female subjects')
xlabel('False positive rate')
ylabel('True positive rate')
