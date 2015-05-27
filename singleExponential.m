function model = singleExponential(params, times)
% This function returns the single exponential decay for a vector of params
% evaluated at a vector of times.
%   
% Function call:
%   model = singleExponential(params, times)
%
%   Arguments:
%   params: a vector containing the amplitude at position 1 and lifetime at
%     position 2 to fit.
%   times: a vector containg the times at which to evaluate the function for
%     comparision to signal data.
%   
%   Returns:
%   model: the predicted single exponential decay normalized such that 
%       sum(model) = 1.0.

  a = params(1);
  tau = params(2);
  model = a.*exp(-times./tau);
end
