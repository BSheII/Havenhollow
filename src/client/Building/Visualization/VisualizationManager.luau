local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local BuildingInterface = require(ReplicatedStorage.Modules.Building.BuildingInterface)
local BuildingUtils = require(ReplicatedStorage.Modules.Building.BuildingUtils)
local Grid = require(ReplicatedStorage.Modules.Building.Grid)

local localPlayer = Players.LocalPlayer

local module = {}

local steppedConnection
local gridOutlineModel

function module.VisualizeModel(model)
	if steppedConnection then
		warn("RenderStepped connection still in progress")
		return
	end

	local newModel = model:Clone()
	newModel.Parent = workspace

	BuildingUtils.SetModelCanCollide(newModel, false)

	local highlight = Instance.new("Highlight")
	highlight.Name = "VisualizationHighlight"
	highlight.Parent = newModel

	gridOutlineModel = BuildingUtils.CreateGridOutline()
	gridOutlineModel.Parent = newModel

	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = { localPlayer.Character, newModel }
	rayParams.RespectCanCollide = false
	rayParams.FilterType = Enum.RaycastFilterType.Exclude

	steppedConnection = RunService.RenderStepped:Connect(function(deltaTime)
		local mouse = UserInputService:GetMouseLocation()
		local camera = workspace.CurrentCamera
		local mouseRay = camera:ScreenPointToRay(mouse.X, mouse.Y)

		local raycastResult = workspace:Raycast(mouseRay.Origin, mouseRay.Direction * 150, rayParams)
		raycastResult = if raycastResult then raycastResult.Position else mouseRay.Origin + (mouseRay.Direction * 150)

		local usedRaycast = workspace:Raycast(raycastResult + Vector3.new(0, 0.1, 0), Vector3.yAxis * -40, rayParams)

		if not usedRaycast then return end

		local modelPivot = newModel:GetPivot()

		local snappedPosition = Grid.SnapPositionToGrid(usedRaycast.Position)
		local RotationCFrame = modelPivot.Rotation

		local targetCFrame = CFrame.new(snappedPosition) * RotationCFrame

		newModel:PivotTo(modelPivot:Lerp(targetCFrame, 1 - math.exp(-deltaTime * 10)))
		if gridOutlineModel then gridOutlineModel:PivotTo(CFrame.new(snappedPosition)) end

		highlight.FillColor = if not BuildingUtils.CanPlace(newModel, snappedPosition) then Color3.new(1, 0, 0) else Color3.new(0, 1, 0)
		BuildingInterface.currentFurniturePosition = snappedPosition
	end)

	BuildingInterface.holdingFurniture = newModel
end

function module.DevisualizeModel(model)
	steppedConnection:Disconnect()
	steppedConnection = nil

	model.VisualizationHighlight:Destroy()

	if gridOutlineModel then gridOutlineModel:Destroy() end
end

return module
