from datatable import fread
import numpy as np

path = './data/dt_01.txt'
m = fread(path).to_list()[0]
m = np.array(m)

## PART 1
ans = np.sum(np.diff(m) > 0)
print(f"Answer: {ans}")

## PART 2
ans = np.sum(m[3:] > m[:len(m)-3])
print(f"Answer: {ans}")