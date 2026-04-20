:- use_module(library(clpfd)).

% производна на х

dx(0, 0).
dx(1, 0).

dx(x, 1).
dx(y, 0).
dx(z, 0).
dx(t, 0).

dx(F+G, FD+GD) :- dx(F, FD), dx(G, GD).
dx(F-G, FD-GD) :- dx(F, FD), dx(G, GD).
dx(F*G, FD*G+GD*F) :- dx(F, FD), dx(G, GD).
dx(F/G, (FD*G-GD*F)/(G*G)) :- dx(F, FD), dx(G, GD).

% даден е списък с числа, да се извади подсписък с всички
% прости числа от оригиналния списък

% сортиране на лист

sorted([]).
sorted([_]).
sorted([A,B|T]) :- A #=< B, sorted([B|T]).

evenPositioned([],[]).
evenPositioned([],[_]). 
evenPositioned([X|T], [Y,X|Z]):- evenPositioned(T, Z).  