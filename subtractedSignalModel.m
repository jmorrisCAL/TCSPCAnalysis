function signal = subtractedSignalModel(params, times, irf)
% This function convolves a single exponential model with an IRF and returns
% a calculated long-lifetime subtracted signal containing only the short
% lifetime component and the IRF.
%
% Function call:
%   signal = subtractedSignalModel(params, times, irf)
%
% In order to pass it to lsqcurvefit(...), which only takes a function with
% two parameters: the vector of values to fit and a vector of data points to
% evaluate, you must bind an IRF to this function like this:
%   
%   irf = irfData; %eg, its a vector of the irf values already.
%   fitfunc = @(params, times)subtractedSignalModel(params, times, irf);
%   [optimalVals, norms, residuals] = lsqcurvefit(fitfunc, guess, times, data);
%
%   Arguments:
%   params: a vector containing the amplitude A_s at position 1 and lifetime
%     tau_s at position 2 to fit.
%   times: a vector containg the times at which to evaluate the function for
%     comparision to signal data.
%   irf: a vector cotaining the IRF data of the same length as times.  Should
%     normalized such that sum(irf) = 1.0.
%   
%   Returns:
%   signal: the predicted signal for comparison to the measured signal and
%     optimization via lsqcurvefit(...), normalized such that 
%       sum(signal) = 1.0.

  model = singleExponential(params,times);
  signalFFT = (fft(model)).*(fft(irf));
  signal = ifft(signalFFT);
end
