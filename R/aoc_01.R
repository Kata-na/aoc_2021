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
ans <- sum(diff(f) > 0, na.rm = TRUE)
print(paste0('Answer: ', ans))

##------------------------------------------------------------------
## EASIER and more smart way for PART 2
## Every triples sum differs from it neighbors by one component
##------------------------------------------------------------------
ans <- sum(dt > shift(dt, 3, type='lag'), na.rm = TRUE)
print(paste0('Answer: ', ans))
