%Filter parameters
numOfParticles = 100;
numOfBornParticles = 600;

%The varience used in the likelihood
varLikelihood = [1, 0; 0, 1];

%environment parameters
rangeX = [-100, 100];
rangeY = [-100, 100];
rangeVelX = [-1, 1];
rangeVelY = [-1, 1];
% varX = ;
% varY = ;
% varVelX = ;
% varVelY = ;
ProbOfExist = 0.95;
ProbOfDetect = 0.95;
numOfClutter = 10;

%transition function
dt = 1;
F = [1, 0, dt, 0; 0, 1, 0, dt; 0, 0, 1, 0; 0, 0, 0, 1];

%create particles
particles_w = (1/numOfParticles) * ones(1, numOfParticles);
particles_x = zeros(4, numOfParticles);
for pui = 1:numOfParticles
    particles_x(1, pui) = rand * (rangeX(2)-rangeX(1)) + rangeX(1);
    particles_x(2, pui) = rand * (rangeY(2)-rangeY(1)) + rangeY(1);
    particles_x(3, pui) = rand * (rangeVelX(2)-rangeVelX(1)) + rangeVelX(1);
    particles_x(4, pui) = rand * (rangeVelY(2)-rangeVelY(1)) + rangeVelY(1);
end
% figure(1);
% plot(particles_x(1, :), particles_x(2, :), 'bx');
