package queue

import "core:testing"

@(test)
queue_test :: proc(t: ^testing.T) {
	queue := Queue(int){}
	defer delete_queue(&queue)


	testing.expect(t, is_empty(&queue))

	enqueue(&queue, 1)
	enqueue(&queue, 2)
	enqueue(&queue, 3)

	testing.expect(t, !is_empty(&queue))

	item, ok := dequeue(&queue)
	testing.expect(t, ok)
	testing.expect_value(t, item, 1)
	
	item, ok = dequeue(&queue)
	testing.expect(t, ok)
	testing.expect_value(t, item, 2)

	item, ok = dequeue(&queue)
	testing.expect(t, ok)
	testing.expect_value(t, item, 3)

	item, ok = dequeue(&queue)
	testing.expect(t, !ok)

	testing.expect(t, is_empty(&queue))
}
