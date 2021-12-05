t1 <- Sys.time()
library(data.table)
library(magrittr)
import::from('stringr', 'str_split')


### AUXILIARY FUNC
binary_to_integer <- function(binary_vec){ # also R base func strtoi can be used
  return(sum(binary_vec * 
               rep(2, length(binary_vec)) ** c((length(binary_vec)-1):0)))
}

### PREPARING MATRIX
dt <- fread('../data/dt_03.txt',  colClasses = 'character')
m  <- strsplit(dt$V1, split='') %>%
  do.call(rbind, .) %>% as.matrix()
storage.mode(m) <- "numeric"


### PART 1
obs     <- dim(m)[1]
gamma   <- as.numeric(colSums(m)/obs > 0.5) %>% binary_to_integer(.)
  #paste(., collapse = '') %>% strtoi(., base = 2)
epsilon <- as.numeric(colSums(m)/obs < 0.5) %>% binary_to_integer(.)
ans     <- epsilon * gamma
print(paste('Answer 1: ', ans))


### PART 2 - Recursion
rating_generator <- function(m, n, n_max, type){
  obs <- dim(m)[1]
  if (tolower(type) == 'oxygen'){
    a <- (colSums(m)/obs >= 0.5)[n] %>% as.numeric(.)
  } else if (tolower(type) == 'co2 scrubber'){
    a <- (colSums(m)/obs < 0.5)[n] %>% as.numeric(.)
  } else stop(paste0('Iincorrect type provided: ', type))
  
  m <- m[which((m == a)[,n]), ]
  
  if (length(m) == n_max){
    return(binary_to_integer(m))
  } else {
    n <- ifelse(n==n_max, 1, n + 1)
    rating_generator(m, n, n_max, type = type)
  }
}

oxygen       <- rating_generator(m, 1, dim(m)[2], type = 'oxygen')
co2_scrubber <- rating_generator(m, 1, dim(m)[2], type = 'co2 scrubber')

ans <- oxygen * co2_scrubber
print(paste('Answer 2: ', ans))

print( Sys.time() - t1)

