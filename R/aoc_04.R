t1 <- Sys.time()
library(magrittr)

### PREP DATA
data <- readLines('../data/dt_04.txt')
drawn_nums <- as.numeric(unlist(strsplit(data[1], ',')))
data <- data[3:length(data)] # Dropping drawn number vector
boards_count <- sum(data == '') + 1 # How many boards are playing
# Board size
rows_per_board <- length(data[data!='']) / boards_count
cols_per_board <- sum(strsplit(data[1], ' ')[[1]] != '')

# Preparing matrix of boards
data <- paste(data[data!=''], collapse = ' ')
data <- strsplit(data, ' ')[[1]]
matrix_of_boards <- t(matrix(as.numeric(data[data != '']), nrow = cols_per_board,
                       ncol = rows_per_board * boards_count))
rownames(matrix_of_boards) <- sort(rep(1:boards_count, rows_per_board))

# Solving Using recursion
##------------------------------------------------------------------
## PART 1
##------------------------------------------------------------------
## Recursive function for bingo game play. Function invokes itself until 
## at least one player/board has bingo
bingo_game <- function(play_boards, drawn_nums){
  if (length(drawn_nums) == 0) stop('ERROR: All numbers were drawn - No winner !!!')
  x                             <- drawn_nums[1]
  cols_per_board                <- dim(play_boards)[2]
  rows_per_board                <- dim(play_boards)[1]/length(unique(rownames(play_boards)))
  play_boards[play_boards == x] <- NA_integer_
  
  check_row <- rowSums(is.na(play_boards)) == cols_per_board
  # func. rowsum() allows to compute column sum by rows grouping
  check_col <- rowsum(1*(is.na(play_boards)), rownames(play_boards)) == rows_per_board
  
  if (any(check_row) | any(check_col)) {
    
    winners <- c(rownames(play_boards)[rowSums(is.na(play_boards)) == cols_per_board], 
                  unique(rownames(check_col)[rowSums(check_col)==1]))

    winners_boards <- play_boards[rownames(play_boards) %in% winners, ]

    return(list(score        = sum(winners_boards[!is.na(winners_boards)]) * x,
                winners      = winners,
                boards       = play_boards,
                left_numbers = drawn_nums[-1]))
  } else {
    bingo_game(play_boards, drawn_nums[-1])
  }
}
print(paste('Answer 1: ', 
            bingo_game(matrix_of_boards, drawn_nums)$score))

##------------------------------------------------------------------
## PART 2
##------------------------------------------------------------------
## Recursive function which invokes bingo_game() until all boards are cleared,
## i.e. won/had a bingo
bingo_last_to_win <- function(play_boards, drawn_nums) {
  game        <- bingo_game(play_boards, drawn_nums)
  play_boards <- game$boards[!rownames(game$boards) %in% game$winners, ]
  if (prod(dim(play_boards)) == 0){ #Last board was cleared/won/game Ends
    return(game$score)
  } 
  bingo_last_to_win(play_boards, game$left_numbers)
}

ans <- bingo_last_to_win(matrix_of_boards, drawn_nums)
print(paste('Answer 2: ', ans))
print( Sys.time() - t1)

##--------------------------------------------------------------------------
## CODING USING ARRAYS rather than one big matrix of all boards
## Working with boards which were split into array of boards, could be more
## intuitive, than  having them together in one big matrix with named rows
##--------------------------------------------------------------------------

t1 <- Sys.time()
## Recursive game play Function, which runs until last board is cleared.
## and returns vector of all scores, i.e. score for each board
full_bingo_game_arr <- function(array_of_boards, drawn_nums, 
                                scores = NULL){
  if(is.null(scores)) scores <- rep(NA_integer_, dim(array_of_boards)[3])
  
  x <- drawn_nums[1]
  array_of_boards[array_of_boards==x] <- NA_integer_
  winners <- 
    c(which(colSums(colSums(aperm(is.na(array_of_boards) , c(2,1,3))) == dim(array_of_boards)[2])  > 0),
      which(colSums(colSums(is.na(array_of_boards)) == dim(array_of_boards)[1]) >0)) %>% unique()
  
  # Assigning scores for winners
  if (length(winners) > 0) {
    winners_boards <- array_of_boards[,,winners]
    
    # Saving scores
    if (length(winners) > 1) {
      score <- colSums(colSums(winners_boards, na.rm = TRUE)) * x
    } else score <- sum(winners_boards, na.rm = TRUE)  * x
    
    scores[which(is.na(scores))[1:length(winners)]] <- score
    # Removing winning boards
    array_of_boards <- array_of_boards[,, setdiff(1:dim(array_of_boards)[3], winners)]
    
    #Clearing last board
    if (length(dim(array_of_boards)) != 3 ) {
      winner <- c()
      while(length(winner) == 0){
        drawn_nums <- drawn_nums[-1]
        x <- drawn_nums[which(drawn_nums %in% array_of_boards)[1]]
        array_of_boards[array_of_boards == x] <- NA_integer_
        winner <- c(which(any(rowSums(is.na(array_of_boards)) == dim(array_of_boards)[2])),
                    which(any(colSums(is.na(array_of_boards)) == dim(array_of_boards)[2]))) %>% unique()
      }
      scores[length(scores)] <-  sum(array_of_boards, na.rm = TRUE)  * x
      return(scores) # All boards are cleared/game ends
    } # END of clearing last board
  } # END of score assignment
  full_bingo_game_arr(array_of_boards, drawn_nums[-1], scores)
}

##------------------------------------------------------------------

array_of_boards <- array(as.matrix(matrix_of_boards),
                         dim = c(rows_per_board, boards_count, cols_per_board)) %>%
  aperm(., c(1, 3, 2))

scores <- full_bingo_game_arr(array_of_boards, drawn_nums, rep(NA_character_, boards_count))

print(paste('Answer 1: ', scores[1]))
print(paste('Answer 2: ', scores[boards_count]))
print(Sys.time() - t1)
