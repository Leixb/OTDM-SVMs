# vim:ft=ampl:

param n; # rows
param m; # columns

param nu; # regularisation parameter

param y {1..m}; # response vector
param A {1..m, 1..n}; # design matrix

# Precompute y_i*y_j*K_ij, K=AA^T
/* param yK{i in 1..m, j in 1..m} = sum{k in 1..n} y[i]*y[j]*A[i,k]*A[j,k]; */
param yK{i in 1..m, j in 1..m} = y[i]*y[j]*sum{k in 1..n}A[i,k]*A[j,k];

var lambda {1..m} >= 0, <= nu; # Lagrange multipliers

maximize dual_obj:
    sum{i in 1..m} lambda[i]
    - 0.5*sum{i in 1..m, j in 1..m} lambda[i]*lambda[j]*yK[i,j];

subject to dual_c1:
    sum{i in 1..m} lambda[i]*y[i] = 0;
