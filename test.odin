package test

import "core:fmt"
import pq "core:container/priority_queue"

main :: proc() {
	q := pq.Priority_Queue(int){}

	pq.init(
		&q,
		proc(a, b: int) -> bool { return a < b },
		pq.default_swap_proc(int)
	)

	pq.push(&q, 2)
	pq.push(&q, 1)
	pq.push(&q, 3)

	for v in pq.pop_safe(&q) {
		fmt.println(v)
	}
}
