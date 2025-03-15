package search

import "base:intrinsics"

// The map represents a weighted graph
djikstra_search :: proc(graph: map[$T]map[T]uint, start: T, finish: T) -> (steps: int, cost: int) where intrinsics.type_is_valid_map_key(T) {
	Djikstra_Node :: struct {
		cost: uint,
		parent: T,
		done: bool
	}

	node_data := make(map[T]Djikstra_Node, len(graph))
	defer delete(node_data)
	for node in graph do node_data[node] = {
		cost = 0 if node == start else max(uint),
		done = true if node == finish else false
	}

	for {
		node: T
		data: ^Djikstra_Node
		min_cost := max(uint)
		for n in node_data {
			d := &node_data[n]

			if !d.done && d.cost < min_cost {
				node = n
				data = d
				min_cost = d.cost
			}
		}
		if data == nil do break

		weights := &graph[node]
		for n, w in weights {
			nd := &node_data[n]
			cost := data.cost + w

			if cost < nd.cost {
				nd.cost = cost
				nd.parent = node
			}
		}

		data.done = true
	}

	data, ok := node_data[finish]
	cost = int(data.cost)
	for {
		steps += 1
		
		if data.parent == start {
			return
		} else {
			data, ok = node_data[data.parent]
			if !ok do return -1, -1
		}
	}
}
