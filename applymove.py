#!/usr/bin/env python3
import os
import sys
from itertools import zip_longest

def printerr(str, **kwargs):
     print(str, file=sys.stderr, **kwargs)

def print_board(board):
    for i in range(0,16):
        if (i % 4) == 0:
            print(file=sys.stderr)
            print(board[i], file=sys.stderr, end='\t')
        else:
            print(board[i], file=sys.stderr, end='\t')

def add_after(board):
    board = [board[n:n+4] for n in range(0, len(board), 4)]
    flag = False
    s = ''
    res,done = up(board)
    if done:
        res = [item for sublist in res for item in sublist]
        s += 'after(up,' + ', '.join(str(x) for x in res) + ').'
        flag = True
    res,done = down(board)
    if done:
        res = [item for sublist in res for item in sublist]
        s += 'after(down,' + ', '.join(str(x) for x in res) + ').'
        flag = True
    res,done = left(board)
    if done:
        res = [item for sublist in res for item in sublist]
        s += 'after(left,' + ', '.join(str(x) for x in res) + ').'
        flag = True
    res,done = right(board)
    if done:
        res = [item for sublist in res for item in sublist]
        s += 'after(right,' + ', '.join(str(x) for x in res) + ').'
        flag = True
    if not flag:
        return 'dead.'
    return s

def play(board):
    board = [item for sublist in board for item in sublist]
    input = add_after(board)
    if input == 'dead.':
        return 'left'

    if board.count(0) > 2:
        input += "heur."
    cmd = "echo \"" + input + "\" | cat - tables.pl logic.pl | idlv --stdin applymove.py | clasp"
    cmd += "| grep -B 2 'OPTIMUM FOUND' | head -n 1 | sed -r 's/.+move\\((\w+)\\).*/\\1/'"
    printerr(cmd)
    return os.popen(cmd).read().rstrip()

def eval_branch(board):
    input = 'input(' + ', '.join(str(x) for x in board) + ').'
    input += 'heur.'
    input += add_after(board)

    cmd = "echo \"" + input + "\" | cat - tables.pl logic.pl | idlv --stdin applymove.py | clasp | grep '^Optimization\s:' | cut -f 3 -d ' '"
    ret = int(os.popen(cmd).read())
    # printerr(cmd)
    # printerr(ret)
    return ret

def eval_branches(a00, a01, a02, a03, a10, a11, a12, a13, a20, a21, a22, a23, a30, a31, a32, a33):
    board=[a00,a01,a02,a03,a10,a11,a12,a13,a20,a21,a22,a23,a30,a31,a32,a33]
    cprob = 1
    num_open = board.count(0)
    cprob = cprob / num_open
    res = 0

    for idx, val in enumerate(board):
        tmp = board[:]
        if val == 0:
            if num_open <= 1:
                tmp[idx] = 2
                res += eval_branch(tmp) * 0.9
                tmp[idx] = 4
                res += eval_branch(tmp) * 0.1
            else:
                tmp[idx] = 2
                res += eval_branch(tmp)
    res = res / num_open

    # print_board(board)
    # print(depth, file=sys.stderr)
    #print(int(res), file=sys.stderr)
    return int(res)

def apply_move(direction, a00, a01, a02, a03, a10, a11, a12, a13, a20, a21, a22, a23, a30, a31, a32, a33):
    new=[[a00,a01,a02,a03],[a10,a11,a12,a13],[a20,a21,a22,a23],[a30,a31,a32,a33]]
    if direction == "up":
        res,done = up(new)
    if direction == "down":
        res,done = down(new)
    if direction == "left":
        res,done = left(new)
    if direction == "right":
        res,done = right(new)
    if not done:
        return ("no", 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ,1)
    return ("yes",
            res[0][0], res[0][1],res[0][2],res[0][3],
            res[1][0], res[1][1],res[1][2],res[1][3],
            res[2][0], res[2][1],res[2][2],res[2][3],
            res[3][0], res[3][1],res[3][2],res[3][3])

def reverse(mat):
    new=[]
    for i in range(len(mat)):
        new.append([])
        for j in range(len(mat[0])):
            new[i].append(mat[i][len(mat[0])-j-1])
    return new

def transpose(mat):
    new=[]
    for i in range(len(mat[0])):
        new.append([])
        for j in range(len(mat)):
            new[i].append(mat[j][i])
    return new

def cover_up(mat):
    new=[[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
    done=False
    for i in range(4):
        count=0
        for j in range(4):
            if mat[i][j]!=0:
                new[i][count]=mat[i][j]
                if j!=count:
                    done=True
                count+=1
    return (new,done)

def merge(mat):
    done=False
    for i in range(4):
         for j in range(3):
             if mat[i][j]==mat[i][j+1] and mat[i][j]!=0:
                 mat[i][j]*=2
                 mat[i][j+1]=0
                 done=True
    return (mat,done)


def up(game):
        game=transpose(game)
        game,done=cover_up(game)
        temp=merge(game)
        game=temp[0]
        done=done or temp[1]
        game=cover_up(game)[0]
        game=transpose(game)
        return (game,done)

def down(game):
        game=reverse(transpose(game))
        game,done=cover_up(game)
        temp=merge(game)
        game=temp[0]
        done=done or temp[1]
        game=cover_up(game)[0]
        game=transpose(reverse(game))
        return (game,done)

def left(game):
        game,done=cover_up(game)
        temp=merge(game)
        game=temp[0]
        done=done or temp[1]
        game=cover_up(game)[0]
        return (game,done)

def right(game):
        game=reverse(game)
        game,done=cover_up(game)
        temp=merge(game)
        game=temp[0]
        done=done or temp[1]
        game=cover_up(game)[0]
        game=reverse(game)
        return (game,done)
