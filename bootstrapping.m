%% Make up data
nData = 200;
a = ones(2,nData);
a(1,:) = a(1,:)*300;
a(2,:) = a(2,:)*100;
a = normrnd(a, 20);

tau = ones(2,nData);
tau(1,:) = tau(1,:)*1.8;
tau(2,:) = tau(2,:)*.7;
tau = normrnd(tau, .05);

%% Calculate average lifetime for each curve (ie, before averaging components
% across curves.)
avgTau = avgLifetime(a, tau);

%% Calculate mean average lifetime accross the curves and std error on mean 
% assuming gaussian statistics as a benchmark/test case 
meanTau = mean(avgTau);
stdErrTau = std(avgTau)/sqrt(nData);
gausCI = [meanTau, meanTau - stdErrTau, meanTau + stdErrTau];

%% Apply bootstrapping to estimate the confidence interval instead
[bootCI, samples] = bootstrap(avgTau, 1000);

%% Analyse Results
fprintf('Bootstrapped mean and confidence interval:\n');
disp(bootCI);
fprintf('Abs val of differences between Gaussian and Bootstrap methods:\n');
disp(abs(gausCI - bootCI));
fprintf('Result of Lillefors Test [h p]: (0 -> gaussian, 1 -> not)\n');
[h, p] = lillietest(avgTau);
disp([h, p]);

% Plot the Input Data with confidence interval on the mean
figure;
ax = axes;
hist(ax,avgTau);
line([bootCI(1) bootCI(1)],get(ax,'YLim'), 'Color', 'r');
line([bootCI(2) bootCI(2)],get(ax,'YLim'), 'Color', 'r');
title('Amplitude Weighted Lifetimes from Data');
xlabel('Lifetime (ns)');
ylabel('Pr(Lifetime)');

% Plot Bootstrapped mean distribution and the confidence interval
figure;
ax = axes;
hist(ax,mean(samples, 2));
line([bootCI(1) bootCI(1)],get(ax,'YLim'), 'Color', 'r');
line([bootCI(2) bootCI(2)],get(ax,'YLim'), 'Color', 'r');
title('Distributions of Means from Bootstrap Sampling');
xlabel('Mean of Amplitude Weighted Lifetimes (ns)');
ylabel('Pr(Mean)');




