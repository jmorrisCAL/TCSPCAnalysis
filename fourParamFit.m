function [opt,resNorm,res] = fourParamFit(functionHandle, ...
                                          xData, ...
                                          yData, ...
                                          lowerBound, ...
                                          upperBound, ...
                                          gridpoints)
  % function [opt,resNorm,res] = fourParamFit(functionHandle, ...
  %                                                xData, ...
  %                                                yData, ...
  %                                                upperBound, ...
  %                                                lowerBound, ...
  %                                                gridpoints)
  % 
  % Description: fourParamFit fits four parameters of a nonlinear model to data
  %   using a specifed number of gridpoints for each parameter between the
  %   upper and lower bounds and returns the optimum parameters determined by
  %   the global minimum of the norm of the residuals of the fit. 
  % 
  % Arguments:
  %
  %   functionHandle: a function handle that takes two parameters, a vector of
  %     the variable parameters to fit and a vector of the xData on which to
  %     evaluate the function.  To pass additional fixed parameters to the
  %     function, use the matlab expression
  %       func2Param = @(params, xData)func3Param(params, xData, fixed);
  %     to bind the fixed parameters to the function call func2Param that is
  %     then passed to fourParamFit.
  %
  %   xData: a vector of the xData.  It must be of the same length as yData.
  %   
  %   yData: a vector of the yData.  It must be of the same length as xData.
  %
  %   lowerBound: a vector containing the lower bounds of the parameters
  %     contained in the params passed to functionHandle(...).  It must be the
  %     same length as the params vector to be passed to functionHandle(...).
  %
  %   upperBound: a vector containing the upper bounds of the parameters
  %     contained in the params passed to functionHandle(...).  It must be the
  %     same length as the params vector to be passed to functionHandle(...).
  %
  %   gridpoints: a vector containing the integer number of gridpoints to
  %     create the inital guesses for each paramter between the upper and lower
  %     bounds of the parameter.
  %
  opts = optimset('Display','off');
  p = zeros(4, gridpoints(1), gridpoints(2), gridpoints(3), gridpoints(4));
  s = zeros(gridpoints(1), gridpoints(2), gridpoints(3), gridpoints(4));
  r = zeros(length(xData), ...
            gridpoints(1), ...
            gridpoints(2), ...
            gridpoints(3), ...
            gridpoints(4));
  
  grid = zeros(4, gridpoints(1), gridpoints(2), gridpoints(3), gridpoints(4));
  grid(1,:,1,1,1) = linspace(lowerBound(1),upperBound(1),gridpoints(1));
  grid(2,1,:,1,1) = linspace(lowerBound(2),upperBound(2),gridpoints(2));
  grid(3,1,1,:,1) = linspace(lowerBound(3),upperBound(3),gridpoints(3));
  grid(4,1,1,1,:) = linspace(lowerBound(4),upperBound(4),gridpoints(4));

  for i = 1:gridpoints(1)
    for j = 1:gridpoints(2)
      for k = 1:gridpoints(3)
        for l = 1:gridpoints(4)
          p0 = [grid(1,i,1,1,1), ...
                grid(2,1,j,1,1), ...
                grid(3,1,1,k,1), ... 
                grid(4,1,1,1,l)];
          [p(:,i,j,k,l), s(i,j,k,l), r(:,i,j,k,l)] = lsqcurvefit( ...
                                                       functionHandle, ...
                                                       p0, ...
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
