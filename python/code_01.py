from datatable import fread
import numpy as np

path = './data/dt_01.txt'

m = fread(path).to_list()[0]
ans = np.sum(np.diff(m) > 0)
print(f"Answer: {ans}")

window = 3
drop_tail = len(m)%3
mm = m + np.roll(m, shift=-1) + np.roll(m, shift=-2)
ans = np.sum(np.diff(mm[:-drop_tail])>0)
print(f"Answer: {ans}")