% SINGLE MACHINE SCHEDULING
% There are n tasks which should be processed by a single machine for the time interval [0,..,T]. We consider only discrete time moments.
% Each task has release time, processing time and deadline. Only one task can be processed by the machine at each time moment. 
% Makespan of given schedule is the completion time of the latest task. Find a minimal makespan schedule.

% DATA
int: T;                  % time horizon
int: n;                  % num tasks
array[1..n] of int: r;   % release times
array[1..n] of int: p;   % processing times
array[1..n] of int: d;   % deadlines

% VARIABLES
% start times
array[1..n] of var int: s;
% end times (only biggest one is not zero)
array[1..n] of var int: e;
% x_ij = 1 if i preceds j
array[1..n, 1..n] of var 0..1: x;
% big constant
int: M = max(i in 1..n) (d[i]) * 10;
% max indicator
array[1..n] of var 0..1: z;

% OBJECTIVE - MINIMIZE LATEST TASK END TIME
solve minimize sum(i in 1..n)(e[i]);

% CONSTRAINTS
% j - task made on time
constraint forall (j in 1..n) (s[j] >= r[j] /\ s[j] <= d[j] - p[j] + 1);
% if x_ij = 1 than (s_j - s_i) >= p_i
constraint forall (i in 1..n , j in 1..n where i != j) (s[j] - s[i] >= M*(x[i,j] - 1) + p[i]);
% x_ij = 1 or x_ji = 1 (not simultaneously)
constraint forall (i in 1..n , j in 1..n where i != j) (x[i,j] + x[j,i] = 1);
% z_i indicates max (forall i!=j z_i = 1 => x_i > x_j)
constraint forall (i in 1..n, j in 1..n where i != j) (M*(1 - z[i]) + e[i] >= e[j]);
% max exists
constraint sum(i in 1..n) (z[i]) = 1;
% e[i] exists (!=0), only if z[i] indicates max
constraint forall(i in 1..n) (e[i] <= s[i] + p[i] - 1 + M*(1 - z[i]) /\ e[i] >= s[i] + p[i] - 1 - M*(1 - z[i]) /\ e[i] <= M*z[i] /\ e[i] >= - M*z[i]);
% max is correct (ending time is really last)
constraint forall(i in 1..n) (sum(j in 1..n)(e[j]) >= s[i] + p[i] - 1);