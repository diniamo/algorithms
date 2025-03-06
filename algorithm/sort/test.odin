package sort

import "base:intrinsics"
import "core:slice"
import "core:testing"

array := [?]int{5, 3, -7, 2, -11, 10}

@(test)
selection_sort_test :: proc(t: ^testing.T) {
	copy := slice.clone(array[:])
	selection_sort(copy)
	testing.expect(t, slice.is_sorted(copy))
	delete(copy)
}

@(test)
quicksort_test :: proc(t: ^testing.T) {
	copy := slice.clone(array[:])
	quicksort(copy)
	testing.expect(t, slice.is_sorted(copy))
	delete(copy)
}
