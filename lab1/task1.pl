% Первая часть задания - предикаты работы со списками

% Принадлежность элемента списку
% (элемент, список)
is_member(X, [X | _]).
is_member(X, [_ | T]) :- is_member(X, T).

% Длина списка
% (список, длина)
my_length([], 0).
my_length([_ | T], N) :-
	my_length(T, M), 
	N is M + 1.

% Конкатенация списка
% (список 1, список 2, список 1+2)
my_append([], L, L).
my_append([X | L1], L2, [X | Res]) :- my_append(L1, L2, Res).

% Удаление элемента из списка
% (элемент, список, список без элемента)
%my_remove(_, [], []).
my_remove(X, [X | L], L).
my_remove(X, [Y | L], [Y | Ls]) :- my_remove(X, L, Ls).

% Перестановка списка
% (список, перестановка)
my_permute([], []).
my_permute(L, [X, T]) :-
	my_remove(X, L, L1),
	my_permute(L1, T).

% Подсписки списка
% (подсписок, список)
my_sublist(Sub, L) :-
	my_append(_, L1, L),
	my_append(Sub, _, L1).

% 12. Удаление всех элементов списка по значению
% (со стандартными предикатами)

% (элемент, список, список после удаления)
remove_std(X, L1, L2) :- append(L2, [X | _], L1).

% 12. Удаление всех элементов списка по значению
% (без стандартных предикатов)

% (элемент, список, список после удаления)
remove_all(X, [X | _], []) :- !.
remove_all(X, [H | T],[H | T1]) :- remove_all(X, T, T1).

%17. Слияние двух упорядоченных списков
%(без использования стандартных предикатов)

% (список, отсортированный список)
my_qsort([], []).
my_qsort([H | T], L) :-
	my_split(H, T, Small, Big),
	my_qsort(Small, SmallSort),
	my_qsort(Big, BigSort),
	my_append(SmallSort, [H | BigSort], L).

% Разделяем массив на 2 массива: Small(числа < H) и Big(числа >= H)
my_split(_, [], [], []).
my_split(H, [H2 | R], [H2 | Small], Big) :-
	H2 < H,
	my_split(H, R, Small, Big).
my_split(H, [H2 | R], Small, [H2 | Big]) :-
	H2 >= H,
	my_split(H, R, Small, Big).

% (1 список, 2 список, список-результат)
sort_lists_to_list(_, [], []) :- !, fail.
sort_lists_to_list([], _, []) :- !, fail.
sort_lists_to_list(L1, L2, L3) :-
	my_qsort(L1, T1),
	my_qsort(L2, T2),
	my_append(T1, T2, L3).

%17. Слияние двух упорядоченных списков
%(с использованием стандартных предикатов)

% (1 список, 2 список, список-результат)
std_sort_lists_to_one(_, [], []) :- !, fail.
std_sort_lists_to_one([], _, []) :- !, fail.
std_sort_lists_to_one(L1, L2, L3) :-
	msort(L1, T1),
	msort(L2, T2),
	append(T1, T2, L3).

% Пример совместного использования предикатов
/*слияние упорядоченных списков, проверка принадлежности элемента-удалителя списку-результату, удаление всех элементов списка, начиная с элемента-удалителя*/
% (элемент-удалитель, 1 список, 2 список, список-результ)
checker(X, L1, L2, Res) :-
	sort_lists_to_list(L1, L2, L3),
	is_member(X, L3),
	remove_all(X, L3, Res).
