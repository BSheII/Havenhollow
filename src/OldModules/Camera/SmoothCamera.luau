--[[local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local camera = workspace.Camera

local mult = 180 / math.pi
local clamp = math.clamp

local currentVector = Vector2.zero
local targetX, targetY = 0, 0

local speed = 12
local sensitivity = 0.15

UserInputService.MouseDeltaSensitivity = 0.01
camera.CameraType = Enum.CameraType.Custom

RunService:BindToRenderStep("SmoothCam", Enum.RenderPriority.Camera.Value - 1, function(dt)
	local mouseDelta = UserInputService:GetMouseDelta() * sensitivity * 100

	targetX += mouseDelta.X
	targetY = clamp(targetY - mouseDelta.Y, -90, 90)

	currentVector = currentVector:Lerp(Vector2.new(targetX, targetY), 1 - math.exp(-speed * dt))

	camera.CFrame = CFrame.fromOrientation(currentVector.Y / mult, currentVector.X / mult, 0)
end)--]]

return 0
