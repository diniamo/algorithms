// This is just a proof-of-concept implementation - polymorphism isn't ideal.
// See core/container/intrusive/list/intrusive_list.odin for something more ergonomic.
package linked_list

Element :: struct($T: typeid) {
	data: T,
	next: ^Element(T),
	prev: ^Element(T)
}

List :: struct($T: typeid) {
	head: ^Element(T),
	tail: ^Element(T)
}

Iterator :: struct($T: typeid) {
	current: ^Element(T)
}

// O(1)
is_empty :: proc(list: ^List($T)) -> bool {
	return list.head == nil
}

// O(1)
push_front :: proc(list: ^List($T), data: T) {
	element := new(Element(T))
	element.data = data

	if list.head == nil {
		list.head = element
		list.tail = element
	} else {
		list.head.prev = element
		element.next = list.head
		list.head = element
	}
}

// O(1)
push_back :: proc(list: ^List($T), data: T) {
	element := new(Element(T))
	element.data = data

	if list.tail == nil {
		list.head = element
		list.tail = element
	} else {
		list.tail.next = element
		element.prev = list.tail
		list.tail = element
	}
}

// O(1)
pop_front :: proc(list: ^List($T)) -> (ret: T) {
	if list.head == nil do return ret
	
	data := list.head.data
	
	new_head := list.head.next
	new_head.prev = nil
	free(list.head)
	list.head = new_head

	return data
}

// O(1)
pop_back :: proc(list: ^List($T)) -> (ret: T) {
	if list.tail == nil do return ret
	
	data := list.tail.data

	new_tail := list.tail.prev
	new_tail.next = nil
	free(list.tail)
	list.tail = new_tail

	return data
}

// O(1)
remove :: proc(list: ^List($T), using element: ^Element(T)) -> T {
	removed_data := data

	if next != nil do next.prev = prev
	else           do list.tail = prev
	
	if prev != nil do prev.next = next
	else           do list.head = next

	free(element)

	return removed_data
}

// O(1)
iterate_next :: proc(it: ^Iterator($T)) -> (ret: ^T, ok: bool) {
	if it.current != nil {
		ret = &it.current.data
		ok = true
		
		it.current = it.current.next
	}

	return
}

// O(1)
iterate_prev :: proc(it: ^Iterator($T)) -> (ret: ^T, ok: bool) {
	if it.current != nil {
		ret = &it.current.data
		ok = true
		
		it.current = it.current.prev
	}

	return
}

// O(n)
delete_list :: proc(list: ^List($T)) {
	for element := list.head; element != nil; element = element.next {
		free(element)
	}
}
