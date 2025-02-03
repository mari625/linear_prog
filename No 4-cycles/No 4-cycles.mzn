% DATA
int: N = 7; %8
int: M = 100; %big constant

% VARIABLES
% graph
array [1..N,1..N] of var 0..1: x;
% number of verticles (I was not sure, if vertex can't be connected to itself, so decided to consider that it can. If it is not so, second term should be zero and sum would be less by N)
var float: num_edges = sum(i in 1..N, j in 1..N where i != j) (x[i,j]) / 2 + sum(i in 1..N) (x[i,i]);

% OBJECTIVE - MAXIMIZE NUMBER OF EDGES
solve maximize num_edges;

% CONSTRAINTS
% no 4-circles
% 1) sums_bigger[i,j,k,m] = 1 if x[i,j] + x[j,k] + x[k,m] + x[m,i] > 4, else it is 0
constraint forall(i in 1..N, j in 1..N, k in 1..N, m in 1..N where i != j /\ i != k /\ i != m /\ j != k /\ j != m /\ k != m) (x[i,j] + x[j,k] + x[k,m] + x[m,i] < 4);

% correct edges
constraint forall(i in 1..N, j in 1..N) (x[i,j] = x[j,i]);
