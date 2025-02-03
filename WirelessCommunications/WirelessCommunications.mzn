% SCHEDULING IN WIRELESS COMMUNICATIONS

% A cellular base station can transmit data to N users (e.g. mobile phones) using a fixed set of M frequencies, 
% and the base station can use these frequencies simultaneously and independently. For each discrete time moment t = 0, ..., T-1 
% for each frequency m = 0, ..., M-1 the base station can choose a user n = 0, ..., N-1 to transmit some data to it. 
% Let R_{m, n} be the rate of the user n on the frequency m, i.e. the amount of bits that the base station can transmit 
% to the user n on the frequency m in one time moment. 
    
% For each user n there is a data packet of the size D_n bits, and the base station needs to transmit it to the user n
% before its deadline tau_n. This means that the base station has tau_n time moments to send to the user n at least D_n bits
% of data summarily, and if this happens, the user n is called served. The problem is the following: maximize the number of served users.
    
% Input
int: N; % = the number of users,
int: M; % = the number of frequencies,
int: T; % = the number of time moments that we consider,
array[1..M, 1..N] of int: R; % = the MxN-matrix of rates: R_{m, n} \in \mathbb{N} is the rate of the user n on the frequency m,
array[1..N] of int: D; % = the vector of sizes of packets: D_n\in \mathbb{N} is the packet size of the user n,
array[1..N] of int: tau; % = the vector of deadlines: tau_n \in \mathbb{N} is the deadline of the user n; it is guaranteed that tau_n < T.

% Output
%    L = maximum number of served users,
%    y = Boolean vector of length N such that y_n = 1 if the user n is served, and y_n = 0 otherwise.  
%    A = the TxM-matrix representing an optimal solution: if at a time moment t on a frequency m 
%        the base station transmitted data to a user n then A_{t, m} = n. If the base station transmitted 
%        nothing at this moment on this frequency then A_{t, m} = -1. 

% VARIABLES
array[1..N] of var 0..1: y;
array[1..T,1..M] of var -1..N: A;
var int: L = sum(i in 1..N)(y[i]);

% x_ntm = 1 <=> A_tm = n (frequency m is used in time t by user n)
array[1..N,1..T,1..M] of var 0..1: x;

array[1..N,1..T,1..M,1..2] of var 0..1: z;

% CONSTANT
int: W = sum(i in 1..N)(D[i]);
int: V = sum(i in 1..N)(i);

% OBJECTIVE - MAXIMIZE NUMBER OF SERVED
solve maximize L;

% CONSTRAINTS
% x_ntm = 1 <=> A_tm = n
constraint forall(n in 1..N, t in 1..T, m in 1..M) (A[t,m] <= n + V*(1 - x[n,t,m]) /\ A[t,m] >= n - V*(1 - x[n,t,m]));
% z_ntm1 = 1 <=> A[t,m] > n - V*x[n,t,m]
constraint forall(n in 1..N, t in 1..T, m in 1..M) (A[t,m] - n + V*x[n,t,m] > V*V*(z[n,t,m,1] - 1) /\ A[t,m] - n + V*x[n,t,m] <= V*V*z[n,t,m,1]);
% z_ntm2 = 1 <=> A[t,m] < n + V*x[n,t,m])
constraint forall(n in 1..N, t in 1..T, m in 1..M) (A[t,m] - n - V*x[n,t,m] < V*V*(1 - z[n,t,m,2]) /\ A[t,m] - n - V*x[n,t,m] >= - V*V*z[n,t,m,2]);
% A[t,m] > n - V*x[n,t,m] \/ A[t,m] < n + V*x[n,t,m]
constraint forall(n in 1..N, t in 1..T, m in 1..M) (z[n,t,m,1] + z[n,t,m,2] >= 1);

% for only one n x_ntm can be equal to 1
constraint forall(t in 1..T, m in 1..M) (sum(n in 1..N)(x[n,t,m]) <= 1);

% sum x_ntm = 0 => A_tm = -1
constraint forall(t in 1..T, m in 1..M) (A[t,m] <= -1 + W*sum(n in 1..N)(x[n,t,m]));

% y_n = 1 <=> task made (task made if sum(x[n,t,m]*R[m,n]) >= D[n])
constraint forall(n in 1..N) (sum(t in 1..T, m in 1..M)(x[n,t,m]*R[m,n]) >= D[n] + W*(y[n] - 1) /\ sum(t in 1..T, m in 1..M)(x[n,t,m]*R[m,n]) < D[n] + W*y[n]);

% no attempts to finish task after deadline if for t > tau[n]: x[n,t,m] = 0
% this constraint is stronger, than necessary. Client can be attended after deadline, but it won't help to maximize number of served clients. For the exact constraint 'each client is served in time' the previous constraint should include sums where t in 1..tau[n] 
constraint forall(n in 1..N, m in 1..M, t in 1..T where t > tau[n]) (x[n,t,m] = 0);
