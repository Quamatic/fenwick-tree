interface FenwickTree {
	/**
	 * Returns the computed prefix sum up until the desired index.
	 *
	 * @param index The desired index
	 */
	prefixSum(index: number): number;
	/**
	 * Updates the desired index with a delta value. Negative values will subtract, while positive values will add.
	 *
	 * @param index The desired index
	 * @param delta The value to change by
	 */
	update(index: number, delta: number): void;
	/**
	 * Pushes a new value to the tree.
	 *
	 * @param value The desired value
	 */
	push(value: number): void;
	/**
	 * Pops the last item from the tree.
	 *
	 * @returns `false` if the tree was empty, and `true` otherwise
	 */
	pop(): boolean;
	/**
	 * Given a sum, finds the index in which it would be "contained" within the original array.
	 *
	 * @param sum The sum to find the index for
	 * @returns The calculated index
	 */
	indexOf(sum: number): number;
	/**
	 * Returns the length of the tree.
	 */
	length(): number;
	/**
	 * Returns `true` if the tree is empty (no elements).
	 */
	isEmpty(): boolean;
}

interface FenwickTreeConstructor {
	new (): FenwickTree;
	/**
	 * Creates a new fenwick tree from the given array of values.
	 *
	 * Note that because the tree is 1-based, an extra value is stored causing
	 * each value to be offset by one index, causing the first index to always be a value of `0`.
	 */
	fromArray(array: number[]): FenwickTree;
}

declare const FenwickTree: FenwickTreeConstructor;

export = FenwickTree;
