library(magrittr)
library(data.table)

input <- readLines('../data/dt_10.txt')

##------------------------------------------------------------------
## FUNCTIONS
##------------------------------------------------------------------
find_illegal_char_n_incomplete_lines <- function(x) {
  ## RECURSIVE
  out <- gsub('\\(\\)|\\[\\]|\\{\\}|<>', '', x, perl = TRUE)

  if (!grepl('\\}|\\)|\\]|>', x)) {
    return(paste0('incomplete: ', x))
    
  } else if (out != x) {
    find_illegal_char_n_incomplete_lines(out)
    
  } else {
    return(gsub('(?:^.*?)(\\}|\\)|\\]|>).*?$', '\\1', x, perl = TRUE))
  }
}

calc_incomplete_string_score <- function(x, points = globalenv()$points_2) {
  end <- rev(strsplit(x, '')[[1]])
  return(sum(rev(rep(5, length(end)) ^ (0:(length(end)-1))) * points[end]))
}

##------------------------------------------------------------------
## Inputs : scoring and character mapping
##------------------------------------------------------------------
points_1 <- data.table(char = c(')', ']', '}', '>'),
                       pnt = c(3, 57, 1197, 25137))
points_2 <-  c("(" = 1,
               "[" = 2,
               "{" = 3,
               "<" = 4)
##------------------------------------------------------------------
## PART 1
##------------------------------------------------------------------
chunks <- data.table(inp = input) %>%
  .[, check := find_illegal_char_n_incomplete_lines(inp), by = .(inp)]

error_score <- chunks[!grep('incomplete', check), ] %>%
  merge(points_1, all.x = TRUE, by.x = 'check', by.y = 'char') %>%
  .[, pnt] %>%
  sum()

print(paste0('Answer 1: ', error_score))

##------------------------------------------------------------------
## PART 2
##------------------------------------------------------------------
incomplete_chunks <- setnames(chunks[grep('incomplete', check),'check'], 'check', 'inp')
incomplete_chunks[, 'inp'] <- gsub('incomplete: ', '', incomplete_chunks[['inp']])

middle_score <- incomplete_chunks %>%
  .[, points := calc_incomplete_string_score(inp), by = .(inp)] %>%
  .[, points] %>% median()

print(paste0('Answer 2: ', middle_score))

