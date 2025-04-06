local module = {}
module.grid = {}
module.tileSize = 2
module.origin = Vector3.new(0, 0, 0)

local function GetGridCellsFromSize(size)
	local cellsX = math.ceil(size.X / module.tileSize)
	local cellsZ = math.ceil(size.Z / module.tileSize)

	return Vector3.new(cellsX, size.Y, cellsZ)
end

function module.SnapPositionToGrid(position)
	local snappedX = math.floor((position.X - module.origin.X) / module.tileSize) * module.tileSize + module.origin.X
	local snappedZ = math.floor((position.Z - module.origin.Z) / module.tileSize) * module.tileSize + module.origin.Z

	return Vector3.new(snappedX, position.Y, snappedZ)
end

function module.AddToGrid(positionX, positionZ, model)
	local modelSize = model:GetExtentsSize()
	local sizeVector = GetGridCellsFromSize(modelSize)

	for x = positionX - (sizeVector.X / 2), positionX + (sizeVector.X / 2) do
		if not module.grid[x] then module.grid[x] = {} end

		for z = positionZ - (sizeVector.Z / 2), positionZ + (sizeVector.Z / 2) do
			module.grid[x][z] = model
		end
	end
end

function module.RemoveFromGrid(model)
	for _, z in module.grid do
		for currentZ, currentModel in z do
			if model ~= currentModel then continue end

			z[currentZ] = nil
		end
	end
end

return module
