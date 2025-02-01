local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Animations = require(ReplicatedStorage.Modules.Animations.Animations)
local AnimationsManager = require(ReplicatedStorage.Modules.Animations.AnimationsManager)

local localPlayer = Players.LocalPlayer

local steppedConnection

local function playAnimation(animation)
	if animation.IsPlaying then return end

	print(animation.Name)

	animation:Play()
end

local function setupAnimations(character)
	local humanoid = character.Humanoid
	local animator = humanoid.Animator
	local rootPart = character.HumanoidRootPart

	if steppedConnection then steppedConnection:Disconnect() end

	character.Animate.Enabled = false

	steppedConnection = RunService.RenderStepped:Connect(function()
		if not rootPart then return end

		local walkAnimation = AnimationsManager.GetTrack(animator, Animations.player.walk)
		local idleAnimation = AnimationsManager.GetTrack(animator, Animations.player.idle)
		local fallAnimation = AnimationsManager.GetTrack(animator, Animations.player.fall)
		local jumpAnimation = AnimationsManager.GetTrack(animator, Animations.player.jump)

		local dirMagnitude = humanoid.MoveDirection.Magnitude
		local yVelocity = math.round(rootPart.Velocity.Y)

		playAnimation(idleAnimation)

		if dirMagnitude > 0 and humanoid:GetState() == Enum.HumanoidStateType.Running then
			playAnimation(walkAnimation)
		else
			walkAnimation:Stop()
		end

		if yVelocity ~= 0 then
			if humanoid.Jump then
				playAnimation(jumpAnimation)
			else
				playAnimation(fallAnimation)
			end
		else
			fallAnimation:Stop()
		end
	end)
end

if localPlayer.Character then setupAnimations(localPlayer.Character) end

localPlayer.CharacterAdded:Connect(setupAnimations)

return 0
