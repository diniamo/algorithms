package rooted_tree

import "../linked_list"

Node :: struct($T: typeid) {
	data: T,
	children: linked_list.List(^Node(T))
}
