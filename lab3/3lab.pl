printer([]).
printer([A | T]) :-
    printer(T), 
    write(A), nl.

movement([-, B, C, D, E, F],[B, -, C, D, E, F]).
movement([-, B, C, D, E, F],[D, B, C, -, E, F]).
movement([A, -, C, D, E, F],[A, C, -, D, E, F]).
movement([A, -, C, D, E, F],[A, E, C, D, -, F]).
movement([A, B, -, D, E, F],[A, B, F, D, E, -]).
movement([A, B, C, -, E, F],[A, B, C, E, -, F]).
movement([A, B, C, D, -, F],[A, B, C, D, F, -]).
move(X,Y) :-
    movement(X,Y);
    movement(Y,X).

% Продление пути без зацикливания
prolong([Temp|Tail], [New, Temp|Tail]) :-
    move(Temp, New),
    not(member(New,[Temp|Tail])).

int(1).
int(X) :-
    int(N),
    X is N + 1.

% Поиск в глубину(изначальный список, список после обработки)
% Замеряет время и выводит шаги работы алгоритма
search_dpth(Start, Finish) :-
    write('~DEPTH SEARCH~'), nl,
    get_time(TIME1),
    dpth([Start], Finish, Way),
    printer(Way),
    get_time(TIME2),
    write('~DEPTH SEARCH END~'), nl, nl,
    T1 is TIME2 - TIME1,
    write('Time is '),
    write(T1), nl, nl.

% Основной предикат преобразования для поиска с итерационным заглублением
dpth([Finish|Tail], Finish, [Finish|Tail]).
dpth(TempWay, Finish, Way) :-
    prolong(TempWay, NewWay),
    dpth(NewWay, Finish, Way).

% Поиск в ширину(изначальный список, список после обработки)
% Замеряет время и выводит шаги работы алгоритма
search_brdth(Start, Finish) :-
    write('~BREADTH SEARCH~'), nl,
    get_time(TIME1),
    brdth([[Start]], Finish, Way),
    printer(Way),
    get_time(TIME2),
    write('~BREADTH SEARCH END~'), nl, nl,
    T1 is TIME2 - TIME1,
    write('Time is '),
    write(T1), nl, nl.

% Основной предикат преобразования для поиска с итерационным заглублением
brdth([[Finish | Tail] | _], Finish, [Finish | Tail]).
brdth([TempWay | OtherWays], Finish, Way) :-
    findall(Z, prolong(TempWay, Z), Ways),
    append(OtherWays, Ways, NewWays),
    brdth(NewWays, Finish, Way).

brdth([_ | Tail], Y, List) :- brdth(Tail, Y, List).

% Поиск с итерационным заглублением(изначальный список, список после обработки)
% Замеряет время и выводит шаги работы алгоритма
search_iter(Start, Finish) :-
    write('~ITER SEARCH~'), nl,
    get_time(TIME1),
    int(Level),
    iter([Start], Finish, Way, Level),
    printer(Way),
    get_time(TIME2),
    write('~ITER SEARCH END~'), nl, nl,
    T1 is TIME2 - TIME1,
    write('Time is '),
    write(T1), nl, nl.

% Основной предикат преобразования для поиска с итерационным заглублением
iter([Finish | Tail], Finish, [Finish | Tail], 0).
iter(TempWay, Finish, Way, N) :-
    N > 0,
    prolong(TempWay, NewWay),
    M is N - 1,
    iter(NewWay, Finish, Way, M).

search_iter(Start, Finish, Way) :-
    int(Level),
    search_iter(Start, Finish, Way, Level).
