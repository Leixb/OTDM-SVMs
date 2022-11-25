set N; # data points
param x{N}; # data points
param y{N}; # labels
var w; # weight vector
var b; # bias
minimize obj: 0.5 * w^2;
subject to constr{i in N}: y[i] * (w * x[i] + b) >= 1;
