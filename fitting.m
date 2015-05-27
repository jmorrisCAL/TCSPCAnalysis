%% define data lenghts
n = 4096;
irfTime = 200;
long = 16;
short = 16;

gridpoints = 10;

%% define data
t = linspace(0, n, n);

irf = normpdf(t, irfTime, 50);
irf = irf/sum(irf);

A_l = .75;
tau_l = 2000;
A_s = .25;
tau_s = 500;
params = [A_l tau_l A_s tau_s];

A_l0 = linspace(.5, 1, gridpoints);
tau_l0 = linspace(1500, 2500, gridpoints);
A_s0 = linspace(0, .5, gridpoints);
tau_s0 = linspace(250, 750, gridpoints);

data = A_l*exp(-t/tau_l)+A_s*exp(-t/tau_s);
data = data/sum(data);
signal = ifft(fft(data).*fft(irf));

figure;
plot(t, irf);
hold on;
scatter(t, signal);

%% fit long lifetime
[p_l, s_l] = polyfit(t(n-long:n),log(signal(n-long:n)),1);
%figure;
%scatter(t(n-long:n),log(signal(n-long:n)));
%hold on;
%plot(t,polyval(p_l,t));

%% subtract long lifetime
params_l(1) = exp(p_l(2));
params_l(2) = -1.0/p_l(1);
%subtracted = signal - singleExponential(params_l,t);
%subtracted(subtracted<0) = 0;
%subtracted = subtracted / sum(subtracted);

%figure;
%plot(t, subtracted);
%hold on;
% show that deconvolving is bad...
%deconvolved = ifft(fft(subtracted)./fft(irf));
%plot(t, deconvolved);

%% brute-force: hulk is angry...! hulk smasssshhhh!
% suppress a bunch of diagnostics
opts = optimset('Display','off');
p = zeros(4,gridpoints,gridpoints,gridpoints,gridpoints);
s = zeros(gridpoints,gridpoints,gridpoints,gridpoints);
func = @(params, times)signalModel(params, times, irf);
for i = 1:gridpoints
  for j = 1:gridpoints
    for k = 1:gridpoints
      for l = 1:gridpoints
        [p(:,i,j,k,l), s(i,j,k,l)] = lsqcurvefit(func, ...
                                         [A_l0(i) tau_l0(j) A_s0(k) tau_s0(l)], ...
                                         t, ...
                                         signal, ...
                                         [ 0 0 0 0 ], ...
                                         [ 1 n 1 n], ...
                                         opts);
      end
    end
  end
end

[minResidual index] = min(s(:));
[iMin jMin kMin lMin ] = ind2sub(size(s),index);
p(:,iMin,jMin,kMin,lMin)

figure;
scatter(t, signal);
hold on;
plot(t, signalModel(p(:,iMin,jMin), t, irf));

% only works in matlab 2015 or whatever
%options = optimoptions('lsqcurvefit');
%problem = createOptimProblem('lsqcurvefit', ...
%                             'objective', @(params,times)subtractedSignalModel(params,times,irf), ...
%                             'xdata', t, 'ydata', subtracted, ...
%                             'x0',ones(1,2),...
%                             'lb', [0 0],...
%                             'ub', [1 1])
%b = lsqcurvefit(problem)
%ms = MultiStart
%[b,fval,exitflag,output,solutions] = run(ms, problem, 50);




% calculate what the response is expected to be from deconvolution, get an
% inital guess for fitting.
%response = ifft(fft(data)./fft(irf));
%[p, s] = polyfit(t(1:5), log(response(1:5)), 1); % this avoids where it's zero.
%param0(1) = exp(p(2));
%param0(2) = -1.0/p(1);

%func = @(fitValues, times)subtractedSignalModel(fitValues, times, irf);
%optVals = lsqcurvefit(func, param0, t, data, [.1, .1], [.8, .8])
