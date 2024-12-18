local FenwickTree = {}
FenwickTree.__index = FenwickTree

-- Type exports

export type FenwickTree = typeof(setmetatable(
	{} :: {
		_inner: { number },
		_length: number,
	},
	FenwickTree
))

-- Public

--[[
    Returns the amount of elements within the tree.
]]
function FenwickTree.length(self: FenwickTree)
	return self._length
end

--[[
    Returns `true` if the tree has no elements.
]]
function FenwickTree.isEmpty(self: FenwickTree)
	return self._length == 0
end

--[[
    Returns the computed sum of the given index.
]]
function FenwickTree.prefixSum(self: FenwickTree, index: number)
	local sum = 0

	index -= 1 -- convert to zero-based

	while index > 0 do
		sum += self._inner[index + 1]
		index -= bit32.band(index, -index)
	end

	return sum
end

--[[
    Updates the given index with a delta value.
]]
function FenwickTree.update(self: FenwickTree, index: number, delta: number)
	while index < self._length do
		self._inner[index + 1] += delta
		index += bit32.band(index, -index)
	end
end

--[[
    Adds a new value to the end of the fenwick tree.
]]
function FenwickTree.push(self: FenwickTree, value: number)
	local length = self._length
	local k = bit32.band(length, -length)

	local i = 1
	while i < k do
		value += self._inner[length - i + 1]
		i = bit32.lshift(i, 1)
	end

	table.insert(self._inner, value)
	self._length += 1
end

--[[
    Pops the last element off of the tree.

    Returns `false` if the tree is empty, and `true` otherwise.
]]
function FenwickTree.pop(self: FenwickTree)
	if self:isEmpty() then
		return false
	end

	local last = self._length
	local delta = self:prefixSum(last - 1) - self:prefixSum(last)

	self:update(last, -delta)

	self._inner[last] = nil
	self._length -= 1

	return true
end

--[[
    Returns the smallest index of the fenwick tree based off of the given threshold.
]]
function FenwickTree.indexOf(self: FenwickTree, value: number)
	if value <= 0 then
		return 1 -- 1-based
	end

	local length = self._length
	local index = 0
	local t = bit32.lshift(1, 31 - bit32.countlz(length - 1))

	while t > 0 do
		local nextIndex = index + t
		if nextIndex < length and self._inner[nextIndex + 1] <= value then
			value -= self._inner[nextIndex + 1]
			index = nextIndex
		end

		t = bit32.arshift(t, 1)
	end

	return index + 1 -- 1-based
end

-- Constructors

--[[
    Creates an empty fenwick tree.
]]
local function new(): FenwickTree
	return setmetatable({
		_inner = {},
		_length = 0,
	}, FenwickTree)
end

--[[
    Creates a new fenwick tree from the provided array of values.
]]
local function fromArray(array: { number }): FenwickTree
	local n = #array + 1
	local inner = table.create(n, 0)

	for i = 1, n - 1 do
		inner[i + 1] += array[i]

		local parent = i + bit32.band(i, -i)
		if parent < n then
			inner[parent + 1] += inner[i + 1]
		end
	end

	return setmetatable({
		_inner = inner,
		_length = n,
	}, FenwickTree)
end

return {
	new = new,
	fromArray = fromArray,
}
