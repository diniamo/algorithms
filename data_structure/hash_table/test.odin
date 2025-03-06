package hash_table

import "core:testing"

@(test)
hash_table_test :: proc(t: ^testing.T) {
	table := make_table(int, string, 2)
	defer delete_table(&table)

	testing.expect(t, is_empty(&table))

	insert(&table, -1, "negative one")
	testing.expect_value(t, len(table.data), 2)
	insert(&table, 0, "zero")
	testing.expect_value(t, len(table.data), 4)
	insert(&table, 1, "one")

	testing.expect(t, !is_empty(&table))

	value, ok := get(&table, -1)
	testing.expect_value(t, value, "negative one")
	testing.expect(t, ok)

	value, ok = get(&table, 0)
	testing.expect_value(t, value, "zero")
	testing.expect(t, ok)

	value, ok = get(&table, 1)
	testing.expect_value(t, value, "one")
	testing.expect(t, ok)

	insert(&table, 2, "two")
	value, ok = remove(&table, 2)
	testing.expect_value(t, value, "two")
	testing.expect(t, ok)

	value, ok = get(&table, 2)
	testing.expect(t, !ok)
}
