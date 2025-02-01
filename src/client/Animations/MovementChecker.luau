local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Animations = require(script.Parent.Animations)
local AnimationsManager = require(ReplicatedStorage.Modules.Animations.AnimationsManager)
local HumanoidStatesFunctions = require(ReplicatedStorage.Modules.Animations.HumanoidStatesFunctions)

local localPlayer = Players.LocalPlayer

local steppedConnection

local function playAnimation(animation)
	if animation.IsPlaying then return end

	animation:Play(0.1)
end

local function updateState(character, state)
	local animator = character.Humanoid.Animator
	local stateFunction = HumanoidStatesFunctions[state]

	if not stateFunction then return end

	local play, stop = stateFunction(character)

	for _, animationName in play do
		playAnimation(AnimationsManager.GetTrack(animator, Animations.player[animationName]))
	end

	for _, animationName in stop do
		local animation = AnimationsManager.GetTrack(animator, Animations.player[animationName])
		animation:Stop(0.2)
	end
end

local function setupAnimations(character)
	local humanoid = character.Humanoid

	if steppedConnection then steppedConnection:Disconnect() end

	character.Animate.Enabled = false

	updateState(character, Enum.HumanoidStateType.Running)

	steppedConnection = RunService.RenderStepped:Connect(function()
		updateState(character, humanoid:GetState())
	end)
end

if localPlayer.Character then setupAnimations(localPlayer.Character) end

localPlayer.CharacterAdded:Connect(setupAnimations)

return 0
