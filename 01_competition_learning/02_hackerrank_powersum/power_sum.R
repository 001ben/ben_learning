library(purrr)
library(rlang)

in_str = suppressWarnings(readLines('/dev/stdin'))
X = as.integer(in_str[[1]])
N = as.integer(in_str[[2]])

constraints = list(
  possible_powers = 2:10,
  max_x = 1000,
  min_x = 1
)

power_table = constraints$possible_powers %>%
  rlang::set_names() %>%
  imap(~ head_while(1:30, function(x) x ^ as.integer(.y) <= constraints$max_x)) %>%
  imap(~ .x ^ as.integer(.y))

find_combos = function(X, table_iter, combos = int(), depth=0L) {
  if(X == 0) return(combos)
  if(X < 0) return(NULL)
  if(length(table_iter) == 0) return(NULL)
  
  map_table = rev(table_iter[cumsum(table_iter) >= X & table_iter <= X])
  
  map_table %>%
    map(~ {
      next_iter_table = setdiff(table_iter, .x)
      find_combos(X-.x, next_iter_table, int(combos, .x), depth+1)
    })
}

start_table = power_table[[as.character(N)]]

possible_vals = find_combos(X, start_table) %>%
  squash() %>%
  compact() %>%
  map(sort) %>%
  unique() %>%
  length()

cat(possible_vals, '\n')
