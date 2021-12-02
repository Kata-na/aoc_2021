library(data.table)
library(magrittr)

##------------------------------------------------------------------
## PART 1
##------------------------------------------------------------------
dt <- fread('../data/dt_01.txt')$V1
print(paste0('Answer: ', sum(diff(dt) > 0)))


##------------------------------------------------------------------
## PART 2
##------------------------------------------------------------------
f <- dt +  shift(dt, type='lead') + shift(dt, 2, type='lead')
ans <- sum(diff(f[1:(length(f) - remove_tail)]) > 0)
print(paste0('Answer: ', ans))

      