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

%последен елемент
lastElement([A], A).
lastElement([_|X], A):- lastElement(X, A).

%ротация
rotation(X, Y):- concat(A,B,X), concat(B,A,Y).

%%%%%%%Пермутация%%%%%%%

%добавяне на елемент в списък
append(A, X, Z):- concat(B, C, X), concat(B, [A|C], Z).

%пермутация
permutation([], []).
permutation([A|X], Y):- permutation(X, Z), append(A, Z, Y).

%%%%%целочислена аритметика%%%%%

% X #= Y       X е равно на Y
% X #\= Y      X е различно от Y
% X #> Y       X е по-голямо от Y
% X #< Y       X е по-малко от Y
% X #>= Y      X е по-голямо или равно от Y
% X #=< Y      X е по-малко или равно от Y
% X #<= Y      грешка
%%%Целочислена аритметика%%%

lengthList([], N):- N #= 0.
lengthList([A|X], N):- N #>= 1, N #= N1 + 1, lengthList(X, N1).

sumElements([], N):- N #= 0.
sumElements([A|X], N):- N #= N1 + A, sumElements(X, N1). 

nthElement(X, A, N):- concat(Q,P,X), lengthList(Q, N), lastElement(Q, A).

factorial(N, S):- N #= 1, S #= 1.
factorial(N, S):- N #> 1, S #=N*S1, N1 #= N - 1, factorial(N1, S1).

%%%%% безкрайни генератори %%%%%%

%НАИЗУСТ дефиниция на генератор на естествените числа

nat(N) :- N #= 0; nat(N-1).

%%% допълнителни възможности на пролог %%%

% отрицание not(p(X))

primeNumber(P):- P #>= 2, not((P #= A*B, A in 2..P, B in 2..P, label([A,B]))). 

% универсален квантор с импликация
% forall(p(X), q(X)).

% списък от всички решения

% findall(A, P, X) е приблизително същото като X = {A: P}
%                    т.е. X става списък от всички A, за които P е вярно.

% сортиране
sortAlg(X, Y):- permutation(X,Y), forall(concat(_ ,[A,B|_], Y), A #=<B).

member(A, [A|_]).
member(A, [_|X]):- member(A, X).

% p24(+XX) - за всеки два елемента X и Y на XX в XX съществува елемент Z,
%            чиито елементи са точно общите елементи на X и Y.

p24(XX):- forall((member(A, XX), member(B, XX)),
                    (member(C, XX), (
                        forall(member(K, C), (member(K, A), member(K, B))),
                        forall((member(K, A), member(K, B)), member(K,C))
                    ))).

                    
% p22(+N, XX) - XX e списък от списъци от естествени числа, такива че за
%               всеки два елемента X и Y на XX в XX има елемент Z, чиито
%               елементи са точно общите елементи на X и Y.  Дължината на
%               XX е по-малка от N, дължините на елементите на XX са
%               по-малки от N, елементите на елементите на XX са по-малки
%               от N.

isLengthSmaller(N, X):- lengthList(X, N1), N #>= N1.

smallerElements(N, []). 
smallerElements(N, [A|X]):- A #=< N, smallerElements(N, X).

membersLength(N, []).
membersLength(N, [A|X]):- isLengthSmaller(N, A), smallerElements(N, A), membersLength(N, X).

p22(N, XX):- 
            isLengthSmaller(N, XX),
            membersLength(N, XX),
            p24(XX).

% Задача.  Да се дефинира предикат pppp(X), който по даден списък X от
% списъци от числа проверява дали всеки предпоследен елемент на елемент на
% четна позиция е просто число.

% pppp(XX) - всеки предпоследен елемент на елемент на XX на четна позиция
%            е просто число
%
% Условие: XX е известен списък

evenElements([], []).
evenElements([_], []).
evenElements([A,B|X], [B|Y]):- evenElements(X, Y).

predPosledenElement(A, [A,B]).
predPosledenElement(A, [_|X]):- predPosledenElement(A, X).

pppp(XX):- evenElements(XX, YY),
           forall((member(Y, YY), predPosledenElement(A, Y)) , primeNumber(A)).

% p20160903a(L, N) - по списък от естествени числа L и естествено число N
% проверява дали има N елемента a[1]..a[N] на L, чийто НОД се различава от
% НОД на кои да е N-1 елемента b[1]..b[N-1] на L.

%p2016(L, N):- 

delitel(N, K):- N #= K * _.

odList(N, X):- forall(member(A, X), delitel(A, N)).

nodList(N, X):- findall(A, odList(A, X), Y),
                maxList(N, Y).

maxList(A, []).
maxList(A, [B|X]):- A #>= B, maxList(A, X).

% извадка(X, Y) - X е извадка от Y, т.е. може да се получи „задраскаме“
%                 някои елементи на Y
%
% Условие: известно е ограничение отгоре за дължината на Y

izvadka([], _). 
izvadka([A|X], [A|Y]):- izvadka(X, Y).
izvadka(X, [_|Y]):- izvadka(X,Y).

% А се поглъща от B (списъци от числа), ако сборът на всеки два елемента на
% A се съдържа в B.

podmnojestvo(X, Y):-forall(member(A, X), member(A, Y)).

poglyshta(X, Y):- forall(podmnojestvo(), (C #= A + B, member(C, Y)))