%% define data lenghts
n = 4096;
irfTime = 200;

gridpoints = 2;

t = linspace(0, n, n);

irf = normpdf(t, irfTime, 50);
irf = irf/sum(irf);

A_l = 300;
tau_l = 2000;
A_s = 500;
tau_s = 500;
params = [A_l tau_l A_s tau_s];

signal = signalModel(params, t, irf);

figure;
plot(t, irf);
hold on;
scatter(t, signal);

%% fit long lifetime
[p_l, s_l] = polyfit(t(n-long:n),log(signal(n-long:n)),1);
%param_l0(1) = exp(p_l(2));
%param_l0(2) = -1.0/p_l(1);
%figure;
%scatter(t(n-long:n),log(signal(n-long:n)));
%hold on;
%plot(t,polyval(p_l,t));

%% brute-force: hulk is angry...! hulk smasssshhhh!
% suppress a bunch of diagnostics
gridpoints = [4 4 4 4]
func = @(params, times)signalModel(params, times, irf);
[opt, resNorm, res] = fourParamFit(func, t, signal, [100, 1500, 100, 250], [1000 4096 1000 4096], [4 4 4 4])

figure;
scatter(t, signal);
hold on;
plot(t, signalModel(opt, t, irf));
figure;
scatter(t,r(:,iMin,jMin,kMin,lMin));
