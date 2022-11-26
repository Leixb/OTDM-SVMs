param m; # rows
param n; # columns

param nu; # regularisation parameter

param y {1..m}; # response vector
param A {1..m, 1..n}; # design matrix

var w {1..n}; # regression coefficients
var gamma; # intercept
var s {1..m}; # slack variables


minimize primal_obj:
    0.5 * sum{j in 1..n}(w[j]^2)
    + nu * sum{i in 1..m} s[i];

subject to primal_c1 {i in 1..m}:
    -y[i]*sum{j in 1..n}(A[i,j]*w[j] + gamma) -s[i] + 1 <= 0;

subject to primal_c2 {i in 1..m}:
    -s[i] <= 0;
