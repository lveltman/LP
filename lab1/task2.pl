% Task 2: Relational Data
% Data: 4. four.pl.
% Вариант 3

% The line below imports the data
:- ['four.pl'].

% 1. Напечатать средний балл для каждого предмета

% Сумма оценок по предмету
% (список оценок, сумма оценок)
sum_grades([], 0).
sum_grades([grade(_, N) | T], Sum) :-
    sum_grades(T, M),
    Sum is N + M,

% Средний балл по предмету
% (название предмета, средняя оценка)
average_mark(Subject, Mark) :-
    subject(Subject, Grade),
    sum_grades(Grade, Sum),
    length(Grade, Size),
    Mark is Sum / Size.

% 2. Для каждой группы, найти количество не сдавших студентов

is_member(X, [X | _]).
is_member(X, [_ | T]) :-
    is_member(X, T).

% Список всех оценок по всем предметам
% (список предметов, список оценок)
all_marks([], _).
all_marks([H | T], Marks_list) :-
    subject(H , X),
    all_marks(T, New_list),
    append(X, New_list, Marks_list).

% Удаление повторяющихся оценок, 
% если в списке один и тот же студент 
% получил больше одной 2 по разным предметам,
% он должен считаться один раз
delete_all(_, [], []).
delete_all(X, [X | L], L1) :- delete_all(X, L, L1).
delete_all(X, [Y | L], [Y | L1]) :- 
    X \= Y,
    delete_all(X, L, L1).

deletion_same_marks([], []).
deletion_same_marks([H | T], [H | T1]) :-
    delete_all(H, T, T2),
    deletion_same_marks(T2, T1).

% Проверяем, сколько студентов, получивших 2, имеются в нужной группе
% (список всех оценок, список группы, количество несдавших студентов из группы)
checker([], _, 0).
checker([grade(X , Y) | T], Names, N) :- 
    Y < 3,
    is_member(X, Names),
    !,
    checker(T, Names, M),
    N is M + 1.
checker([_ | T], Names, N) :- checker(T, Names, N).

% Количество несдавших студентов в группе
% (номер группы, число несдавших)
count_fail_group(Group, Count):-
    group(Group, Names),
    findall(Sub, subject(Sub, _), Subject_list),
    all_marks(Subject_list, Marks_list),
    deletion_same_marks(Marks_list, New),
    checker(New, Names, Count).
    
% 3. Найти количество не сдавших студентов для каждого из предметов
%(список оценок, количество несдавших)
count_fail_stud([], 0).
count_fail_stud([grade(_, Mark) | T], N) :-
    Mark < 3,
    !,
    count_fail_stud(T, C),
    N is C + 1.
count_fail_stud([_ | T], N) :- count_fail_stud(T, N).

%(название предмета, число студентов)
fail_stud_number(Subject, Count) :-
    subject(Subject, Info),
    count_fail_stud(Info, Count).
