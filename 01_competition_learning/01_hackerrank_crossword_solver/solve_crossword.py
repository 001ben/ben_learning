#!/bin/python3
import math
import os
import random
import re
import sys

crossword = [
'+-++++++++',
'+-++++++++',
'+-++++++++',
'+-----++++',
'+-+++-++++',
'+-+++-++++',
'+++++-++++',
'++------++',
'+++++-++++',
'+++++-++++'
]
words = 'LONDON;DELHI;ICELAND;ANKARA'

# Does a regex search for "more than one - character" and adds a vector of "locations" representing the blank position in crossword
def get_word_indices(crossword):
    vector_out = []
    for i in range(len(crossword)):
        for m in re.finditer('-{2,}', crossword[i]):
            vector_out.append([(str(i), str(j)) for j in range(m.start(0), m.end(0))])
    return vector_out

# Searches for words in rows and then columns, transposing the crossword before searching the columns
def get_position_word_vectors(crossword):
    row_words = [[''.join(tup) for tup in x] for x in get_word_indices(crossword)]
    t_crossword = [''.join(x) for x in zip(*[list(x) for x in crossword])]
    col_words = [[''.join(reversed(tup)) for tup in x] for x in get_word_indices(t_crossword)]
    return row_words + col_words

def solve_crossword(word_positions, solution_words, guess_list = {}):
    if len(solution_words)==0:
        print('solved!')
        return guess_list
    
    # We just solve each position incrementally
    position_attempt = word_positions[0]
    # remove the first position to solve
    next_word_positions = word_positions[1:]
    # get indexes of words which have the right length
    words_to_try_idx = [x for x in range(len(solution_words)) if len(solution_words[x]) == len(position_attempt)]
    #  print(words_to_try_idx)
    for i in words_to_try_idx:
        # for each word, add to a dictionary
        cur_word_attempt = dict(zip(position_attempt, solution_words[i]))
        # ensure that any matching keys between this word and previously guessed words match on the indexes
        attempt_valid = all(guess_list[k]==cur_word_attempt[k] for k in guess_list.keys() & cur_word_attempt.keys())
        if attempt_valid:
            # If attempt is valid, add current word to guess list
            next_guess_list = {**guess_list, **cur_word_attempt}
            # remove current word from solution words
            next_solution_words = solution_words[:i] + solution_words[i+1:]
            # recurse
            solve_attempt = solve_crossword(next_word_positions, next_solution_words, next_guess_list)
            # if a solve attempt is returned, we have successfully solved the crossword
            if solve_attempt is not None:
                return solve_attempt
    return None

def construct_solved_crossword(solution, blank_chr):
    blank_idx = [str(i) + str(j) for i in range(0,10) for j in range(0,10)] - solution.keys()
    blanks = dict((i, blank_chr) for i in blank_idx)
    filled_crossword_dict = {**blanks, **solution}
    filled_crossword_dict_sorted = dict((i, filled_crossword_dict[i]) for i in sorted(filled_crossword_dict))
    final_crossword = dict((str(i), list()) for i in range(10))
    [final_crossword[e[0]].append(filled_crossword_dict[e]) for e in filled_crossword_dict_sorted]
    return [''.join(x) for x in list(final_crossword.values())]

# Complete the crosswordPuzzle function below.
def crosswordPuzzle(crossword, words):
    blank_chr = re.search('[^-]', crossword[0]).group()
    word_positions = get_position_word_vectors(crossword)
    solution_words = words.split(';')
    solution = solve_crossword(word_positions, solution_words, guess_list={})
    return construct_solved_crossword(solution, blank_chr)

if __name__ == '__main__':
    fptr = open(os.environ['OUTPUT_PATH'], 'w')

    crossword = []

    for _ in range(10):
        crossword_item = input()
        crossword.append(crossword_item)

    words = input()

    result = crosswordPuzzle(crossword, words)

    fptr.write('\n'.join(result))
    fptr.write('\n')

    fptr.close()


