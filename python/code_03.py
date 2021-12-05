from datatable import fread
import numpy as np

path = './data/dt_03.txt'

## PREP DATA
d = open(path).read().split('\n')
ncol= len(d[0])
nrow = len(d)
d = np.array(list(''.join(d)), dtype=int, ).reshape((nrow, ncol))

## PART 1
sh = np.sum(d, axis=0)/nrow

gamma   = np.array((sh > 0.5), dtype=int)
epsilon = np.array((sh < 0.5), dtype=int)
gamma   = int(''.join(gamma.astype(str)), 2)
epsilon = int(''.join(epsilon.astype(str)), 2)

ans1 = gamma * epsilon
print(f"Answer 1: {ans1}")

## PART 2

def rating_generator(dd, n, n_max, type):
    nrow = dd.shape[0]
    if type.lower() == 'oxygen':
        mask = (np.sum(dd, axis=0)/nrow > 0.5)[n-1]
    elif type.lower() == 'co2 scrubber':
        mask = (np.sum(dd, axis=0)/nrow < 0.5)[n-1]
    else:
        raise ValueError('Incorrect type provided')
    dd = dd[(dd == int(mask)).transpose()[n-1]]

    if dd.shape[0] == 1:
        return int(''.join(dd[0].astype(str)), 2)
    else:
        if n == n_max:
            n = 1
        else: n += 1
        return rating_generator(dd, n, n_max, type)

oxygen       = rating_generator(d, 1, ncol, type = 'oxygen')
co2_scrubber = rating_generator(d, 1, ncol, type = 'co2 scrubber')
ans2         = oxygen * co2_scrubber
print(f"Answer 2: {ans2}")
