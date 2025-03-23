package dp

import "core:testing"

@(test)
knapsack_test :: proc(t: ^testing.T) {
	capacity: uint = 4
	weights := [?]uint{4, 3, 1}
	values := [?]uint{3000, 2000, 1500}
	result: uint = 3500

	testing.expect_value(t, knapsack_recursive(capacity, weights[:], values[:]), result)
	testing.expect_value(t, knapsack_iterative(capacity, weights[:], values[:]), result)
}
