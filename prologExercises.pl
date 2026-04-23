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

% проверка дали даден лист е сротиран
sorted([]).
sorted([_]).
sorted([A,B|T]) :- A #=< B, sorted([B|T]).

% намира елементите на четна позиция в списък
evenPositioned([],[]).
evenPositioned([],[_]). 
evenPositioned([X|T], [Y,X|Z]):- evenPositioned(T, Z).  

%намира дали А е част от списъка
element(A, [A|_]).
element(A, [_|T]):- element(A, T).

%конкатенация на списъци
concat([], Y, Y).
concat([H|X], Y, [H|Z]):- concat(X, Y, Z).

%префикс
prefix(X,Y):-concat(X,_,Y).

%първи елемент
first(A, [A|X]).

%ротация
rotation(X, Y):- concat(A,B,X), concat(B,A,Y).

%%%%%%%Пермутация%%%%%%%

%добавяне на елемент в списък
append(A, X, Z):- concat(B, C, X), concat(B, [A|C], Z).

%пермутация
permutation([], []).
permutation([A|X], Y):- permutation(X, Z), append(A, Z, Y).