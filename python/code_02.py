from datatable import fread
import numpy as np

path = './data/dt_02.txt'
m = np.array(fread(path).to_list())
mdir = np.array(m[0])
num = m[1].astype(int)
num[mdir == 'up'] = -num[mdir == 'up']


## PART 1
ans = (sum(num[mdir == 'down']) + sum(num[mdir == 'up'])) * (sum(num[mdir == 'forward']))
print(f"Answer 1: {ans}")

## PART 2 
horz, depth, aim = 0, 0, 0
for val, dir in zip(num, mdir):
    if dir == 'forward':
        horz += val
        depth += val * aim
    else :
        aim += val
ans = depth * horz
 
print(f'Answer 2: {ans}')

## PART 2  - WITHOUT LOOP (~11 times fatser)
horizon, aim = num.copy(), num.copy()
horizon[mdir != 'forward'] = 0
aim[mdir == 'forward'] = 0
ans2 = np.sum(horizon) * (horizon * np.cumsum(aim))
print(f'Answer 2: {ans}')
