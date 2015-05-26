function signal = signalModel(params, times, irf)
% This function convolves a biexponential with an IRF and returns a vector of
% the values of the singal predicted from the two-exponential decay.
%   
% Function call:
%   signal = signalModel(params, times, irf)
%
% In order to pass it to lsqcurvefit(...), which only takes a function with
% two parameters: the vector of values to fit and a vector of data points to
% evaluate, you must bind an IRF to this function like this:
%   
%   irf = irfData; %eg, its a vector of the irf values already.
%   fitfunc = @(params, times)shortLifetimeModel(params, times, irf);
%   [optimalVals, norms, residuals] = lsqcurvefit(fitfunc, guess, times, data);
%
%   Arguments:
%   params: a vector containing the amplitude A_l at position 1 and lifetime
%     tau_l at position 2, A_s at position 3, and tau_s at position 4.
%   times: a vector containg the times at which to evaluate the function for
%     comparision to signal data.
%   irf: a vector cotaining the IRF data of the same length as times.  Should
%     normalized such that sum(irf) = 1.0.
%   
%   Returns:
%   signal: the predicted signal for comparison to the measured signal and
%     optimization via lsqcurvefit(...), normalized such that 
%       sum(signal) = 1.0.

  model = singleExponential(params(1:2),times)
  model = model + singleExponential(params(3:4),times);
  signalFFT = (fft(model)).*(fft(irf));
  signal = ifft(signalFFT);
end