import numpy as np
from time import perf_counter as pfc

inp = open('./data/dt_07.txt').read().split('\n')
inp = np.array(inp[0].split(','), dtype=int)

### MATHEMATICAL SOLUTION
start = pfc()
#part 1
ans1 = np.sum(np.abs(inp - np.median(inp)))
print(f"Answer 1: {ans1}")
#part 2
val  = np.abs(inp - np.floor(np.mean(inp)))
ans2 = np.sum(val * (val + 1)/2)
print(f"Answer 2: {ans2}")
print(pfc()-start)


## Array of unique crabs' positions
inp_t = np.array(list(set(inp)), dtype = int)
## Count haw many crabs have same position
nn = np.array([np.sum(inp == x) for x in inp_t])

##list of potential positions crabs can move to
potential_pos = np.arange(1, max(inp_t)) 
potential_pos = np.repeat(potential_pos, len(inp_t))

inp_t = np.hstack((inp_t, ) * max(potential_pos))
nn =  np.hstack((nn, ) * max(potential_pos))

## PART 1
start = pfc()
d = np.abs(inp_t - potential_pos) * nn
options = np.array([sum(d[potential_pos==x]) for x in range(1, max(potential_pos))], dtype = np.int64)
print(f"Answer 1: {np.min(options)}")
print(pfc()-start)

## PART 2
start = pfc()
d = np.abs(inp_t - potential_pos)
dd = (d * (d + 1)/2) * nn
options = np.array([sum(dd[potential_pos==x]) for x in range(1, max(potential_pos))], dtype = np.int64)
print(f"Answer 2: {np.min(options)}")
print(pfc()-start)