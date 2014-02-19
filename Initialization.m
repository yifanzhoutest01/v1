%test pull 02

clear all
close all
clc

%number of simulation
numSim = 1000;

%time of changing veloity
velTime = 50;

%tranisition function
dt = 1;
F = [1, 0, dt, 0; 0 1 0 dt; 0 0 1 0; 0 0 0 1];

%probability of detecting
ProbOfDetection = 0.95;

%probability of target birth
ProbOfBirth = 0.25;

%probability of target death
ProbOfDeath = 0.05;

%Range of the space
rangeX = [-100, 100];
rangeY = [-100, 100];

%standard deviation of the measurement of the noise
sigma = 1;

%speed sigma
sigmaSpeed = 2;
meanSpeed = 1;

%clutter sigma
sigmaClutter = 10;

%At least we will have two targets at the very begining
initOneTarget = struct('stateSpace', [], 'measurementSpace', [], 'alive', true, 'startTime', -1, 'endTime', -1);
targets = cell(1, 2);

%The clutters!
clutters = cell(1, numSim);
