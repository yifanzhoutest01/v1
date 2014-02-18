PhdInit

%Initialize the two targets in the very begining
for i = 1:2
    initPosition = [rand*100-50; rand*100-50];
    initSpeed = [rand*sigmaSpeed-meanSpeed; rand*sigmaSpeed-meanSpeed];
    initOneTarget.stateSpace = [initPosition; initSpeed];
    initOneTarget.measurementSpace = [initPosition(1, 1)+randn*sigma; initPosition(2, 1)+randn*sigma];
    initOneTarget.startTime = 1;
    targets{1, i} = initOneTarget;
end

%some targets may born
if rand < ProbOfBirth
    initPosition = [rand*100-50; rand*100-50];
    initSpeed = [rand*sigmaSpeed-meanSpeed; rand*sigmaSpeed-meanSpeed];
    initOneTarget.stateSpace = [initPosition; initSpeed];
    initOneTarget.measurementSpace = [initPosition(1, 1)+randn*sigma; initPosition(2, 1)+randn*sigma];
    initOneTarget.startTime = 1;
    targets{1, end+1} = initOneTarget;
end

for j = 1:poissrnd(sigmaClutter)
    clutters{1, 1} = [clutters{1, 1}, [rand*200-100; rand*200-100]];
end

Z = [];
for j = 1:size(targets, 2)
    if targets{1, j}.alive
        Z = [Z, [targets{1, j}.measurementSpace(1, 1); targets{1, j}.measurementSpace(2, 1)]];
    end
end
Z = [Z, clutters{1, 1}];

%eliminate nan in measurement
new_Z = [];
for elnan = 1:size(Z, 2)
    if ~isnan(Z(1, elnan))
        new_Z(:, end+1) = Z(:, elnan);
    end
end
Z = new_Z;

PhdUpd
PhdResample

numtarget = 0;
for nt1 = 1:size(targets, 2)
    if targets{1, nt1}.alive
        numtarget = numtarget + 1;
    end
end
fprintf('number of targets (real): %d  \n', numtarget);
fprintf('number of detected targets: %d \n', size(Z, 2));
fprintf('The number of iteration: %d, finished! \n', i);

%do the for-loop of generate points
for i =2:numSim
    PhdPred
    %Some target will die
    for j = 1:size(targets, 2)
        if  targets{1, j}.alive && rand < ProbOfDeath
            targets{1, j}.alive = false;
            targets{1, j}.endTime = i-1;
        end
    end
    
    %for other undead targets
    for j = 1:size(targets, 2)
        if targets{1, j}.alive
            targets{1, j}.stateSpace(:, end+1) = F * targets{1, j}.stateSpace(:, end);
            if rand < ProbOfDetection
                targets{1, j}.measurementSpace(:, end+1) = [targets{1, j}.stateSpace(1, end)+randn*sigma; targets{1, j}.stateSpace(2, end)+randn*sigma];
            else
                targets{1, j}.measurementSpace(:, end+1) = [nan; nan];
            end
        end
    end
    
    %some targets may born
    if rand < ProbOfBirth
        initPosition = [rand*100-50; rand*100-50];
        initSpeed = [rand*sigmaSpeed-meanSpeed; rand*sigmaSpeed-meanSpeed];
        initOneTarget.stateSpace = [initPosition; initSpeed];
        initOneTarget.measurementSpace = [initPosition(1, 1)+randn*sigma; initPosition(2, 1)+randn*sigma];
        initOneTarget.startTime = i;
        targets{1, end+1} = initOneTarget;
    end
    
    %Add some clutter into the system.
    for j = 1:poissrnd(sigmaClutter)
        clutters{1, i} = [clutters{1, i}, [rand*200-100; rand*200-100]];
    end
    
    %changing velocity randomly
    if mod(i, velTime) == 0
        for j = 1:size(targets, 2)
            if targets{1, j}.alive
                targets{1, j}.stateSpace(3, end) = rand*sigmaSpeed-meanSpeed;
                targets{1, j}.stateSpace(4, end) = rand*sigmaSpeed-meanSpeed;
            end
        end
    end
    
    Z = [];
    for j = 1:size(targets, 2)
        if targets{1, j}.alive
            Z = [Z, [targets{1, j}.measurementSpace(1, end); targets{1, j}.measurementSpace(2, end)]];
        end
    end
    Z = [Z, clutters{1, i}];
    %eliminate nan in measurement
    new_Z = [];
    for elnan = 1:size(Z, 2)
        if ~isnan(Z(1, elnan))
            new_Z(:, end+1) = Z(:, elnan);
        end
    end
    Z = new_Z;
    PhdUpd
    PhdResample
    %     figure(1);
    %     hold on;
    %     axis([rangeX, rangeY]);
    %     for j = 1:size(targets, 2)
    %         for k = 1:size(targets{1, j}.measurementSpace, 2)
    %             plot(targets{1, j}.measurementSpace(1, k), targets{1, j}.measurementSpace(2, k), 'kx');
    %         end
    %     end
    %
    %     for j = 1:size(clutters{1, i}, 2)
    %         plot(clutters{1, i}(1, j), clutters{1, i}(2, j), 'ro');
    %     end
    %     xlabel('x-axis');
    %     ylabel('y-axis');
    %     pause(0.1);
    %     hold off;
    %     plot(1, 1);
    
    numtarget = 0;
    for nt1 = 1:size(targets, 2)
        if targets{1, nt1}.alive
            numtarget = numtarget + 1;
        end
    end
    fprintf('number of targets (real): %d  \n', numtarget);
    fprintf('number of detected targets: %d \n', size(Z, 2));
    fprintf('The number of iteration: %d, finished! \n', i);
    PhdShow
    pause(0.1);
end

%adjust endTime
for j = 1:size(targets, 2)
    if targets{1, j}.alive
        targets{1, j}.endTime = numSim;
    end
end

% figure(2);
% hold on;
% axis([rangeX, rangeY]);
% plot(targets{1, 1}.measurementSpace(1, :), targets{1, 1}.measurementSpace(2, :), 'b.');
% plot(targets{1, 2}.measurementSpace(1, :), targets{1, 2}.measurementSpace(2, :), 'r.');
% plot(targets{1, 3}.measurementSpace(1, :), targets{1, 3}.measurementSpace(2, :), 'y.');
% plot(targets{1, 4}.measurementSpace(1, :), targets{1, 4}.measurementSpace(2, :), 'c.');
% xlabel('x-axis');
% ylabel('y-axis');
%
% figure(3);
% hold on;
% axis([1, numSim, rangeX]);
% plot(targets{1, 1}.startTime:targets{1, 1}.endTime, targets{1, 1}.measurementSpace(1, :), 'b.');
% plot(targets{1, 2}.startTime:targets{1, 2}.endTime, targets{1, 2}.measurementSpace(1, :), 'r.');
% plot(targets{1, 3}.startTime:targets{1, 3}.endTime, targets{1, 3}.measurementSpace(1, :), 'y.');
% plot(targets{1, 4}.startTime:targets{1, 4}.endTime, targets{1, 4}.measurementSpace(1, :), 'c.');
% xlabel('time');
% ylabel('x-axis');
%
% figure(4);
% hold on;
% axis([1, numSim, rangeY]);
% plot(targets{1, 1}.startTime:targets{1, 1}.endTime, targets{1, 1}.measurementSpace(2, :), 'b.');
% plot(targets{1, 2}.startTime:targets{1, 2}.endTime, targets{1, 2}.measurementSpace(2, :), 'r.');
% plot(targets{1, 3}.startTime:targets{1, 3}.endTime, targets{1, 3}.measurementSpace(2, :), 'y.');
% plot(targets{1, 4}.startTime:targets{1, 4}.endTime, targets{1, 4}.measurementSpace(2, :), 'c.');
% xlabel('time');
% ylabel('y-axis');