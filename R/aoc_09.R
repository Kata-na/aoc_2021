library(magrittr)
t1    <- Sys.time()
input <- readLines('../data/dt_09.txt')
rows  <- length(input)
cols  <- nchar(input[1])

mat   <- matrix(as.numeric(unlist(strsplit(input, ''))), cols, rows) %>% t()

##------------------------------------------------------------------
## PART1
##------------------------------------------------------------------
left <- right <- up <- down <-  matrix(TRUE, cols, rows) %>% t()
right[, 1:(cols-1)] <- mat[, 1:(cols-1)] < mat[, 2:cols]
left[, 2:cols]      <- !right[, 1:(cols-1)] 
down[1:(rows-1), ]  <- mat[1:(rows-1), ] < mat[2:rows, ]
up[2:rows, ]        <- !down[1:(rows-1), ]

ans <- sum(mat[right & left & up & down] + 1)
print(glue::glue('Answer 1: {ans}'))
print(Sys.time() - t1)
##------------------------------------------------------------------
## PART 2
##------------------------------------------------------------------
mask       <- mat == 9
mat[mask]  <- 0
mat[!mask] <- 1

generate_potential_points <- function(rp, cp) {
  potential_cols   <- c(rp, rp, rp - 1, rp + 1)
  potential_rows   <- c(cp -1, cp + 1, cp, cp)
  ## Dropping invalid coordinates
  mask <- potential_cols %in% c(0, cols+1) | potential_rows %in% c(0, rows+1) 
  potential_rows <- potential_rows[!mask]
  potential_cols <- potential_cols[!mask]
  potential_points <- paste0(potential_cols, '_', potential_rows)
  return(potential_points)
}

### Recursive function to find basins of a provided low points
low_point_basin_lookup <- function(mat, low_idx, basin_placeholder = NULL) {

  
  if (is.null(basin_placeholder)) basin_placeholder <- c()
  
  if (length(low_idx) > 2) {
    rp <- low_idx[1,1] %>% unname()
    cp <- low_idx[1,2] %>% unname()
  } else {
    rp <- low_idx[1] %>% unname()
    cp <- low_idx[2] %>% unname()
  }
  
  cheked_points    <- paste0(rp, '_', cp)
  basin_size       <- 0
  potential_points <- generate_potential_points(rp, cp)
  
  while (length(potential_points) != 0) {
    x <- strsplit(potential_points[1], '_')[[1]] %>% as.integer()
    cheked_points <- c(cheked_points, potential_points[1])
    
    if (mat[x[1], x[2]] == 1) {
      basin_size = basin_size + 1
      potential_points <- c(potential_points, generate_potential_points(x[1], x[2])) %>%
        unique()
    }
    potential_points <- potential_points[!potential_points %in% cheked_points]
  }
  
  basin_placeholder <- c(basin_placeholder, basin_size + 1)

  if (length(low_idx) > 2) {
    low_point_basin_loopup(mat, low_idx[2:nrow(low_idx), ], basin_placeholder)
  } else {
    return(basin_placeholder)
  }
}

low_points_idx <- which(right & left & up & down, arr.ind=TRUE)
basins         <- low_point_basin_lookup(mat, low_points_idx)
ans            <- prod(sort(basins, decreasing = TRUE)[1:3])
print(glue::glue('Answer 2: {ans}'))
print(Sys.time() - t1)
