local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FenwickTree = require(ReplicatedStorage.DevPackages.FenwickTree)

local function shallowEqual(left: { number }, right: { number })
	if #left ~= #right then
		return false
	end

	for i = 1, #left do
		if left[i] ~= right[i] then
			return false
		end
	end

	return true
end

local INITIAL_TEST_AMOUNT = 10
local TEST_VALUE = 23

local function createTree()
	return FenwickTree.fromArray(table.create(INITIAL_TEST_AMOUNT, TEST_VALUE))
end

return function()
	it("creates a tree from an array of values", function()
		local tree = createTree()
		local expected = { 0, 23, 46, 23, 92, 23, 46, 23, 184, 23, 46 }

		expect(shallowEqual(expected, tree._inner)).to.equal(true)
	end)

	it("pushes values after initialization", function()
		local tree = createTree()

		for _ = 1, 10 do
			tree:push(TEST_VALUE)
		end

		local expected = { 0, 23, 46, 23, 92, 23, 46, 23, 184, 23, 46, 23, 92, 23, 46, 23, 368, 23, 46, 23, 92 }

		expect(shallowEqual(expected, tree._inner)).to.equal(true)
	end)

	it("pushes values onto an empty tree", function()
		local tree = FenwickTree.new()

		tree:push(5)

		expect(shallowEqual({ 5 }, tree._inner))
	end)

	it("pops items off the tree", function()
		local tree = createTree()

		for _ = 1, 5 do
			expect(tree:pop()).to.equal(true)
		end

		local expected = { 0, 23, 46, 23, 92, 23 }

		expect(shallowEqual(expected, tree._inner)).to.equal(true)
	end)

	it("computes the prefix sum", function()
		local tree = createTree()

		for i = 1, INITIAL_TEST_AMOUNT do
			local sum = tree:prefixSum(i)
			expect(sum).to.equal((i - 1) * TEST_VALUE)
		end
	end)

	it("adds new values", function()
		local tree = createTree()

		tree:update(1, TEST_VALUE) -- increments index *2* by 23

		local cases = {
			{ 1, 0 },
			{ 2, 46 },
			{ 3, 69 },
			{ 4, 92 },
			{ 5, 115 },
			{ 6, 138 },
			{ 7, 161 },
			{ 8, 184 },
			{ 9, 207 },
			{ 10, 230 },
		}

		for _, case in cases do
			local sum = tree:prefixSum(case[1])
			expect(sum).to.equal(case[2])
		end
	end)

	it("finds the index of computed sums", function()
		local tree = createTree()

		for i = 1, INITIAL_TEST_AMOUNT do
			local sum = tree:prefixSum(i)
			local index = tree:indexOf(sum)

			expect(index).to.equal(i)
		end
	end)
end
