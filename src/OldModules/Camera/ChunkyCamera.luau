--[[local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local camera = workspace.CurrentCamera
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local head = character:WaitForChild("Head")

local mult = 180 / math.pi
local clamp = math.clamp

local targetX, targetY = 0, 0
local sensitivity = 0.3

-- Clunky Zoom
local minZoom = 10
local maxZoom = 50
local zoomSpeed = 5
local currentZoom = 30

UserInputService.MouseDeltaSensitivity = 1
camera.CameraType = Enum.CameraType.Custom

-- Listening for scroll wheel input using InputChanged
UserInputService.InputChanged:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.UserInputType == Enum.UserInputType.MouseWheel then
		-- Adjust the zoom based on scroll wheel delta
		currentZoom = clamp(currentZoom - input.Position.Y * zoomSpeed, minZoom, maxZoom)
	end
end)

RunService:BindToRenderStep("ClassicCam", Enum.RenderPriority.Camera.Value - 1, function()
	-- Camera rotation (choppy response)
	local mouseDelta = UserInputService:GetMouseDelta() * sensitivity
	targetX += mouseDelta.X
	targetY = clamp(targetY - mouseDelta.Y, -80, 80) -- More angles, not just -45 to 45

	-- Apply clunky angular rotation (subtle)
	local camRot = CFrame.fromOrientation(targetY / mult, targetX / mult, 0)

	-- Head sway/bob effect based on the head's Y position
	local headOffset = head.Position - character.PrimaryPart.Position
	local swayOffset = Vector3.new(0, math.sin(tick() * 0.5) * headOffset.Y * 0.15, 0) -- Sway using sin for choppiness

	-- Combine rotation with camera position (apply sway)
	local camPosition = head.Position + swayOffset

	-- Create the final CFrame with position, rotation, and zoom applied
	camera.CFrame = CFrame.new(camPosition) * camRot * CFrame.new(0, 0, -currentZoom)
end)
--]]

return 0
