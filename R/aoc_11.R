library(magrittr)
library(data.table)
t1 <- Sys.time()
input  <- readLines('../data/dt_11.txt')
ncols  <- length(input)
nrows  <- nchar(input[1])
vals   <- strsplit(paste0(input), '') %>% unlist() %>% as.numeric()

mat     <- matrix(vals, nrows, ncols) %>% t()
mat_tmp <- copy(mat)
neighbour_eval <- matrix(c(-1, 1, 0, 0, -1, -1, 1, 1,
                            0, 0, -1, 1, -1, 1, -1, 1), ncol = 2)

flash_neighbours <- function(mat, accounted_flash = NULL,
                             neighbour_eval = globalenv()$neighbour_eval,
                             ncols = globalenv()$ncols,
                             nrows = globalenv()$nrows) {
  
  a <- which(mat > 9, arr.ind = TRUE) %>% data.table()

  if (!is.null(accounted_flash)){
    a <- a[!accounted_flash, on=names(a)]
    if (nrow(a) == 0) {
      return(mat)
    }
  }
  rows <- expand.grid(unlist(a[,1]), neighbour_eval[,1])
  cols <- expand.grid(unlist(a[,2]), neighbour_eval[,2])

  pos_add_one <- data.table(rows = rows[, 1] + rows[, 2],
             cols = cols[, 1] + cols[, 2]) %>%
    .[rows > 0 & cols > 0, ] %>%
    .[rows < nrows + 1 & cols < ncols + 1, ] %>%
    .[, n := .N, by= .(rows, cols)] %>% unique()

  mat[as.matrix(pos_add_one[, c(1, 2)])] <- 
    mat[as.matrix(pos_add_one[, c(1, 2)])] + pos_add_one[['n']]

  if (!is.null(accounted_flash)){
    flash_neighbours(mat, rbind(a, accounted_flash))
  } else {
    flash_neighbours(mat, a)
  }
}
##------------------------------------------------------------------
## PART 1
##------------------------------------------------------------------
flash_count <- 0
for (i in (1:100)){
  mat <- mat + 1
  if (any(mat > 9)){
    mat <- flash_neighbours(mat)
    flash_count <- flash_count + sum(mat > 9)
    mat[mat > 9] <- 0
  }
}
print(flash_count)

print(Sys.time() - t1)

##------------------------------------------------------------------
## PART 2
##------------------------------------------------------------------
flash_count <- 0
i <- 0
while (flash_count != 100) {
  mat_tmp <- mat_tmp + 1
  if (any(mat_tmp > 9)){
    mat_tmp <- flash_neighbours(mat_tmp)
    flash_count <- sum(mat_tmp > 9)
    mat_tmp[mat_tmp > 9] <- 0
  } 
  i <- i +1 
}
print(i)
print(Sys.time() - t1)