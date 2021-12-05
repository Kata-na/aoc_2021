import numpy as np
import re

path = './data/dt_04.txt'

### PREP DATA
def read_and_prep_data(path):
    d          = open(path).read().split('\n')
    drawn_nums = np.array(d[0].split(','), dtype=int)
    d          = d[2:] # boards
    
    # Board dimensions and number of boards
    boards_count   = len([x for x in d if x == ''])
    cols_per_board = len(re.sub('^ | $', '', re.sub('  ', ' ', d[1])).split(' '))
    rows_per_board = int((len(d) - boards_count)/boards_count)

    # Boards data cleaning
    d = np.array(' '.join(d).split(' '))
    d = d[d != ''].astype(int)
    all_boards = d.copy().reshape((boards_count, rows_per_board, cols_per_board))
    return all_boards, drawn_nums, (cols_per_board, rows_per_board)


def bingo_game(playing_boards, drawn_nums, board_dims):
    x = drawn_nums[0]
    playing_boards[playing_boards == x] = -1
    winners_row = np.where(np.sum(playing_boards == -1, axis=2) == board_dims[1])[0]
    winners_col = np.where(np.sum(playing_boards == -1, axis=1) == board_dims[0])[0]

    if winners_row.shape[0] | winners_col.shape[0]:
        if winners_row.shape[0]: 
            winners = [winners_row[0]]
        else: winners = []
        if winners_col.shape[0]: winners.append(winners_col[0])

        winners_boards = playing_boards[list(set(winners))]
        score = sum(winners_boards[winners_boards != -1]) * x
        return score, winners, playing_boards, drawn_nums[1:]
    else:
        return bingo_game(playing_boards, drawn_nums[1:], board_dims)


def bingo_last_to_win(playing_boards, drawn_nums, board_dims):
    score, winners, playing_boards, drawn_nums = bingo_game(playing_boards, drawn_nums, board_dims)
    idx = [i for i in range(playing_boards.shape[0]) if i not in winners]
    playing_boards = playing_boards[idx]
    if playing_boards.shape[0] == 0 :
        return score
    return bingo_last_to_win(playing_boards, drawn_nums, board_dims)

if __name__ == "__main__":
    ### PREP DATA
    all_boards, drawn_nums, board_dims = read_and_prep_data(path)

    ### PART 1
    score, winner, _, _ = bingo_game(all_boards, drawn_nums, board_dims)
    print(f"Answer 1: {score}")

    ### PART 2
    score = bingo_last_to_win(all_boards, drawn_nums, board_dims)
    print(f"Answer 2: {score}")