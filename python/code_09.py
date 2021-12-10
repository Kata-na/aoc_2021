import numpy as np
import re
dt = open('./data/dt_09.txt').read()

value = [int(char) for char in dt.rstrip()  if char != '\n']
nrow  = int(len(re.sub('\\d', '', dt)))
ncol  = int(len(value) / nrow)
arr   = np.resize(np.array(value), (nrow, ncol))

### EMPTY matrices of ones
left, right = np.ones((nrow, ncol)), np.ones((nrow, ncol), dtype=bool)
up, down    = np.ones((nrow, ncol)), np.ones((nrow, ncol))

### Checking each neigbour (to right, left , up and down)
right[:, 0:(ncol-1)] = arr[:, 0:(ncol-1)] < arr[:, 1:ncol]
left[:, 1:ncol]      = right[:, 0:(ncol-1)] == 0
down[0:(nrow-1), :]  = arr[0:(nrow-1), :] < arr[1:nrow, :]
up[1:nrow, :]        = down[0:(nrow-1), :] == 0

ans1 = np.sum(arr[right + left + up + down == 4] + 1)
print(f'Answer 1: {ans1}')