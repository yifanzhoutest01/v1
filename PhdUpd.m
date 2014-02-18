%Z is the observation matrix, dimension * targets
C = zeros(1, size(Z, 2));
parfor pui = 1:size(Z, 2)
    for puj = 1:size(particles_x, 2)
        C(1, pui) = C(1, pui) + (ProbOfDetect * mvnpdf([Z(1, pui)-particles_x(1, puj); Z(2, pui)-particles_x(2, puj)], [0; 0], varLikelihood)) * particles_w(1, puj);
        %C(1, pui) = C(1, pui) + ProbOfDetect * normpdf( sqrt( (Z(1, pui) - particles_x(1, puj))^2 + (Z(2, pui) - particles_x(2, puj))^2), 0, 1.414 ) * particles_w(1, puj);
    end
end

new_particles_w = zeros(1, size(particles_w, 2));
parfor pui = 1:size(new_particles_w, 2)
    tempsum = 0;
    for puj = 1:size(Z, 2)
        likelihood = ProbOfDetect * mvnpdf([Z(1, puj)-particles_x(1, pui); Z(2, puj)-particles_x(2, pui)], [0; 0], varLikelihood);
        %likelihood = ProbOfDetect * normpdf( sqrt( (Z(1, puj) - particles_x(1, pui))^2 + (Z(2, puj) - particles_x(2, pui))^2 ), 0, 1.414 );
        tempsum = tempsum + likelihood/(numOfClutter*0.00001 + C(1, puj));
    end
    new_particles_w(1, pui) = (1-ProbOfDetect + tempsum)*particles_w(1, pui);
end

particles_w = new_particles_w;