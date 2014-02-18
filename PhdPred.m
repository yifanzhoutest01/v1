%new positions of the existing particles
%test for github
particles_x = F * particles_x;

%new weight of the existing particles
particles_w = particles_w * ProbOfExist;

%position of new born particles
for ppi = 1:numOfBornParticles
    newborn_particles_x(1, ppi) = rand * (rangeX(2)-rangeX(1)) + rangeX(1);
    newborn_particles_x(2, ppi) = rand * (rangeY(2)-rangeY(1)) + rangeY(1);
    newborn_particles_x(3, ppi) = rand * (rangeVelX(2)-rangeVelX(1)) + rangeVelX(1);
    newborn_particles_x(4, ppi) = rand * (rangeVelY(2)-rangeVelY(1)) + rangeVelY(1);
end

%weight of new born particles
newborn_particles_w = (ProbOfBirth/numOfBornParticles) * ones(1, numOfBornParticles);

particles_x = [particles_x, newborn_particles_x];
particles_w = [particles_w, newborn_particles_w];
% figure(2);
% hold on;
% plot(particles_x(1, :), particles_x(2, :), 'bx');
