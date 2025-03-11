// This is a proof-of-concept implementation, Odin has queues in its standard libary.
package queue

Item :: struct($T: typeid) {
	data: T,
	behind: ^Item(T)
}

Queue :: struct($T: typeid) {
	first: ^Item(T),
	last: ^Item(T)
}

is_empty :: proc(queue: ^Queue($T)) -> bool {
	return queue.first == nil
}

enqueue :: proc(queue: ^Queue($T), data: T) {
	item := new(Item(T))
	item.data = data
	
	if is_empty(queue) do queue.first = item
	else               do queue.last.behind = item
	
	queue.last = item
}

dequeue :: proc(queue: ^Queue($T)) -> (ret: T, ok: bool) {
	if is_empty(queue) do return ret, false

	item := queue.first
	ret = item.data
	queue.first = item.behind
	free(item)

	return ret, true
}

delete_queue :: proc(queue: ^Queue($T)) {
	for item := queue.first; item != nil; item = item.behind {
		free(item)
	}
}
