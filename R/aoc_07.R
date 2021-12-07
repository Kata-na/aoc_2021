library(data.table)
inp <- readLines('../data/dt_07.txt')
inp <- unlist(strsplit(inp, ','))
inp <- as.numeric(inp)

t1 <- Sys.time()
##------------------------------------------------------------------
## PART 1 & 2
##------------------------------------------------------------------
dtt <- data.table(inp = inp, v =1) %>%
  .[, n := .N, by = .(inp, v)] %>%
  unique() %>%
  merge(data.table(position = 1:max(inp), v =1),
         all = TRUE, by = c('v'), allow.cartesian = TRUE) %>%
  .[, fuel_used := abs(inp - position)]  %>%
  .[, c('fuel_expenses1', 'fuel_expenses2') := 
      list(sum(fuel_used * n), sum((fuel_used * (fuel_used + 1)/2) * n)),
    by = .(position)]

print(glue::glue('Answer 1: {min(dtt$fuel_expenses1)}'))
print(glue::glue('Answer 2: {min(dtt$fuel_expenses2)}'))
print(Sys.time() - t1)

##------------------------------------------------------------------
## MATHEMATICAL solution
##------------------------------------------------------------------
t1 <- Sys.time()
print('Calculations using purely mathematical approach')
print(sum(abs(inp - median(inp))))
n <- abs(inp - floor(mean(inp)))
print(sum(n * (n + 1)/2))
print(Sys.time() - t1)
