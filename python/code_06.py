import numpy as np

def fish_spawn(initial_pop, days):
    placeholder = np.zeros(9, np.int64) # placeholder of fish count by days till spawn
    placeholder[:6] = np.array([np.sum(initial_pop == x) for x in range(6)])

    for _ in range(days):
        spawn = placeholder[0]
        placeholder[:-1] = placeholder[1:] # moving by one day
        # adding fishes, which spawn on current day to fishes 
        # with 7 days till next spawn:
        placeholder[6] += spawn
        placeholder[8] = spawn # new generation/born fishes

    return np.sum(placeholder)

if __name__ == '__main__':
    dt = open('./data/dt_06.txt').read().split('\n')

    input = np.array(dt[0].split(','), dtype=int)

    print(f"Answer 1: {fish_spawn(input, 80)}")
    print(f"Answer 2: {fish_spawn(input, 256)}")