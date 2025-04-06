local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BuildingInterface = require(ReplicatedStorage.Modules.Building.BuildingInterface)
local PlacementManager = require(ReplicatedStorage.Modules.Building.Placement.PlacementManager)

BuildingInterface.placeSignal:Connect(PlacementManager.PlaceModel)
BuildingInterface.unplaceSignal:Connect(PlacementManager.DeleteModel)

return 0
