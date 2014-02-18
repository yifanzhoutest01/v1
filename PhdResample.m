totalmass0 = 0;
%totalmass1 = 0;

for pri = 1:size(particles_w, 2)
    totalmass0 = totalmass0 + particles_w(1, pri);
end

[values, inx] = sort(particles_w, 'descend');
newparticles_w = zeros(1, numOfParticles);
newparticles_x = zeros(4, numOfParticles);
for pri = 1:numOfParticles
    newparticles_w(1, pri) = particles_w(1, inx(1, pri)) + particles_w(1, inx(1, size(particles_w, 2)-pri+1));
    newparticles_x(:, pri) = particles_x(:, inx(1, pri));
    %totalmass1 = totalmass1 + particles_w(1, inx(1, pri));
end
particles_x = newparticles_x;
particles_w = newparticles_w;
fprintf('number of targets (estimated): %d  \n', totalmass0);