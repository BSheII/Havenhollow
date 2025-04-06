local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BuildingInterface = require(ReplicatedStorage.Modules.Building.BuildingInterface)
local InputsFunctions = require(ReplicatedStorage.Modules.Building.Inputs.InputsFunctions)

BuildingInterface.hookInputsSignal:Connect(InputsFunctions.HookInputs)
BuildingInterface.unhookInputsSignal:Connect(InputsFunctions.UnhookInputs)

return 0
