package binary_search

import "base:intrinsics"
import "core:fmt"

// O(log n)
binary_search :: proc(array: []$T, element: T) -> int where intrinsics.type_is_ordered(T) {
	low := 0
	high := len(array) - 1
	
	for low <= high {
		mid := (low + high) / 2
		guess := array[mid]

		if guess < element {
			low = mid + 1
		} else if guess > element {
			high = mid - 1
		} else {
			return mid
		}
	}

	return -1
}

@(private)
main :: proc() {
	array := [?]int{1, 3, 5, 7, 9}

	fmt.printfln("3 -> %d", binary_search(array[:], 3))
	fmt.printfln("2 -> %d", binary_search(array[:], 2))
}
