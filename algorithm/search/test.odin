package search

import "core:testing"

sorted_array := [?]int{-9, -7, -5, -3, -1, 0, 1, 3, 5, 7, 9}

@(test)
binary_search_test :: proc(t: ^testing.T) {
	testing.expect_value(t, binary_search(sorted_array[:], -3), 3)
	testing.expect_value(t, binary_search(sorted_array[:], -2), -1)
	testing.expect_value(t, binary_search(sorted_array[:], 3), 7)
	testing.expect_value(t, binary_search(sorted_array[:], 2), -1)
}
