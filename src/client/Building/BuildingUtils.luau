local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Grid = require(ReplicatedStorage.Modules.Building.Grid)

local Assets = ReplicatedStorage.Assets

local module = {}

local function fullyContained(min1, max1, min2, max2)
	return min1 >= min2 and max1 <= max2
end

local function isWithinBounds(innerPos, innerSize, containerPos, containerSize)
	local innerMin = innerPos - innerSize
	local innerMax = innerPos + innerSize

	local containerMin = containerPos - containerSize
	local containerMax = containerPos + containerSize

	return fullyContained(innerMin.X, innerMax.X, containerMin.X, containerMax.X)
		and fullyContained(innerMin.Z, innerMax.Z, containerMin.Z, containerMax.Z)
end

function module.CanPlace(model, position)
	local snappedPosition = Grid.SnapPositionToGrid(position)

	if Grid.grid[snappedPosition.X] and Grid.grid[snappedPosition.X][snappedPosition.Z] then return false end

	local modelPosition = model.WorldPivot.Position
	local modelSize = model:GetExtentsSize() / 2

	for _, part in workspace.Areas:GetChildren() do
		if not part:IsA("BasePart") or not part:HasTag("AllowPlacement") then continue end

		local partPosition = part.Position
		local partSize = part.Size / 2

		if isWithinBounds(modelPosition, modelSize, partPosition, partSize) then return true end
	end

	return false
end

function module.CreateGridOutline()
	local model = Instance.new("Model")
	model.Name = "GridOutlineModel"

	local tileSize = Grid.tileSize

	for i = 0, 3 do
		local line = Assets.Parts.GridLineTemplate:Clone()
		line.Anchored = true
		line.CanCollide = false
		local isHorizontal = i % 2 == 0
		local offsetMultiplier = (i < 2 and -1 or 1) * tileSize

		local position = if isHorizontal then Vector3.new(0, 0, offsetMultiplier) else Vector3.new(offsetMultiplier, 0, 0)
		local rotation = if isHorizontal then Vector3.new(0, 0, 0) else Vector3.new(0, 90, 0)

		line.CFrame = CFrame.new(position) * CFrame.Angles(math.rad(rotation.X), math.rad(rotation.Y), math.rad(rotation.Z))

		line.Parent = model
	end

	return model
end

function module.SetModelCanCollide(model, bool)
	for _, part in model:GetDescendants() do
		if not part:IsA("BasePart") then continue end

		if bool then
			part:SetAttribute("PreviousCanCollide", part.CanCollide)
			part.CanCollide = bool
		else
			part.CanCollide = part:GetAttribute("PreviousCanCollide") or part.CanCollide
		end
	end
end

return module
