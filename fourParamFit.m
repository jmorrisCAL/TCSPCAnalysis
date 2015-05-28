function [opt,resNorm,res] = fourParamFit(functionHandle, xData, yData, lowerBound, upperBound, gridpoints)
  % function [opt,resNorm,res] = twoExponentialFit(functionHandle, xData, yData, upperBound, lowerBound, gridpoints)
  % 
  %
  %
  %
  opts = optimset('Display','off');
  p = zeros(4, gridpoints(1), gridpoints(2), gridpoints(3), gridpoints(4));
  s = zeros(gridpoints(1), gridpoints(2), gridpoints(3), gridpoints(4));
  r = zeros(length(xData), gridpoints(1), gridpoints(2), gridpoints(3), gridpoints(4));

  grid = zeros(4, gridpoints(1), gridpoints(2), gridpoints(3), gridpoints(4));
  grid(1,:,1,1,1) = linspace(lowerBound(1),upperBound(1),gridpoints(1));
  grid(2,1,:,1,1) = linspace(lowerBound(2),upperBound(2),gridpoints(2));
  grid(3,1,1,:,1) = linspace(lowerBound(3),upperBound(3),gridpoints(3));
  grid(4,1,1,1,:) = linspace(lowerBound(4),upperBound(4),gridpoints(4));

  for i = 1:gridpoints(1)
    for j = 1:gridpoints(2)
      for k = 1:gridpoints(3)
        for l = 1:gridpoints(4)
          [p(:,i,j,k,l), s(i,j,k,l), r(:,i,j,k,l)] = lsqcurvefit(functionHandle, ...
                                         [grid(1,i,1,1,1) grid(2,1,j,1,1) grid(3,1,1,k,1) grid(4,1,1,1,l)], ...
                                         xData, ...
                                         yData, ...
                                         lowerBound, ...
                                         upperBound, ...
                                         opts);
        end
      end
    end
  end
  
  [minResidual index] = min(s(:));
  [iMin jMin kMin lMin ] = ind2sub(size(s),index);
  
  opt = p(:,iMin,jMin,kMin,lMin);
  resNorm = s(iMin,jMin,kMin,lMin);
  res = r(:,iMin,jMin,kMin,lMin);
end
