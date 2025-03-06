package sort

import "base:intrinsics"
import "core:fmt"
import "core:slice"

// O(n^2)
selection_sort :: proc(array: []$T) where intrinsics.type_is_ordered(T) {
	count := len(array)
	
	for start_index in 0..<count {
		min := array[start_index]
		min_index := start_index
		
		for i in (start_index + 1)..<count {
			element := array[i]
			
			if element < min {
				min = element
				min_index = i
			}
		}

		array[start_index], array[min_index] = array[min_index], array[start_index]
	}
}

