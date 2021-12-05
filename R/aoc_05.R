t1 <- Sys.time()
library(magrittr)

lines <- readLines('../data/dt_05.txt')
prep_coord_matrix <- function(x) {
  return (strsplit(x, ',') %>% unlist() %>% as.integer() %>%
    matrix(., nrow = 2) %>% t())
}

coor1 <- gsub('(\\d+?,\\d+?) -> \\d+?,\\d+?$', '\\1', lines) %>%
  prep_coord_matrix(.)
coor2 <- gsub('^\\d+?,\\d+? -> (\\d+?,\\d+?)', '\\1', lines) %>%
  prep_coord_matrix(.)

##------------------------------------------------------------------
## PART 1
##------------------------------------------------------------------
mask <- rowSums(coor1 == coor2) > 0
movement_matrix <- matrix(0, max(coor2,coor1)+1, max(coor2,coor1)+1)
## Horizontal & vertical lines
for (i in 1:dim(coor1[mask, ])[1]) {
  c1         <- coor1[mask, ][i, ] + 1
  c2         <- coor2[mask, ][i, ] + 1
  m1         <- cbind(c1[2]:c2[2], c1[1]:c2[1])
  movement_matrix[m1] <- movement_matrix[m1] + 1
}

ans <- sum(movement_matrix > 1)
print(paste('Answer 1: ', ans))

##------------------------------------------------------------------
## PART 2
##------------------------------------------------------------------
movement_matrix <- matrix(0, max(coor2,coor1)+1, max(coor2,coor1)+1)

for (i in 1:dim(coor1)[1]) { 
  c1         <- coor1[i, ] + 1
  c2         <- coor2[i, ] + 1
  m1         <- cbind(c1[2]:c2[2], c1[1]:c2[1])
  movement_matrix[m1] <- movement_matrix[m1] + 1
}
ans <- sum(movement_matrix > 1)
print(paste('Answer 2: ', ans))       
print(Sys.time() - t1)