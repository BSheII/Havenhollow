local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BuildingInterface = require(ReplicatedStorage.Modules.Building.BuildingInterface)
local InputsManager = require(ReplicatedStorage.Modules.Inputs.InputsManager)

local module = {}

function module.HookInputs()
	InputsManager.AddInput("PlaceModel", {
		Keys = { Enum.UserInputType.MouseButton1 },
		OnBegan = function()
			BuildingInterface.StopPlacing()
			BuildingInterface.placeSignal:Fire(BuildingInterface.holdingFurniture, BuildingInterface.currentFurniturePosition)
		end,
	})
end

function module.UnhookInputs()
	InputsManager.RemoveInput("PlaceModel")
end

return module
