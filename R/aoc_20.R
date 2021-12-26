### AUXILIARY FUNC- converts binary vector to integer
binary_to_integer <- function(binary_vec){ # also R base func strtoi can be used
  return(sum(binary_vec * 
               rep(2, length(binary_vec)) ** c((length(binary_vec)-1):0)))
}

### Preparing inputs
input      <- readLines('../data/dt_20.txt')
enhancment <- input[1]
input      <- input[3:length(input)]

inp_matrix <- matrix(unlist(strsplit(input, '')), ncol = nchar(input[1]), byrow = TRUE)
enhancment <- strsplit(enhancment, '')[[1]]
inp_matrix[inp_matrix=='#'] <- '1'
inp_matrix[inp_matrix=='.'] <- '0'
mode(inp_matrix) <- 'integer'

### F-tion to evaluate output matrix
eval_out_matrix <- function(inp_matrix, enhancment, infinity = FALSE,
                            place_value = rep(2, 9) ** c(8:0),
                            n_max = 2, n = 0) {
  
  out_matrix                <- inp_matrix
  out_matrix[out_matrix==1] <- 0
  
  for (i in 1:(nrow(inp_matrix) - 2)) {
    for (j in 1:(ncol(inp_matrix) - 2)) {
      x   <- inp_matrix[i:(i+2), j:(j+2)]
      x   <- c(t(x))
      val <- binary_to_integer(x) + 1
      if (enhancment[val] == '#') {
        out_matrix[i+1, j+1] <- 1
      }
    }
  }
 
  ### Correcting border
  infinity       <- enhancment[ sum(place_value * infinity) + 1] == '#'
  out_matrix[1,] <- out_matrix[nrow(out_matrix),] <- infinity
  out_matrix[,1] <- out_matrix[,ncol(out_matrix)] <- infinity
  
  n = n + 1
  
  if (n != n_max) {
    out_matrix <- eval_out_matrix(out_matrix, enhancment, infinity,
                                  n_max = n_max, n = n)
  } else {
    return(out_matrix)
  }

}


## adding padding to account for infinity input
pad <- 51
inp_matrix <- rbind(matrix(rep(0, pad * ncol(inp_matrix)), ncol = ncol(inp_matrix)),
                    inp_matrix,
                    matrix(rep(0, pad * ncol(inp_matrix)), ncol = ncol(inp_matrix)))

inp_matrix <- cbind(matrix(rep(0, pad * nrow(inp_matrix)), ncol = pad),
                    inp_matrix,
                    matrix(rep(0, pad * nrow(inp_matrix)), ncol = pad))

##------------------------------------------------------------------
## Part 1
##------------------------------------------------------------------
t1 <- Sys.time()
out_matrix <- eval_out_matrix(inp_matrix, enhancment, n_max = 2)
print(sum(out_matrix))
print(Sys.time() - t1)
##------------------------------------------------------------------
## Part 2
##------------------------------------------------------------------

out_matrix <- eval_out_matrix(inp_matrix, enhancment, n_max = 50)
print(sum(out_matrix))
print(Sys.time() - t1)


