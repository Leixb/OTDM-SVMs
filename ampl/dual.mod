param n; # rows
param m; # columns

param nu; # regularisation parameter

param y {1..m}; # response vector
param A {1..m, 1..n}; # design matrix

# K = AA^T
# param K{(i,j), i in 1..m, j in 1..m} = sum{k in 1..n} A[i,k]*A[j,k];
# param K{i in 1..m, j in 1..m} = sum{k in 1..n} A[i,k]*A[j,k];
param K{1..m, 1..m};
let {i in 1..m, j in 1..m} K[i,j] := sum{k in 1..n} A[i,k]*A[j,k];

var lambda {1..m} >= 0, <= n; # lagrange multipliers

minimize dual_obj:
    sum{i in 1..m} lambda[i]
    - 0.5*sum{i in 1..m, j in 1..m} lambda[i]*lambda[j]*y[i]*y[j]*K[i,j]

subject to dual_c1:
    sum{i in 1..m} lambda[i]*y[i] = 0;
