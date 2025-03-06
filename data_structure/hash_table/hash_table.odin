// This is just a proof-of-concept implementation and isn't even fully functional.
// Odin and every other programming language has a good, built-in hash table implementation that should be used instead.
package hash_table

import "../linked_list"
import "base:intrinsics"

Entry :: struct($K: typeid, $V: typeid) {
	key: K,
	value: V
}

Table :: struct($K: typeid, $V: typeid) {
	data: []linked_list.List(Entry(K, V)),
	count: uint
}

// O(1)
@(private)
hash :: proc(size: int, key: $K) -> int where intrinsics.type_is_integer(K) {
	if key == 0 do return 0
	return cast(K)size % key
}

// O(n)
@(private)
delete_data :: proc(data: []linked_list.List($T)) {
	for i in 0..<len(data) {
		linked_list.delete_list(&data[i])
	}

	delete(data)
}

// O(1)
// 25 is an arbitrary value, not sure what the default array size should be.
make_table :: proc($K: typeid, $V: typeid, size := 25) -> (ret: Table(K, V)) {
	ret.data = make([]linked_list.List(Entry(K, V)), size)
	return
}

// O(1)
is_empty :: proc(table: ^Table($K, $V)) -> bool {
	return table.count == 0
}

// Average/best case: O(1)
// Worst case: O(n)
insert :: proc(table: ^Table($K, $V), key: K, value: V) {
	new_count := table.count + 1
	size := len(table.data)
	new_load_factor := f32(new_count) / f32(size)
	// 0.7 is another arbitrary value. Usually somewhere between 0.7-0.75 is recommended.
	if new_load_factor > 0.7 {
		// Doubling the previous size is also arbitrary, but recommended.
		size *= 2
		new_data := make([]linked_list.List(Entry(K, V)), size)
		
		for list in table.data {
			it := linked_list.Iterator(Entry(K, V)){ list.head }
			for entry in linked_list.iterate_next(&it) {
				list_index := hash(size, entry.key)
				linked_list.push_back(&new_data[list_index], entry^)
			}
		}

		delete_data(table.data)
		table.data = new_data
	}

	// Set before inserting to simplify code
	table.count = new_count
	
	list_index := hash(size, key)
	list := &table.data[list_index]
	
	it := linked_list.Iterator(Entry(K, V)){ current = list.head }
	for entry in linked_list.iterate_next(&it) {
		if entry.key == key {
			entry.value = value
			return
		}
	}
	
	entry := Entry(K, V){ key, value }
	linked_list.push_back(list, entry)
}

// Average/best case: O(1)
// Worst case: O(n)
get :: proc(table: ^Table($K, $V), key: K) -> (ret: V, ok: bool) {
	list_index := hash(len(table.data), key)
	list := table.data[list_index]
	it := linked_list.Iterator(Entry(K, V)){ list.head }

	for entry in linked_list.iterate_next(&it) {
		if entry.key == key {
			return entry.value, true
		}
	}

	return ret, false
}

// Average/best case: O(1)
// Worst case: O(n)
remove :: proc(table: ^Table($K, $V), key: K) -> (ret: V, ok: bool) {
	list_index := hash(len(table.data), key)
	list := &table.data[list_index]

	for element := list.head; element != nil; element = element.next {
		if element.data.key == key {
			table.count -= 1
			return linked_list.remove(list, element).value, true
		}
	}

	return
}

// O(n)
delete_table :: proc(table: ^Table($K, $V)) {
	delete_data(table.data)
}
