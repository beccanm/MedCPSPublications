param nvertices integer >= 1;
param nedges    integer >= 1;
param N         integer >= 1;
set ZERO; 

set ELEMENTS   ;
set RULES      ;
set SUBGRAPHS  ;
set TIME       ;
set TIME0      ;

check card(TIME) = N;

# The initial values of vertex parameters
param Px0 {ELEMENTS} integer >= 0;
# Terms for the linear predicate Phi
param C {RULES};
param B {RULES, ELEMENTS};
# Preserved vertices
set VPHI within ELEMENTS;
# Element list of induced subgraphs (element = vertex or edge) 
# (s,x) means x (given by its identity in G) is in subgraph Ks
set KX within {SUBGRAPHS, ELEMENTS};
# (R,Ks) in KRULES means that Ks is a stage for R
set KRULES within {RULES, SUBGRAPHS};
# Stages destroyed by application of R_i
set DESTROYED {KRULES} within {SUBGRAPHS};
# Abstractness for every rule
param deltaRS {RULES} integer >= 0;

# optimization var: 
var a {KRULES, TIME0} binary := 0;

# Parameter update equations
# Px(0) is the initial value, before any rule has been applied.
# Px(1) is the value after 1 rule is applied. That application is captured in a[i,s,1].
# Similarly, Px(j) is the value after j rule applications, captured in a[i,s,1..j]
set mySUBGRAPHS {x in ELEMENTS} = {s in SUBGRAPHS : (s,x) in KX};
var Px {(x,j) in ELEMENTS cross TIME0} integer;

# Abstracness per stage
set SUBGRAPHtoX {s in SUBGRAPHS} = setof {(s,x) in KX} x;
var deltaRP {(i,s) in KRULES, j in TIME} = sum {x in SUBGRAPHtoX[s]} (Px[x,j] - Px[x,j-1]);
var abst {j in TIME} = sum {(i,s) in KRULES} 
						a[i,s,j]*(deltaRS[i] + deltaRP[i,s,j]);

maximize abstractness: 
	sum {j in TIME} abst[j] ;

subject to InitialP0 {x in ELEMENTS}:
	Px[x,0] = Px0[x];

# If at some j no rule is applied, then this means applications are over, and no rules can be further applied
#       Arithmetic version
subject to Regular_application {j in 1..N-1}:
	(sum {(i,s) in KRULES} a[i,s,j]) - (sum{(ip,sp) in KRULES} a[ip,sp,j+1]) >= 0;
#  		Logic version
#subject to Regular_application {j in 1..N-1}:
#	sum {(i,s) in KRULES} a[i,s,j] = 0 ==> sum{(i,s) in KRULES} a[i,s,j+1] = 0;

# One rule at the most is applied per step
subject to One_rule_at_a_time {j in TIME}:
	sum {(i,s) in KRULES} a[i,s,j] <= 1;

#       Arithmetic version
subject to Disabling_by_structure {(i,s) in KRULES, j in 1..N-1}:
	a[i,s,j]*(sum {jp in {j+1..N}, (ip,sp) in KRULES: sp in DESTROYED[i,s] }
	               a[ip,sp,jp]) = 0;
#       Logic version
#subject to Disabling_by_structure {(i,s) in KRULES, j in 1..N-1}:
#	a[i,s,j] = 1 ==> sum {jp in {j+1..N}, (ip,sp) in KRULES: sp in DESTROYED[i,s] }
#	               a[ip,sp,jp] <= 0;

# subject to Precedence:


#subject to Applicability_conditions {(i,s) in KRULES, j in TIME}:
#	a[i,s,j]*(sum {x in {setof {(s,v) in KX} v} } B[i,x]*Px[x, j-1] - C[i]) <= 0;

# Model appropriateness
set KX2{s in SUBGRAPHS} = {x in ELEMENTS : (s,x) in KX};
set PROHIBITED_APPS = {(i,s) in KRULES : 
				exists {sp in DESTROYED[i,s]} (exists {v in KX2[sp]} v in VPHI)
				};
subject to Model_appropriateness {j in TIME, (i,s) in PROHIBITED_APPS}:
	a[i,s,j]=0;

# The update equations have to be input manually since the update functions change and we can not model that in AMPL (or generated from MATLAB)
# We will have as many such constraints as there are different update functions.
# Here I'm giving everything the same form, max.
# But say if Ri is applied to Ks at j-1, then x gets updated via max, and if Rj is applied
# to Ks at j-1 then x is updated by sum, then those are two different constraints.	
#
subject to Parameter_update {(x,j) in ELEMENTS cross TIME}:
	Px[x,j] = Px[x,j-1] ;#+ sum {(i,s) in KRULES: s in mySUBGRAPHS[x]}  a[i,s,j]*(-Px[x,j-1] + max( 430, Px[x, j-1]));

#subject to Parameter_update1 {(x,j) in {ELEMENTS cross TIME} diff {{65} cross TIME}}:
#	Px[x,j] = Px[x,j-1] + sum {(i,s) in KRULES: s in mySUBGRAPHS[x]}  a[i,s,j]*(-Px[x,j-1] + max( 200, Px[x, j-1]));
		
#subject to Parameter_update2 {j in TIME}:
#	Px[65,j] = Px[65,j-1] + sum {(i,s) in KRULES: s in mySUBGRAPHS[65]}  a['R5','S4',j]*(-Px[65,j-1] + Px[65,j-1] + 200);

	


