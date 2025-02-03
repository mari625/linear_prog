% DATA
array [1..9,1..9] of int: data = 
[|0, 0, 0, 8, 0, 1, 0, 0, 0|
 0, 0, 0, 0, 0, 0, 0, 4, 3|
 5, 0, 0, 0, 0, 0, 0, 0, 0|
 0, 0, 0, 0, 7, 0, 8, 0, 0|
 0, 0, 0, 0, 0, 0, 1, 0, 0|
 0, 0, 0, 0, 0, 0, 0, 0, 0|
 6, 0, 0, 0, 0, 0, 0, 7, 5|
 0, 0, 3, 4, 0, 0, 0, 0, 0|
 0, 0, 0, 2, 0, 0, 6, 0, 0|];

int: M = 100; % big constant
int: N = 9; % number of cells
int: D = 3; % number of squares in row
 
% VARIABLES
array [1..D] of int: mult = [0,1,2]; % multipliers from 0 to 2
array [1..N,1..N] of var 1..N: x; % answer
array [1..N,1..N] of var 0..1: delta;
array [1..N,1..N,1..N] of var 0..1: row_bin;
array [1..N,1..N,1..N] of var 0..1: column_bin;
array [1..D,1..D,1..D,1..D,1..D,1..D] of var 0..1: square_bin;
 
% OBJECTIVE - SATISFY CONSTRAINTS
solve satisfy;
 
% CONSTRAINTS
% filling x_array from given data
constraint forall(i in 1..N, j in 1..N where data[i,j] != 0) (x[i,j] = data[i,j]);

% all different in rows
% 1) row_bin[i,j,k] = 1 if x[i,j] - x[i,k] > 0, else it is 0
constraint forall(i in 1..N, j in 1..N, k in 1..N where j != k) (x[i,j] - x[i,k] - M * (row_bin[i,j,k] - 1) > 0);
% 2) row_bin[i,j,k] = 1 or row_bin[i,k,j] = 1 so x[i,j] != x[i,k]
constraint forall(i in 1..N, j in 1..N, k in 1..N where j != k) (row_bin[i,j,k] + row_bin[i,k,j] = 1);

% all different in columns
% 1) column_bin[i,k] = 1 if x[i,j] - x[k,i] > 0, else it is 0
constraint forall(i in 1..N, j in 1..N, k in 1..N where i != k) (x[i,j] - x[k,j] - M * (column_bin[j,i,k] - 1) > 0);
% 2) column_bin[i,k] = 1 or row_bin[k,i] = 1 so x[i,j] != x[k,j]
constraint forall(j in 1..N, i in 1..N, k in 1..N where i != k) (column_bin[j,i,k] + column_bin[j,k,i] = 1);

% all different in squares
% 1) square_bin[m+1,n+1,i1,j1,i2,j2] = 1 if x[m*D + i1, n*D + j1] - x[m*D + i2, n*D + j2] > 0, else it is 0
constraint forall(m in mult, n in mult, i1 in 1..D, j1 in 1..D, i2 in 1..D, j2 in 1..D where i1 != i2 \/ j1 != j2) (x[m*D + i1, n*D + j1] - x[m*D + i2, n*D + j2] - M * (square_bin[m + 1,n + 1,i1,j1,i2,j2] - 1) > 0);
% 2) square_bin[square_bin[m+1,n+1,i1,j1,i2,j2] = 1 or square_bin[m+1,n+1,i2,j2,i1,j1] = 1 so x[m*D + i1, n*D + j1] != x[m*D + i2, n*D + j2]
constraint forall(m in mult, n in mult, i1 in 1..D, j1 in 1..D, i2 in 1..D, j2 in 1..D where i1 != i2 \/ j1 != j2) (square_bin[m+1,n+1,i1,j1,i2,j2] + square_bin[m+1,n+1,i2,j2,i1,j1] = 1);

