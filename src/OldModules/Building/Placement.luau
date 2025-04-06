local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Grid = require(ReplicatedStorage.Modules.Building.Grid)

local module = {}

local function fullyContained(min1, max1, min2, max2)
	return min1 >= min2 and max1 <= max2
end

function module.CanPlace(model, position)
	local snappedPosition = Grid.SnapPositionToGrid(position)

	if Grid.grid[snappedPosition.X] and Grid.grid[snappedPosition.X][snappedPosition.Z] then return false end

	local modelPosition = model.WorldPivot.Position
	local modelSize = model:GetExtentsSize() / 2

	for _, part in workspace.PlacementAllowed:GetChildren() do
		if not part:IsA("BasePart") then continue end

		local partPosition = part.Position
		local partSize = part.Size / 2

		if
			fullyContained(modelPosition.X - modelSize.X, modelPosition.X + modelSize.X, partPosition.X - partSize.X, partPosition.X + partSize.X)
			and fullyContained(modelPosition.Z - modelSize.Z, modelPosition.Z + modelSize.Z, partPosition.Z - partSize.Z, partPosition.Z + partSize.Z)
		then
			return true
		end
	end

	return false
end

function module.PlaceModel(model, position)
	local snappedPosition = Grid.SnapPositionToGrid(position)

	local currentRotation = model:GetPivot().Rotation

	local newCFrame = CFrame.new(snappedPosition)
		* CFrame.Angles(math.rad(currentRotation.X), math.rad(currentRotation.Y), math.rad(currentRotation.Z))

	Grid.AddToGrid(snappedPosition.X, snappedPosition.Z, model)

	model:PivotTo(newCFrame)
end

function module.DeleteModel(model)
	Grid.RemoveFromGrid(model)

	model:Destroy()
end

return module
