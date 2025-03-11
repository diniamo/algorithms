package search

import "core:fmt"
import "base:intrinsics"
import "../../data_structure/linked_list"
import "../../data_structure/queue"

// The map represents a directed graph
breadth_first_search :: proc(graph: map[$T]^linked_list.List(T), start: T, finish: T) -> int
	where intrinsics.type_is_comparable(T),
		intrinsics.type_is_valid_map_key(T)
{
	check_queue := queue.Queue(T){}
	defer queue.delete_queue(&check_queue)
	queue.enqueue(&check_queue, start)

	// These track how many nodes we have left from the current depth,
	// any how many we will have in the next respectively
	current_left := 1
	next_count := 0

	step_count := 0

	for {
		node, ok := queue.dequeue(&check_queue)
		if !ok do break

		if node == finish do return step_count

		it := linked_list.Iterator(T){ current = graph[node].head }
		for neighbour in linked_list.iterate_next(&it) {
			queue.enqueue(&check_queue, neighbour^)
			next_count += 1
		}

		current_left -= 1
		if current_left == 0 {
			current_left = next_count
			next_count = 0
			step_count += 1
		}
	}

	return -1
}
