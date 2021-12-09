rm(list = ls())
library(magrittr)
library(data.table)
inp <- readLines('../data/dt_08.txt')
##------------------------------------------------------------------
## PART 1
##------------------------------------------------------------------
output_value <- gsub('^.*?\\| (.*?)$', '\\1', inp)
output_value <- unlist(strsplit(output_value, ' '))
ans <- sum(nchar(output_value) %in% c(2, 4, 3, 7))
print(ans)

##------------------------------------------------------------------
## PART 2
##------------------------------------------------------------------

### AUXILIARY FUNC
char_diff <- function(a, b) {
  return(setdiff(strsplit(a, '')[[1]], strsplit(b, '')[[1]]))
}
char_diff_len <- function(a, b) {
  return(length(setdiff(strsplit(a, '')[[1]], strsplit(b, '')[[1]])))
}
char_sort <- function(a) {
  return( paste(sort(strsplit(a, '')[[1]]), collapse = ''))
}

output_value <- gsub('^.*?\\| (.*?)$', '\\1', inp) 
input_value <- gsub('(^.*?) \\| .*?$', '\\1', inp)

d <- unlist(strsplit(input_value, ' '))
inputs <- data.table(input = d, 
                     len = nchar(d),
                     gr = sort(rep(1:length(input_value), 10))) %>%
  .[len == 2, final_val := 1] %>%
  .[len == 3, final_val := 7] %>%
  .[len == 4, final_val := 4] %>%
  .[len == 7, final_val := 8]

## ASSIGING  NUMBER 3 and 6 using their difference from 7
## 6 is the only 6 connection/wires number which misses one connection present
## in number 7, and 3 is  is the only 5 wires connection number, which have all 
## wire connection from number 7
six_three <- inputs[len %in% c(5, 6), ] %>% 
  merge(inputs[len ==  3, ], all.x = TRUE, 
        by = c('gr')) %>%
  .[, char_diff_l := char_diff_len(input.y, input.x),
    by = .(gr, input.x)] %>%
  .[(char_diff_l == 1 & len.x == 6) | (char_diff_l == 0 & len.x == 5), .(gr, input.x, len.x)] %>%
  setnames('input.x', 'input') %>%
  .[, final_val_t := ifelse(len.x ==6, 6, 3)] %>%
  .[, -c('len.x')]

inputs <- merge(inputs, six_three, all.x = TRUE, by = c('input', 'gr'))%>%
  .[!is.na(final_val_t), final_val := final_val_t] %>%
  .[order(gr), ] %>%
  .[, -c('final_val_t')]

## Assigning number 5 based on number 6 and 7 connection
five <- inputs[final_val == 6, ] %>%
  merge(inputs[len == 3, ], all.x = TRUE, 
        by = c('gr')) %>%
  .[, char_diff := char_diff(input.y, input.x),
    by = .(gr, input.x)] %>%
  .[, .( gr, char_diff)] %>%
  merge(inputs[len == 5, ],  all.y = TRUE, 
        by = c('gr')) %>%
  .[, five := !grepl(char_diff, input), by = .(input, gr)] %>%
  .[(five), ] %>%
  .[, final_val_t := 5] %>%
  . [, .(input, gr, final_val_t)]

inputs <- merge(inputs, five, all.x=TRUE,  by = c('input', 'gr') ) %>%
  .[!is.na(final_val_t), final_val := final_val_t] %>%
  .[, -c('final_val_t')] %>%
  .[order(gr), ] %>%
  .[is.na(final_val) & len == 5, final_val := 2] 

## Assigning 9 and 0 using number 5 pattern
## 9 and 5 differs by on one wire/connection
## 0 differs from 5 by 2 wire/connections
## 6 was already determined
nine_zero <- inputs[final_val == 5, ] %>%
  merge(inputs[len == 6 & is.na(final_val), ], all.x = TRUE, 
        by = c('gr'))  %>%
  .[, char_diff_len := char_diff_len(input.y, input.x),
    by = .(gr, input.y)]  %>%
  .[, final_val_t := ifelse(char_diff_len == 1, 9, 0)] %>%
  .[, .(gr, input.y, final_val_t)] %>%
  setnames('input.y', 'input') 

inputs <- merge(inputs, nine_zero, all.x=TRUE,  by = c('input', 'gr') ) %>%
  .[!is.na(final_val_t), final_val := final_val_t] %>%
  .[, -c('final_val_t')] %>%
  .[order(gr), ] %>%
  .[, input := char_sort(input),
    by = .(gr, input)]
##------------------------------------------------------------------
## OUTPUT
##------------------------------------------------------------------
d <- unlist(strsplit(output_value, ' '))
out <- data.table(input = d, 
                  gr = sort(rep(1:length(output_value), 4))) %>%
  .[, input := char_sort(input),
    by = .(gr, input)] %>%
  .[, r := seq_len(.N), by = .(gr)] %>%
  merge(inputs, all.x = TRUE, by = c('input', 'gr')) %>%
  .[order(gr, r)] %>%
  .[, .(num = paste(final_val, collapse = '')), by = .(gr)] 

print(sum(as.numeric(out$num)))
