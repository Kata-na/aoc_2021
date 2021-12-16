rm(list = ls())

library(data.table)
library(magrittr)
input <- readLines('../data/dt_14.txt')
inp   <- input[1]
inp_s <- unlist(strsplit(inp, ''))
map   <- gsub('^[A-Z]{2} -> ([A-Z])' ,'\\1', input[!input %in% c('', inp)])
names(map) <- gsub('^([A-Z]{2}) -> [A-Z]' ,'\\1', input[!input %in% c('', inp)])

# --------------------------------------------------------------
# PART 1
# --------------------------------------------------------------
for (i in 1:10) {
  val <- paste0(inp_s[1:(length(inp_s)-1)], inp_s[2:length(inp_s)])
  insert <- map[names(map) %in% val] 
  insert <- insert[match(val, names(insert))]
  inp_s <- paste(c(paste0(inp_s[1:(length(inp_s)-1)], insert),
                   inp_s[length(inp_s)]), collapse = '')
  inp_s <- unlist(strsplit(inp_s, ''))
}
cnt <- table(inp_s)
print(paste0('Answer 1: ', max(cnt) - min (cnt)))

## -----------------------------------------------------------------------------
## PART 2 (& PART 1)
## -----------------------------------------------------------------------------
inp_s <- unlist(strsplit(inp, ''))
val   <- paste0(inp_s[1:(length(inp_s)-1)], inp_s[2:length(inp_s)])

pairs        <- rep(0, length(names(map)))
names(pairs) <- names(map)
pairs[names(pairs) %in% names(table(val))] <- table(val)

letters              <- unique(unlist(strsplit(names(pairs), '')))
letters_count        <- rep(0, length(letters))
names(letters_count) <- letters
letters_count[match(names(table(inp_s)), names(letters_count))] <- table(inp_s)

## Creating map of insertions
insertion_map <- list()
for (x in names(map)) {
  ins  <- map[names(map) == x]
  code <- unlist(strsplit(x, ''))
  insertion_map[[paste0(x, '->', ins)]] <- c(paste0(code[1], ins), paste0(ins, code[2]))
}

# LOOP
for (i in 1:40) {
  x  <- pairs[pairs!=0]
  y  <- map[names(map) %in% names(x)] 
  nn <- paste0(names(y), '->', unname(y))
  
  # Updating letter/elements count
  letter_cnt <- data.table(y, x) %>%
    .[, .(x = sum(x)), by = .(y)]
  
  letters_count[match(letter_cnt[['y']], names(letters_count))] <- 
    letters_count[match(letter_cnt[['y']], names(letters_count))] +
    letter_cnt[['x']]
  # Updating existing pairs
  new_pairs  <- insertion_map[names(insertion_map) %in% nn]
  new_pairs  <- new_pairs[match(names(x), gsub('^(..)->.', '\\1', names(new_pairs)))]
  pair_count <- data.table(unname(unlist(new_pairs)), 
                           c(rbind(x, x))) %>%
    .[, .(V2 = sum(V2)), by = .(V1)]
  
  pairs[match(pair_count[['V1']], names(pairs))] <- pair_count[['V2']]
  pairs[!names(pairs) %in% pair_count[['V1']]] <- 0
  if(i == 10) {
    print(paste0('Answer 1: ', max(letters_count) - min(letters_count)))
  }
} # END OF LOOP

print(paste0('Answer 2: ', max(letters_count) - min(letters_count)))
