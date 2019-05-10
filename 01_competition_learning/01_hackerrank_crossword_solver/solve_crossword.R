library(tidyverse)

get_positional_representation = function(crossword) {
  row_words = map(crossword, str_locate_all, '-{2,}') %>%
    set_names(seq_along(.)) %>%
    keep(~!is.na(.x[[1]][1])) %>%
    imap(~ paste0(as.integer(.y)-1, seq(.x[[1]][1], .x[[1]][2])-1))
  col_words = map(crossword, str_split, '') %>%
    flatten() %>%
    transpose() %>%
    map(paste0, collapse='') %>%
    map(str_locate_all, '-{2,}') %>%
    set_names(seq_along(.)) %>%
    keep(~ !is.na(.x[[1]][1])) %>%
    imap(~ paste0(seq(.x[[1]][1], .x[[1]][2])-1, as.integer(.y)-1))
  all_words = c(col_words, row_words) %>%
    set_names(paste0('word', seq_along(.)))
  all_words
}

solve = function(wv, word_vecs, filled_in = character(0)) {
  if(length(word_vecs) == 0) return(filled_in)
  cur_word = word_vecs[[1]]
  rem_words = word_vecs[-1]
  length_match = wv %>%
    map_lgl(~ length(.x) == length(cur_word)) %>%
    which()
  # test on one
  
  while(length(length_match) > 0) {
    idx_nms = wv[[length_match[[1]]]]
    word_filled = set_names(cur_word, idx_nms)
    check_list = intersect(idx_nms, names(filled_in))
    if(!all(filled_in[check_list] == word_filled[check_list])) return(FALSE)
    new_filled_in = c(filled_in, word_filled[setdiff(idx_nms, check_list)])
    new_wv = wv[-length_match[[1]]]
    solve_attempt = solve(new_wv, rem_words, new_filled_in)
    if(!is.logical(solve_attempt)) return(solve_attempt)
    length_match = length_match[-1]
  }
}

reconstruct_crossword = function(res, non_blank) {
  0:9 %>%
    map(paste0, 0:9) %>%
    flatten_chr() %>%
    setdiff(names(res)) %>%
    rlang::rep_named(non_blank) %>%
    c(res) %>%
    .[order(names(.))] %>%
    split(map_chr(names(.), str_sub, end=1L)) %>%
    map(paste0, collapse='') %>%
    paste0(collapse='\n') %>%
    paste0('\n')
}

final_program = function(input) {
  lines_split = str_split(input, '\n')[[1]]
  cw = lines_split[1:10]
  non_blank = str_extract(str_flatten(cw), '[^-]')
  words = str_split(lines_split[[11]], ';')[[1]]
  cw_pos = get_positional_representation(cw) 
  word_chr_vecs = words %>%
    map(str_split, '') %>%
    flatten()
  solved = solve(cw_pos, word_chr_vecs)
  reconstruct_crossword(solved, non_blank)
}

input = "+-++++++++
+-++++++++
+-++++++++
+-----++++
+-+++-++++
+-+++-++++
+++++-++++
++------++
+++++-++++
+++++-++++
LONDON;DELHI;ICELAND;ANKARA"
cat(final_program(input))

input="+-++++++++
+-++++++++
+-------++
+-++++++++
+-++++++++
+------+++
+-+++-++++
+++++-++++
+++++-++++
++++++++++
AGRA;NORWAY;ENGLAND;GWALIOR"
cat(final_program(input))

input="XXXXXX-XXX
XX------XX
XXXXXX-XXX
XXXXXX-XXX
XXX------X
XXXXXX-X-X
XXXXXX-X-X
XXXXXXXX-X
XXXXXXXX-X
XXXXXXXX-X
ICELAND;MEXICO;PANAMA;ALMATY"
cat(final_program(input))


