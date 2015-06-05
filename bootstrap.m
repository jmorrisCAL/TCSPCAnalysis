function [bCI, samples] = bootstrap(data, nSamples)
% function [bCI, samples] = bootstrap(data, nSamples)
%
% Description: bootstrap(...) uses bootstrap sampling with replacement to
% estimate the mean and confidence interval on the mean of a set of data using
% nSamples.
%
% Arguements:
%   data: a row of data.
%   nSamples: the number of samples to build from the data via sampling with
%     replacement.
%
% Return values:
%   bCI: a (1,3) row vector containing the mean, lower bound, and upper bound.
%   samples: a (nSamples,lenght(data)) matrix containing rows of the samples of
%     data created.
  n = length(data);
  samples = NaN(nSamples, n);
  for i = 1:nSamples
    samples(i,:) = data(randi(n, 1, n));
  end
  means = sort(mean(samples, 2));
  meanVal = mean(means);
  low = means(int64(round(.16*nSamples)));
  high = means(int64(round(.84*nSamples)));
  bCI = [meanVal, low, high];
end
