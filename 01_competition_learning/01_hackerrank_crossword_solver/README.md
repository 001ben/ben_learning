# Crossword Solver

This code was developed for the hackerrank practice problem: https://www.hackerrank.com/challenges/crossword-puzzle/problem

It was first written in R, then re-written in python3 for submission. The logic follows the same few core steps:

1. Extract the blank "positions" in the crossword
2. Recursively attempt all words for each position
3. Maintain a dictionary of "guesses" at each level of recursion, check each attempt at placing a word against guess dictionary
4. Recurse until there are no remaining "solution words" left to check.
