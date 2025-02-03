%DATA
% vertice ids 1 to N
int: N = 9;
% vertex a
%case 1
int: a = 1;
%case 2
%int: a = 2;
%case 3
%int: a = 4;

% vertex b
%case 1
int: b = 9;
%case 2
%int: b = 8;
%case 3
%int: b = 2;

% edge distances matrix 
array[1..N, 1..N] of int: l = 
[|0, 8, 12, -1, -1, -1, -1, -1, -1|
 -1, 0, 13, 25, 9, -1, -1, -1, -1|
 -1, -1, 0, 14, -1, -1, 21, -1, -1|
 -1, -1, -1, 0, 20, 8, 12, 12, 16|
 -1, 9, -1, -1, 0, 19, -1, -1, -1|
 -1, -1, -1, -1, -1, 0, -1, 11, -1|
 -1, -1, -1, -1, -1, -1, 0, -1, 11|
 -1, -1, -1, -1, -1, -1, -1, 0, 9|
 -1, -1, -1, -1, -1, -1, -1, -1, 0|];
 
% VARIABLES
array[1..N, 1..N] of var 0..1: x;
array[1..N] of var 0..1: first;
array[1..N] of var 0..1: second;
var int: dist = sum(i in 1..N, j in 1..N)(x[i,j]*l[i,j]);
var int: M = N*N;

% OBJECTIVE - minimize dist
solve minimize dist;

% CONSTRAINTS
% x[i,j] = 0 if length = -1
constraint forall(i in 1..N, j in 1..N where l[i,j] = -1) (x[i,j] = 0);
% first[a] = 1, first[i] = 0 if i != a
constraint (forall(i in 1..N where i != a) (first[i] = 0)) /\ first[a] = 1;
% second[b] = 1, second[i] = 0 if i != b
constraint (forall(i in 1..N where i != b) (second[i] = 0)) /\ second[b] = 1;
% sum of incoming edges equals to sum of outcoming edges to every vertex (except for begining and end)
constraint forall(i in 1..N) (sum(k in 1..N where l[k,i] != -1)(x[k,i]) + first[i] = sum(k in 1..N where l[i,k] > 0)(x[i,k]) + second[i]);