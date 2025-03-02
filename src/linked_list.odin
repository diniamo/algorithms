// This is just a proof-of-concept implementation - polymorphism isn't ideal.
// See core/container/intrusive/list/intrusive_list.odin for something more ergonomic.
package linked_list

import "core:fmt"

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
iterate_next :: proc(it: ^Iterator($T)) -> (ret: T, ok: bool) {
	if it.current != nil {
		ret = it.current.data
		ok = true
		
		it.current = it.current.next
	}

	return
}

// O(1)
iterate_prev :: proc(it: ^Iterator($T)) -> (ret: T, ok: bool) {
	if it.current != nil {
		ret = it.current.data
		ok = true
		
		it.current = it.current.prev
	}

	return
}

@(private)
main :: proc() {
	list := List(string){}

	fmt.printfln("is_empty before: %t", is_empty(&list))

	push_back(&list, "two")
	push_front(&list, "one")
	push_back(&list, "four")
	fmt.printfln("Popped wrong number: %s", pop_back(&list))
	push_back(&list, "five")
	fmt.printfln("Removed wrong number: %s", remove(&list, list.tail))
	push_back(&list, "three")
	push_front(&list, "zero")
	fmt.printfln("Oops! We don't need zero, popped: %s", pop_front(&list))
	
	fmt.printfln("is_empty after: %t", is_empty(&list))

	fmt.println()

	head_it := Iterator(string){ current = list.head }
	for element in iterate_next(&head_it) {
		fmt.printfln("%s", element)
	}

	fmt.println()

	tail_it := Iterator(string){ current = list.tail }
	for element in iterate_prev(&tail_it) {
		fmt.printfln("%s", element)
	}
}

