library(data.table)
library(magrittr)


dt <- fread('../data/dt_02.txt') %>%
  .[, group := ifelse(V1 %in% c('up', 'down'), 1, 2)] %>%
  .[V1 == 'up', V2 := -V2] 
##------------------------------------------------------------------
## PART 1
##------------------------------------------------------------------
part1 <- copy(dt) %>% .[, .(sdir = sum(V2)), by = .(group)]
ans <- prod(part1[['sdir']])
print(paste0('Answer: ', ans))  
##------------------------------------------------------------------
## PART 2
##------------------------------------------------------------------
horz <- depth <- aim  <- 0
for (i in 1:length(dt$V1)) {
  if (dt$V1[i] == 'forward'){
    horz = horz + dt$V2[i]
    depth = depth + dt$V2[i] * aim
  } else {
    aim = aim +  dt$V2[i]
  }
}
ans = depth * horz
print(paste0('Answer: ', ans))

##------------------------------------------------------------------
## PART 2 Without LOOP
##------------------------------------------------------------------
dt <- dt %>%
  .[, horizon := ifelse(V1 == 'forward', V2, 0)] %>%
  .[, aim := cumsum(ifelse(V1 != 'forward', V2, 0)) * horizon]
ans = sum(dt$horizon) * sum(dt$aim)
print(paste0('Answer: ', ans))