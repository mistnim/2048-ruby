% -*-Prolog-*-

sum_weight(11).
monotonicity_weight(47).
merge_weight(700).
empty_weight(270).

move(up) | move(down) | move(left) | move(right).

%% move up if top-right corner free
%% slideUppable :- pos(1, 3, X), X != 0.
%% slideUppable :- pos(2, 3, X), X != 0.
%% slideUppable :- pos(3, 3, X), X != 0.
%% :~ pos(0, 3, 0), slideUppable, not move(up). [100000]

%% :~ move(down). [1@2]
%% :~ move(right). [1@2]
%% :~ move(down). [9000]
% :~ move(left). [200]

capply_move(P, A00, A01, A02, A03, A10, A11, A12, A13, A20, A21, A22, A23, A30, A31, A32, A33) :- move(W),
             input(I00, I01, I02, I03, I10, I11, I12, I13, I20, I21, I22, I23, I30, I31, I32, I33),
             &apply_move(W, I00, I01, I02, I03, I10, I11, I12, I13, I20, I21, I22, I23, I30, I31, I32, I33;
                         P, A00, A01, A02, A03, A10, A11, A12, A13, A20, A21, A22, A23, A30, A31, A32, A33).

possible(X) :- capply_move(X, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _).
:- not possible(yes).

pos(0, 0, A00) :- capply_move(yes, A00, A01, A02, A03, A10, A11, A12, A13, A20, A21, A22, A23, A30, A31, A32, A33).
pos(0, 1, A01) :- capply_move(yes, A00, A01, A02, A03, A10, A11, A12, A13, A20, A21, A22, A23, A30, A31, A32, A33).
pos(0, 2, A02) :- capply_move(yes, A00, A01, A02, A03, A10, A11, A12, A13, A20, A21, A22, A23, A30, A31, A32, A33).
pos(0, 3, A03) :- capply_move(yes, A00, A01, A02, A03, A10, A11, A12, A13, A20, A21, A22, A23, A30, A31, A32, A33).
pos(1, 0, A10) :- capply_move(yes, A00, A01, A02, A03, A10, A11, A12, A13, A20, A21, A22, A23, A30, A31, A32, A33).
pos(1, 1, A11) :- capply_move(yes, A00, A01, A02, A03, A10, A11, A12, A13, A20, A21, A22, A23, A30, A31, A32, A33).
pos(1, 2, A12) :- capply_move(yes, A00, A01, A02, A03, A10, A11, A12, A13, A20, A21, A22, A23, A30, A31, A32, A33).
pos(1, 3, A13) :- capply_move(yes, A00, A01, A02, A03, A10, A11, A12, A13, A20, A21, A22, A23, A30, A31, A32, A33).
pos(2, 0, A20) :- capply_move(yes, A00, A01, A02, A03, A10, A11, A12, A13, A20, A21, A22, A23, A30, A31, A32, A33).
pos(2, 1, A21) :- capply_move(yes, A00, A01, A02, A03, A10, A11, A12, A13, A20, A21, A22, A23, A30, A31, A32, A33).
pos(2, 2, A22) :- capply_move(yes, A00, A01, A02, A03, A10, A11, A12, A13, A20, A21, A22, A23, A30, A31, A32, A33).
pos(2, 3, A23) :- capply_move(yes, A00, A01, A02, A03, A10, A11, A12, A13, A20, A21, A22, A23, A30, A31, A32, A33).
pos(3, 0, A30) :- capply_move(yes, A00, A01, A02, A03, A10, A11, A12, A13, A20, A21, A22, A23, A30, A31, A32, A33).
pos(3, 1, A31) :- capply_move(yes, A00, A01, A02, A03, A10, A11, A12, A13, A20, A21, A22, A23, A30, A31, A32, A33).
pos(3, 2, A32) :- capply_move(yes, A00, A01, A02, A03, A10, A11, A12, A13, A20, A21, A22, A23, A30, A31, A32, A33).
pos(3, 3, A33) :- capply_move(yes, A00, A01, A02, A03, A10, A11, A12, A13, A20, A21, A22, A23, A30, A31, A32, A33).


%% pos(0, 0, X) :- row0(X, _, _, _).
%% pos(0, 1, X) :- row0(_, X, _, _).
%% pos(0, 2, X) :- row0(_, _, X, _).
%% pos(0, 3, X) :- row0(_, _, _, X).
%% pos(1, 0, X) :- row1(X, _, _, _).
%% pos(1, 1, X) :- row1(_, X, _, _).
%% pos(1, 2, X) :- row1(_, _, X, _).
%% pos(1, 3, X) :- row1(_, _, _, X).
%% pos(2, 0, X) :- row2(X, _, _, _).
%% pos(2, 1, X) :- row2(_, X, _, _).
%% pos(2, 2, X) :- row2(_, _, X, _).
%% pos(2, 3, X) :- row2(_, _, _, X).
%% pos(3, 0, X) :- row3(X, _, _, _).
%% pos(3, 1, X) :- row3(_, X, _, _).
%% pos(3, 2, X) :- row3(_, _, X, _).
%% pos(3, 3, X) :- row3(_, _, _, X).

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

%% if negative weights were possible
%% :~ merge(X, l), merge_weight(W). [W, X, l]
%% :~ merge(X, c), not merge(X, l), merge_weight(W). [W, X, c]
%% :~ merge(X, r), merge(X, l), merge_weight(W). [W, X, r1]
%% :~ merge(X, r), not merge(X, l), not merge(X, c), merge_weight(W). [W, X, r2]

amerge(X, l) :- merge(X, l), merge_weight(W).
amerge(X, c) :- merge(X, c), not merge(X, l), merge_weight(W).
amerge(X, r) :- merge(X, r), merge(X, l), merge_weight(W).
amerge(X, r) :- merge(X, r), not merge(X, l), not merge(X, c), merge_weight(W).

side(l). side(c). side(r).
pmerge(X, S) :- row(X, _, _, _, _), side(S).

:~ pmerge(X, S), not amerge(X, S), merge_weight(W). [W, W, X, S]

%% empty

:~ pos(X, Y, Z), Z != 0, empty_weight(W). [W, X, Y]

%% sum

:~ pos(X, Y, Z), Z != 0, sum_power(Z, P), W = P * WP,  sum_weight(WP). [W, X, Y]

%% lost penalty

% :~ lost_penalty(X). [X, X]

%% monotonicity

tuple(X, l, A, B) :- row(X, J, K, _, _), mono_power(J, A), mono_power(K, B).
tuple(X, c, A, B) :- row(X, _, J, K, _), mono_power(J, A), mono_power(K, B).
tuple(X, r, A, B) :- row(X, _, _, J, K), mono_power(J, A), mono_power(K, B).

:~ tuple(X, S, A, B), A < B, D = B - A, WR = W * D, monotonicity_weight(W). [WR, WR, X, S]

%% rows(0..7).
%% mono_left(X, Val) :- rows(X), Val = #sum{R, S: tuple(X, S, J, K), J > K, R = J - K}.
%% mono_right(X, Val) :- rows(X), Val = #sum{R, S: tuple(X, S, J, K), J < K, R = K - J}.
%% :~ mono_left(X, L), mono_right(X, R), L < R, monotonicity_weight(W), WR = L * W. [WR, X]
%% :~ mono_left(X, L), mono_right(X, R), L > R, monotonicity_weight(W), WR = R * W. [WR, X]

%% mono_left(Val) :- Val = #sum{R, X: tuple(X, S, J, K), J > K, R = J - K}.
%% mono_right(Val) :- Val = #sum{R, X, S: tuple(X, S, J, K), J < K, R = K - J}.
%% :~ mono_left(L), mono_right(R), L < R, monotonicity_weight(W), WR = L * W. [WR]
%% :~ mono_left(L), mono_right(R), L > R, monotonicity_weight(W), WR = R * W. [WR]

