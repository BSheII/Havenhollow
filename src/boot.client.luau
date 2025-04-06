local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LoadingScreen = require(ReplicatedStorage.LoadingScreen)
local Sandwich = require(ReplicatedStorage.Packages.Sandwich)
local Schedules = require(ReplicatedStorage.Shared.Schedules)

LoadingScreen.AddTask(workspace, "MAP")

LoadingScreen.AddTask(function()
	Schedules["Boot"] = Sandwich.schedule()

	for _, module in ReplicatedStorage.Modules:GetDescendants() do
		if not module:IsA("ModuleScript") then continue end

		require(module)
	end
end, "MODULES")

LoadingScreen.AddTask(ReplicatedStorage.Assets, "ASSETS")

LoadingScreen.AddTask(function()
	Schedules["Boot"].start()
end, "BOOT SEQUENCE")

task.wait()

LoadingScreen.Boot()
