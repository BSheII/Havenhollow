local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- local Assets = ReplicatedStorage.Assets

local Grid = require(ReplicatedStorage.Modules.Building.Grid)
local Placement = require(ReplicatedStorage.Modules.Building.Placement)

local localPlayer = Players.LocalPlayer

local module = {}

local steppedConnection

function module.VisualizeModel(model)
	if steppedConnection then
		warn("RenderStepped connection still in progress")
		return
	end

	model = model:Clone()
	model.Parent = workspace

	local highlight = Instance.new("Highlight")
	highlight.Parent = model

	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = { localPlayer.Character, model }
	rayParams.RespectCanCollide = false
	rayParams.FilterType = Enum.RaycastFilterType.Exclude

	steppedConnection = RunService.RenderStepped:Connect(function()
		local mouse = UserInputService:GetMouseLocation()
		local camera = workspace.CurrentCamera
		local mouseRay = camera:ScreenPointToRay(mouse.X, mouse.Y)

		local raycastResult = workspace:Raycast(mouseRay.Origin, mouseRay.Direction * 150, rayParams)

		if not raycastResult then return end

		local groundRaycast = workspace:Raycast(raycastResult.Position, Vector3.yAxis * -20, rayParams)

		if not groundRaycast and not raycastResult then return end

		local usedRaycast = groundRaycast or raycastResult

		local snappedPosition = Grid.SnapPositionToGrid(usedRaycast.Position)
		local RotationCFrame = model:GetPivot().Rotation

		model:PivotTo(CFrame.new(snappedPosition) * RotationCFrame)

		local canPlace = Placement.CanPlace(model, snappedPosition)

		highlight.FillColor = if not canPlace then Color3.new(1, 0, 0) else Color3.new(0, 1, 0)
	end)

	return model
end

function module.UnvisualizeModel(model)
	steppedConnection:Disconnect()

	model:Destroy()
end

return module
