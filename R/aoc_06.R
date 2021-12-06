inp <- readLines('../data/dt_06.txt')
inp <- unlist(strsplit(inp, ','))
inp <- as.numeric(inp)


fish_spawn <- function(initial_population, days){
  place_holder <- rep(0, 9) # placeholder of fish count by days till spawn
  for (i in 0:6) { 
    place_holder[i+1] <- sum(initial_population==i)
  }

  for (day in 1:days) {
    spawn = place_holder[1]
    # moving count of old fishes by one day in the placeholder
    place_holder[1:(length(place_holder)-1)] <- place_holder[2:length(place_holder)]
    # adding fishes who produced new generation to count of fishes with 7 days till spawn
    place_holder[7] <- place_holder[7] + spawn 
    place_holder[9] <- spawn # new generation fishes
  }
  return(sum(place_holder))
}
print(paste0('Answer 2: ', fish_spawn(inp, 80)))
print(paste0('Answer 2: ', fish_spawn(inp, 256)))
##-----------------------------------------------------------------------------

