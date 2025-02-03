%DATA
% planning horizon
int: T = 365;
% food ids: 1 to F
int: F = 77;
% nutrient ids: 1 to N
int: N = 9;
% allowed violation of nutrition target
float: delta = 0.1;
% nutrition target per day
array[1..N] of float: k;
% food nutrition per 1$ (1939)
array[1..F, 1..N] of float: s;
% VARIABLES
% money spent on each type of food
array[1..F] of var float: x;
% total cost
var float: cost = sum(j in 1..F)(x[j]);

% OBJECTIVE - MINIMIZE TOTAL COST
solve minimize cost;

% CONSTRAINTS
constraint forall(i in 1..N) (sum(j in 1..F)(s[j,i]*x[j]) >= (1-delta)*k[i]*T);
constraint forall(i in 1..N) (sum(j in 1..F)(s[j,i]*x[j]) <= (1+delta)*k[i]*T);
constraint forall(j in 1..F) (x[j]>=0);


