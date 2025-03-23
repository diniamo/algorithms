package dp

knapsack_recursive :: proc(capacity: uint, weights: []uint, values: []uint) -> uint {
	when ODIN_DEBUG do assert(len(weights) == len(values))

	// Just imagine this is memoized
	maxValue_fromIndex_withWeightValue :: proc(
		capacity: uint, weights: []uint, values: []uint,
		i: uint, w: uint
	) -> uint {
		if i == len(values) do return 0
		
		steal: uint
		if w + weights[i] <= capacity {
			steal = values[i] + maxValue_fromIndex_withWeightValue(
				capacity, weights, values,
				i + 1, w + weights[i]
			)
		}
		leave := maxValue_fromIndex_withWeightValue(
			capacity, weights, values,
			i + 1, w
		)
		
		return steal if steal > leave else leave
	}

	return maxValue_fromIndex_withWeightValue(
		capacity, weights, values,
		0, 0
	)
}

knapsack_iterative :: proc(capacity: uint, weights: []uint, values: []uint) -> uint {
	when ODIN_DEBUG do assert(len(weights) == len(values))

	dp_i1 := make([]uint, capacity + 1)
	dp_i := make([]uint, capacity + 1)
	defer {
		delete(dp_i1)
		delete(dp_i)
	}

	for i := len(weights) - 1;; i -= 1 {
		for w := capacity;; w -= 1 {
			dp_i[w] = max(values[i] + dp_i1[w + weights[i]], dp_i1[w]) if w + weights[i] <= capacity else dp_i1[w]
			if w == 0 do break
		}

		dp_i1, dp_i = dp_i, dp_i1
		if i == 0 do break
	}

	return dp_i1[0]
}
