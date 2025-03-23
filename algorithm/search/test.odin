package search

import "core:testing"
import "../../data_structure/linked_list"
import "../../data_structure/rooted_tree"

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

@(test)
depth_first_search_test :: proc(t: ^testing.T) {
	//   1
	//  / \
	// 2   3
	//    / \
	//   4   5

	four := rooted_tree.Node(int){ data = 4 }
	defer linked_list.delete_list(&four.children)
	
	five := rooted_tree.Node(int){ data = 5 }
	defer linked_list.delete_list(&five.children)

	three := rooted_tree.Node(int){ data = 3 }
	linked_list.push_back(&three.children, &four)
	linked_list.push_back(&three.children, &five)
	defer linked_list.delete_list(&three.children)

	two := rooted_tree.Node(int){ data = 2 }
	defer linked_list.delete_list(&two.children)

	root := rooted_tree.Node(int){ data = 1 }
	linked_list.push_back(&root.children, &two)
	linked_list.push_back(&root.children, &three)
	defer linked_list.delete_list(&root.children)

	leaves: linked_list.List(int)
	defer linked_list.delete_list(&leaves)

	depth_first_search(
		&root,
		&leaves,
		proc(node: ^rooted_tree.Node(int), state: rawptr) {
			leaves := cast(^linked_list.List(int))state

			if linked_list.is_empty(&node.children) {
				linked_list.push_back(leaves, node.data)
			}
		}
	)

	it := linked_list.Iterator(int){ current = leaves.head }
	
	leaf, ok := linked_list.iterate_next(&it)
	testing.expect(t, ok)
	testing.expect_value(t, leaf^, 2)

	leaf, ok = linked_list.iterate_next(&it)
	testing.expect(t, ok)
	testing.expect_value(t, leaf^, 4)

	leaf, ok = linked_list.iterate_next(&it)
	testing.expect(t, ok)
	testing.expect_value(t, leaf^, 5)

	leaf, ok = linked_list.iterate_next(&it)
	testing.expect(t, !ok)
}

@(test)
dijkstra_search_test :: proc(t: ^testing.T) {
	graph := map[string]map[string]uint{
		"Start" = map[string]uint{
			"A" = 6,
			"B" = 2
		},
		"A" = map[string]uint{
			"Finish" = 1
		},
		"B" = map[string]uint{
			"A" = 3,
			"Finish" = 5
		},
		"Finish" = map[string]uint{}
	}
	defer {
		for _, &v in graph do delete(v)
		delete(graph)
	}

	steps, cost := dijkstra_search(graph, "Start", "Finish")
	testing.expect_value(t, steps, 3)
	testing.expect_value(t, cost, 6)
}
