local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BuildingInterface = require(ReplicatedStorage.Modules.Building.BuildingInterface)
local VisualizationManager = require(ReplicatedStorage.Modules.Building.Visualization.VisualizationManager)

BuildingInterface.visualizeSignal:Connect(VisualizationManager.VisualizeModel)
BuildingInterface.devisualizeSignal:Connect(VisualizationManager.DevisualizeModel)

return 0
