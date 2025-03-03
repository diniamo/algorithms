package sort

import "base:intrinsics"
import "core:fmt"
import "core:slice"

// O(n^2)
selection_sort :: proc(array: []$T) where intrinsics.type_is_numeric(T) {
	count := len(array)
	if count < 2 do return

	original := slice.clone(array)
	used := make([]bool, count, context.temp_allocator)

	min := max(T)
	min_index: int

	for i in 0..<count {
		for e, j in original {
			if e < min && !used[j] {
				min = e
				min_index = j
			}
		}

		array[i] = min
		used[min_index] = true

		min = max(T)
	}
}

// Average/best case: O(n log n)
// Worst case: O(n^2)
quicksort :: proc(array: []$T) where intrinsics.type_is_ordered(T) {
	count := len(array)
	if count < 2 do return

	original := slice.clone(array, context.temp_allocator)
	
	left_index := -1
	pivot := array[0]
	right_index := count

	for i in 1..<count {
		element := original[i]

		if element > pivot {
			right_index -= 1
			array[right_index] = element
		} else {
			left_index += 1
			array[left_index] = element
		}
	}
	
	pivot_index := left_index + 1
	when ODIN_DEBUG do assert(pivot_index == right_index - 1)
	array[pivot_index] = pivot

	quicksort(array[:pivot_index])
	quicksort(array[right_index:])
}

@(private)
main :: proc() {
	array := [?]int{5, 3, 6, 2, 10}

	fmt.println(array)

	copy := slice.clone(array[:])
	selection_sort(copy)
	fmt.printfln("selection_sort -> %v", copy)

	copy = slice.clone(array[:])
	quicksort(copy)
	fmt.printfln("quicksort -> %v", copy)
}
