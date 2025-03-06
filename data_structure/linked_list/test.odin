package linked_list

import "core:testing"

@(test)
linked_list_test :: proc(t: ^testing.T) {
	list := List(int){}
	defer delete_list(&list)
	

	testing.expect(t, is_empty(&list))

	push_back(&list, 2)
	push_front(&list, 1)
	push_back(&list, 4)
	testing.expect_value(t, pop_back(&list), 4)
	push_back(&list, 5)
	testing.expect_value(t, remove(&list, list.tail), 5)
	push_back(&list, 3)
	push_front(&list, 0)
	testing.expect_value(t, pop_front(&list), 0)
	
	testing.expect(t, !is_empty(&list))

	
	head_it := Iterator(int){ current = list.head }
	value, ok := iterate_next(&head_it)
	testing.expect_value(t, value^, 1)
	testing.expect(t, ok)
	
	value, ok = iterate_next(&head_it)
	testing.expect_value(t, value^, 2)
	testing.expect(t, ok)
	
	value, ok = iterate_next(&head_it)
	testing.expect_value(t, value^, 3)
	testing.expect(t, ok)

	value, ok = iterate_next(&head_it)
	testing.expect(t, !ok)

	
	tail_it := Iterator(int){ current = list.tail }
	value, ok = iterate_prev(&tail_it)
	testing.expect_value(t, value^, 3)
	testing.expect(t, ok)
	
	value, ok = iterate_prev(&tail_it)
	testing.expect_value(t, value^, 2)
	testing.expect(t, ok)
	
	value, ok = iterate_prev(&tail_it)
	testing.expect_value(t, value^, 1)
	testing.expect(t, ok)

	value, ok = iterate_prev(&tail_it)
	testing.expect(t, !ok)
}
