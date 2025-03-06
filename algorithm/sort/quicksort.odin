package sort

import "base:intrinsics"

@(private="file")
partition_lomuto :: proc(array: []$T) -> int {
	count := len(array)

	pivot_index := count - 1
	pivot := array[pivot_index]
	swap_index := 0

	for i in 0..<pivot_index {
		element := array[i]

		if element < pivot {
			array[swap_index], array[i] = element, array[swap_index]
			swap_index += 1
		}
	}

	array[swap_index], array[pivot_index] = pivot, array[swap_index]

	return swap_index
}

// This is more efficient than the above, but a bit harder to understand.
// The key here for me was that the initial pivot isn't (always) the same as the pivot that's returned.
@(private="file")
partition_hoare :: proc(array: []$T) -> int {
	pivot := array[0]
	i := -1
	j := len(array)

	for {
		for {
			i += 1
			if array[i] >= pivot do break
		}

		for {
			j -= 1
			if array[j] <= pivot do break
		}

		if j <= i do break
		array[i], array[j] = array[j], array[i]
	}

	return j
}

// Average/best case: O(n log n)
// Worst case: O(n^2)
quicksort :: proc(array: []$T) where intrinsics.type_is_ordered(T) {
	if len(array) < 2 do return

	pivot_index := partition_hoare(array)
	
	quicksort(array[:pivot_index])
	// The pivot has to be included here for Hoare, not entirely sure why
	quicksort(array[pivot_index:])
}
