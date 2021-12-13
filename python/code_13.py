import numpy as np
import re
import matplotlib.pyplot as plt 

inp = open('./data/dt_13.txt').read().split('\n')
### Folding & points coordinates
fold_info, idx = [], []
for x in inp :
    if "fold" in x :
        fold_info.append(x)
    elif x != '':
        idx.append(x.split(','))
idx = np.array(idx, dtype=int)

### paper template ###
# nummber of row and cols (i.e. paper dim) should be odd
r = 1 if max(idx[:, 1]) % 2 == 0 else 2 
c = 1 if max(idx[:, 0]) % 2 == 0 else 2 
paper = np.zeros(shape = (max(idx[:, 1]) + r, max(idx[:, 0]) + c), dtype=bool)
paper[(idx[:, 1], idx[:, 0])] = True

fold_xy = [int(re.sub('fold along .=(\\d+)$', '\\1', x)) for x in fold_info]
fold_nm = [re.sub('fold along (.)=\\d+$', '\\1', x) for x in fold_info]

### Folding paper
for i, nm in zip(fold_xy, fold_nm):
    if nm == 'x':
        paper = paper[:, :i] | np.flip(paper[:, (i+1):], 1)
    else:
        paper = paper[:i, :] | np.flip(paper[(i+1):, :], 0)
    
    if i == fold_xy[0]:
        print(f'Answer 1: {np.sum(paper)}')
### Part 2: code on image
plt.imshow(paper)
plt.show()
