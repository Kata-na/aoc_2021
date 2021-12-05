import numpy as np
import re

def line_path (coor1, coor2, diagonal=False):
    n = max([np.max(coor1), np.max(coor2)]) + 1
    movement_matrix = np.zeros((n, n))

    for c1, c2 in zip(coor1, coor2):
        updt = False
        st1 = -1 if c1[0] > c2[0] else 1
        st2 = -1 if c1[1] > c2[1] else 1

        if c1[1] == c2[1]:
            r = np.arange(c1[0], c2[0] + st1, st1)
            c = [c1[1]] * (abs(c1[0] - c2[0]) + 1)
            updt = True
        elif  c1[0] == c2[0]:
            r = [c1[0]] * (abs(c1[1] - c2[1]) +1)
            c = np.arange(c1[1], c2[1] + st2, st2)
            updt = True
        else:
            r = np.arange(c1[0], c2[0] + st1, st1)
            c = np.arange(c1[1], c2[1] + st2, st2)
            if diagonal: updt = True

        if updt == True:
            movement_matrix[r, c] +=1
    return movement_matrix

### EXECUTE code
if __name__ == '__main__':

    path = './data/dt_05.txt'
    ### PREP DATA
    d = open(path).read().split('\n')
    coor1, coor2 = [], []
    for i in d:
        coor1.append(re.sub('(\\d+?,\\d+?) -> \\d+?,\\d+?$', '\\1', i).split(','))
        coor2.append(re.sub('\\d+?,\\d+? -> (\\d+?,\\d+?)$', '\\1', i).split(','))
    coor1 = np.array(coor1[:(len(coor1)-1)], dtype=int)
    coor2 = np.array(coor2[:(len(coor1))], dtype=int)

    ### CALCULATE LINES
    ans1 = np.sum(line_path(coor1, coor2) > 1)
    ans2 = np.sum(line_path(coor1, coor2, True) > 1)

    print(f"Answer 1: {ans1}")
    print(f"Answer 2: {ans2}")