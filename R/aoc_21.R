input <- readLines('../data/dt_21.txt')
input <- as.integer(gsub('^.*?(\\d*)$', '\\1', input))
p1 <- input[1]
p2 <- input[2]

##------------------------------------------------------------------
## Part 1
##------------------------------------------------------------------
rolled <- 1:1500
m <- matrix(c(rolled, rep(0, 1500 %% 3)), ncol =3, byrow = TRUE)
positions <- rowSums(m)
positions[1] <- positions[1] + p1
positions[2] <- positions[2] + p2

### player 1
s1 <- cumsum(positions[(1:length(positions)) %% 2 == 1])
s1 <- (s1 - 1) %% 10 + 1

### player 2
s2 <- cumsum(positions[(1:length(positions)) %% 2 != 1])
s2 <- (s2 - 1) %% 10 + 1

if (any(cumsum(s1) == 1000)) {
  oo  <- which(cumsum(s1) == 1000) 
  m1  <- cumsum(s2)[oo-1]
  m2  <- oo * 6 - 3
  ans <- m1 * m2
} else if (any(cumsum(s2) == 1000)) {
  oo  <- which(cumsum(s2) == 1000) 
  m1  <- cumsum(s1)[oo-1]
  m2  <- oo * 6 
  ans <- m1 * m2
}
print(paste0('Answer 1: ', ans))


##------------------------------------------------------------------
## Part 2
##------------------------------------------------------------------
cache           <- collections::dict()

die_3_roll_opt  <- rowSums(expand.grid(1:3, 1:3, 1:3))
die_rolls       <- table(die_3_roll_opt)
die_3_roll_opt  <- unique(die_3_roll_opt)

game <- function(p1, p2, s1, s2){
  
  if (s1 >= 21) {
    return(c(1,0))
  } else  if (s2 >= 21) {
    return(c(0,1))
  }
  key <- paste(p1, p2, s1, s2, sep = ":")
  if(cache$has(key)) return(cache$get(key))
  
  res <- c(0, 0)
  
  for (die in globalenv()$die_3_roll_opt) {
    new_pos <- ((p1 - 1) + die) %% 10 + 1
    new_sc  <- s1 + new_pos
    k       <- rev(game(p2, new_pos, s2, new_sc)) * die_rolls[as.character(die)]
    res     <- res + k
  }
  cache$set(key, res)
  res
}

print(paste0('Answer 2: ', max(game(p1, p2, 0, 0))))


