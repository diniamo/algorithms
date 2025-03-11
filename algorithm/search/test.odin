package search

import "core:testing"
import "../../data_structure/linked_list"

@(test)
binary_search_test :: proc(t: ^testing.T) {
	sorted_array := [?]int{-9, -7, -5, -3, -1, 0, 1, 3, 5, 7, 9}
	
	testing.expect_value(t, binary_search(sorted_array[:], -3), 3)
	testing.expect_value(t, binary_search(sorted_array[:], -2), -1)
	testing.expect_value(t, binary_search(sorted_array[:], 3), 7)
	testing.expect_value(t, binary_search(sorted_array[:], 2), -1)
}

// Test case taken from Grokking Algorithms
@(test)
breadth_first_search_test :: proc(t: ^testing.T) {
	you := new(linked_list.List(string))
	linked_list.push_back(you, "Bob")
	linked_list.push_back(you, "Claire")
	linked_list.push_back(you, "Alice")

	bob := new(linked_list.List(string))
	linked_list.push_back(bob, "Anuj")
	linked_list.push_back(bob, "Peggy")

	alice := new(linked_list.List(string))
	linked_list.push_back(alice, "Peggy")

	claire := new(linked_list.List(string))
	linked_list.push_back(claire, "Thom")
	linked_list.push_back(claire, "Jonny")

	graph := map[string]^linked_list.List(string){
		"You" = you,
		"Bob" = bob,
		"Alice" = alice,
		"Claire" = claire,
		"Anuj" = new(linked_list.List(string)),
		"Peggy" = new(linked_list.List(string)),
		"Thom" = new(linked_list.List(string)),
		"Jonny" = new(linked_list.List(string))
	}

	defer {
		for _, v in graph {
			linked_list.delete_list(v)
			free(v)
		}
		delete(graph)
	}

	testing.expect_value(
		t,
		breadth_first_search(graph, "You", "Peggy"),
		2
	)
}
