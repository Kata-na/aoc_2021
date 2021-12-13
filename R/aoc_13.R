library(magrittr)
t1 <- Sys.time()
input     <- readLines('../data/dt_13.txt')
fold_info <- input[grepl('fold along', input)]
input     <- input[!input %in% c('', fold_info)]

idx <- as.integer(unlist(strsplit(input, ','))) %>%
  matrix(., ncol = 2, byrow = TRUE)
idx            <- idx[, ncol(idx):1] # flipping cols
paper          <- matrix(FALSE, nrow = max(idx[, 1]) + 2, ncol = max(idx[, 2]) + 1)
paper[idx + 1] <- TRUE

fold_xy        <- (gsub('fold along .=(\\d+)$', '\\1', fold_info) %>% as.integer()) + 1
names(fold_xy) <- gsub('fold along (.)=\\d+$', '\\1', fold_info)

for (i in fold_xy) {
  fold_type <- names(fold_xy[fold_xy == i ])
  if (fold_type == 'x') {
    second_half <- paper[, ncol(paper):(i + 1)] # taking second half & flipping cols
    paper       <- paper[, 1:(i-1)] | second_half
  } else {
    second_half <- paper[nrow(paper):(i + 1), ] # taking second half & flipping cols
    paper       <- paper[1:(i-1), ] | second_half
  }
  if (i == fold_xy[1]) print(paste0('Answer 1: ', sum(paper)))
}

image(t(paper)[, nrow(paper):1], col = hcl.colors(12, 'viridis'))
print(Sys.time() - t1)
