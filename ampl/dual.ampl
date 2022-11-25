set N; # data points
param x{N}; # data points
param y{N}; # labels
var alpha{N} >= 0; # Lagrange multipliers
maximize obj: sum{i in N} alpha[i] - 0.5 * sum{i in N, j in N} alpha[i] * alpha[j] * y[i] * y[j] * x[i]^T * x[j];
subject to constr{i in N}: sum{i in N} alpha[i] * y[i] = 0;
