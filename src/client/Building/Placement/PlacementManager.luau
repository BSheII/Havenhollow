local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BuildingUtils = require(ReplicatedStorage.Modules.Building.BuildingUtils)
local Grid = require(ReplicatedStorage.Modules.Building.Grid)

local Assets = ReplicatedStorage.Assets

local module = {}

local function playPlaceSound()
	Assets.Sounds.Select2:Play()
end

function module.PlaceModel(model, snappedPosition)
	if not BuildingUtils.CanPlace(model, snappedPosition) then
		module.DeleteModel(model)
		return
	end

	local RotationCFrame = model:GetPivot().Rotation

	model:PivotTo(CFrame.new(snappedPosition) * RotationCFrame)
	BuildingUtils.SetModelCanCollide(model)

	playPlaceSound()

	local modelSize = model:GetExtentsSize()
	local gridTileSize = Grid.tileSize

	local halfSizeX = math.ceil((modelSize.X / 2) / gridTileSize)
	local halfSizeZ = math.ceil((modelSize.Z / 2) / gridTileSize)

	for x = -halfSizeX, halfSizeX, 1 do
		local xPosition = snappedPosition.X + (x * gridTileSize)

		for z = -halfSizeZ, halfSizeZ do
			local zPosition = snappedPosition.Z + (z * gridTileSize)

			Grid.AddToGrid(xPosition, zPosition, model)
		end
	end
end

function module.DeleteModel(model)
	Grid.RemoveFromGrid(model)

	model:Destroy()
end

return module
