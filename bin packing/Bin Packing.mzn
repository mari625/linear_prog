% BIN PACKING PROBLEM
% There are n items with different weights and m bins with equal capacity. These items should be packed into bins such that 
% total weight of items packed into one bin doesn't exceed capacity of this bin. Find minimal number of required bins. 

% DATA
int: num_stuff;                    % number of things to pack
array[1..num_stuff] of int: stuff; % the weight of the things to pack
int: bin_capacity;                 % all bins have the same capacity
int: num_bins;                     % total number of bins (some of them can be empty)

% VARIABLES
% matrix that shows if bin j includes thing i
array[1..num_stuff, 1..num_bins] of var 0..1: x;
% matrix that shows if bin is included
array[1..num_bins] of var 0..1: y;
% number of bins needed
var int: true_bin_nums = sum(j in 1..num_bins)(y[j]);
% matrix of binary variables
array[1..num_bins] of var 0..1: delta;
% sum of weights
var int: M = sum(i in 1..num_stuff)(stuff[i]);

% OBJECTIVE
solve minimize true_bin_nums;

% CONSTRAINTS
% sum of stuff weights less than capacity
constraint forall (j in 1..num_bins) (sum(i in 1..num_stuff)(x[i,j]*stuff[i]) <= bin_capacity);
% each stuff lies in one bin
constraint forall (i in 1..num_stuff) (sum(j in 1..num_bins) (x[i,j]) = 1);
% if number of stuffs in bin more than 0 there is 1 in y array and the opposite
constraint forall (j in 1..num_bins) (delta[j] <= sum(i in 1..num_stuff)(x[i,j]) /\ delta[j]*M >= sum(i in 1..num_stuff)(x[i,j]) /\ y[j] = delta[j]);