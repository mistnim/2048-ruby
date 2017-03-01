% -*-Fundamental-*-
% static const float SCORE_MONOTONICITY_POWER = 4.0f;
% static const float SCORE_MONOTONICITY_WEIGHT = 47.0f;

lost_penalty(-200000).
sum_power(2,1).
sum_power(4,11).
sum_power(8,46).
sum_power(16,128).
sum_power(32,279).
sum_power(64,529).
sum_power(128,907).
sum_power(256,1448).
sum_power(512,2187).
sum_power(1024,3162).
sum_power(2048,4414).
sum_power(4096,5985).
sum_power(8192,7921).
sum_power(16384,10267).
sum_power(32768,13071).
sum_power(65536,16384).
sum_weight(11).

monotonicity_weight(47).

merge_weight(-700).
empty_weight(-270).

row0(32, 32, 2, 2).
row1(32,  0, 2, 0).
row2(32,  2, 2, 0).
row3(32,  0, 0, 0).

pos(0, 0, X) :- row0(X, _, _, _).
pos(0, 1, X) :- row0(_, X, _, _).
pos(0, 2, X) :- row0(_, _, X, _).
pos(0, 3, X) :- row0(_, _, _, X).
pos(1, 0, X) :- row1(X, _, _, _).
pos(1, 1, X) :- row1(_, X, _, _).
pos(1, 2, X) :- row1(_, _, X, _).
pos(1, 3, X) :- row1(_, _, _, X).
pos(2, 0, X) :- row2(X, _, _, _).
pos(2, 1, X) :- row2(_, X, _, _).
pos(2, 2, X) :- row2(_, _, X, _).
pos(2, 3, X) :- row2(_, _, _, X).
pos(3, 0, X) :- row3(X, _, _, _).
pos(3, 1, X) :- row3(_, X, _, _).
pos(3, 2, X) :- row3(_, _, X, _).
pos(3, 3, X) :- row3(_, _, _, X).

%% row(0, 32, 16, 8, 2).
%% row(1, 16,  8, 0, 0).
%% row(2,  2,  2, 0, 0).
%% row(3,  0,  0, 0, 0).

row(R, X, Y, Z, J) :- pos(R, 0, X), pos(R, 1, Y), pos(R, 2, Z), pos(R, 3, J).
row(Q, X, Y, Z, J) :- pos(0, R, X), pos(1, R, Y), pos(2, R, Z), pos(3, R, J), Q = R + 4.

%% merges
merge(X, l) :- row(X, J, J, _, _), J != 0.
merge(X, c) :- row(X, _, J, J, _), J != 0.
merge(X, r) :- row(X, _, _, J, J), J != 0.

:~ merge(X, l), merge_weight(W). [W, X, l]
:~ merge(X, c), not merge(X, l), merge_weight(W). [W, X, c]
:~ merge(X, r), merge(X, l), merge_weight(W). [W, X, r1]
:~ merge(X, r), not merge(X, l), not merge(X, c), merge_weight(W). [W, X, r2]

%% empty

:~ pos(X, Y, Z), Z = 0, empty_weight(W). [W, X, Y]

%% sum

:~ pos(X, Y, Z), Z != 0, sum_power(Z, P), W = P * WP,  sum_weight(WP). [W, X, Y]

%% lost penalty

:~ lost_penalty(X). [X, X]

%% monotonicity

#show merge/2.
%% #show row/5.
