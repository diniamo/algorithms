package sort

import "base:intrinsics"
import "core:fmt"

// O(n^2)
selection_sort :: proc(array: []$T) -> []T where intrinsics.type_is_numeric(T) {
	count := len(array)
	sorted := make([]T, count)
	used := make([]bool, count, context.temp_allocator)

	min := max(T)
	min_index: int
	
	for i in 0..<count {
		for e, j in array {
			if e < min && !used[j] {
				min = e
				min_index = j
			}
		}

		sorted[i] = min
		used[min_index] = true
		
		min = max(T)
	}

	return sorted
}

@(private)
main :: proc() {
	array := [?]int{5, 3, 6, 2, 10}

	fmt.println(array)

	fmt.printfln("selection_sort -> %v", selection_sort(array[:]))
}
