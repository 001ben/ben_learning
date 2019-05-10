# Power sum problem

This code was developed for the hackerrank practice problem: https://www.hackerrank.com/challenges/the-power-sum/problem

1. I pre-compute all the powers of N that are below 1000 and then use the given "power table" as our cases to check for.
2. I then recursively take the highest number that is lower than X from the power table, and subtract it from X to make a new X, then pass it to the next level of recursion.
3. The key finding from this recursive problem was to simplify by automatically eliminating all of the numbers that have a cumulative sum lower than X. An after-thought is that this would be simpler to remove all numbers with less than half the value of X.
4. After finding all potential numbers combinations, we just count the unique sequences of these numbers and print the result
