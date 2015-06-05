function [tauAvg] = avgLifetime(a, tau)
  % function [tauAvg] = avgLifetime(a, tau)
  %
  % Description:
  %   avgLifetime(...) calculates amplitue weighted lifetimes for decays.
  %
  % Arguments:
  %   a: a (numAmplitues, numSamples) matrix containing the amplitues
  %     eg for a set of curves containing two components, with the amplitudes 
  %     Al and As, 
  %     a = [ Al1 Al2 Al3 ... Aln
  %           As1 As2 As3 ... Asn]
  %   tau: a (numLifetimes, numSamples) matrix containign the lifetimes in the
  %     same format as a above.
  %
  % Return value:
  %   tauAvg a (1,numSamples) row vector containing the amplitude weighted
  %     lifetimes of each sample.
  tauAvg = NaN(1,max(size(a)));
  for i = 1:max(size(a))
    tauAvg(i) = sum(a(:,i).*tau(:,i))/sum(a(:,i));
  end
end
