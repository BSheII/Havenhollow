local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GlobalConfig = require(ReplicatedStorage.Shared.GlobalConfig)
local Schedules = require(ReplicatedStorage.Shared.Schedules)

local debugTransparency = 0.985

function devisualizeAreas()
	for _, part in workspace.Areas:GetChildren() do
		if not part:IsA("BasePart") then continue end

		part.Transparency = if GlobalConfig.DEBUG == true then debugTransparency else 1
	end
end

return Schedules["Boot"].job(devisualizeAreas)
