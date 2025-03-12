package search

import "../../data_structure/rooted_tree"
import "../../data_structure/linked_list"

depth_first_search :: proc(node: ^rooted_tree.Node($T), state: rawptr, callback: proc(node: ^rooted_tree.Node(T), state: rawptr)) {
	callback(node, state)

	it := linked_list.Iterator(^rooted_tree.Node(T)){ current = node.children.head }
	for child in linked_list.iterate_next(&it) {
		depth_first_search(child^, state, callback)
	}
}
