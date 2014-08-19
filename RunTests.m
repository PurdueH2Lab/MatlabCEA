% This script runs all the test scripts in the tests folder

clear all
close all
clc

testScripts = dir(fullfile('tests','*.m'));
addpath('tests');

for i = 1:length(testScripts)
    functionName = testScripts(i).name(1:end-2);
    fprintf('Running Test %d of %d - %s\n', ...
            i,length(testScripts),functionName);
    testFcn = str2func(functionName);
    testFcn();
end