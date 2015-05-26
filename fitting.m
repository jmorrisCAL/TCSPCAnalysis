%% define data lenghts
n = 64;
irfTime = 8;
long = 16;
short = 16;

%% define data
t = linspace(0, 1, n);

irf = 0*t;
irf(irfTime) = .25;
irf(irfTime+1) = 1;
irf(irfTime+2) = .8;
irf(irfTime+3) = .125;
irf(irfTime+4) = .0625;
irf = irf/sum(irf);

A_l = .75;
tau_l = .75;
A_s = .25;
tau_s = .25;

data = A_l*exp(-t/tau_l)+A_s*exp(-t/tau_s);
data = data/sum(data);
signal = ifft(fft(data).*fft(irf));

figure;
plot(t, irf);
hold on;
scatter(t, signal);

%% fit long lifetime
[p_l, s_l] = polyfit(t(n-long:n),log(signal(n-long:n)),1);
figure;
scatter(t(n-long:n),log(signal(n-long:n)));
hold on;
plot(t,polyval(p_l,t));

%% subtract long lifetime
params_l(1) = exp(p_l(2));
params_l(2) = -1.0/p_l(1);
subtracted = signal - singleExponential(params_l,t);
%subtracted(subtracted<0) = 0;

figure;
plot(t, subtracted);
hold on;
% show that deconvolving is bad...
deconvolved = ifft(fft(subtracted)./fft(irf));
plot(t, deconvolved);

options = optimoptions('lsqcurvefit');
problem = createOptimProblem('lsqcurvefit', ...
                             'objective', @(params,times)subtractedSignalModel(params,times,irf), ...
                             'xdata', t, 'ydata', subtracted, ...
                             'x0',ones(1,2),...
                             'lb', [0 0],...
                             'ub', [1 1])
b = lsqcurvefit(problem)
ms = MultiStart
[b,fval,exitflag,output,solutions] = run(ms, problem, 50);




% calculate what the response is expected to be from deconvolution, get an
% inital guess for fitting.
%response = ifft(fft(data)./fft(irf));
%[p, s] = polyfit(t(1:5), log(response(1:5)), 1); % this avoids where it's zero.
%param0(1) = exp(p(2));
%param0(2) = -1.0/p(1);

%func = @(fitValues, times)subtractedSignalModel(fitValues, times, irf);
%optVals = lsqcurvefit(func, param0, t, data, [.1, .1], [.8, .8])
