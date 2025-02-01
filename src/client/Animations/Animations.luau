local ReplicatedStorage = game:GetService("ReplicatedStorage")

local animationAssets = ReplicatedStorage.Assets.Animations

local placeholderAnimation = Instance.new("Animation")
placeholderAnimation.AnimationId = "rbxassetid://0"

local function AnimationExists(path)
	local animation = animationAssets

	for _, nextPath in path do
		if not animation:FindFirstChild(nextPath) then return false end

		animation = animation[nextPath]
	end

	return animation
end

local function GetAnimation(...)
	local path = { ... }
	local animation = AnimationExists(path)

	if animation then return animation end

	warn(`Couldn't get animation {path[#path]} - Not found`)
	return placeholderAnimation
end

return {
	player = {
		walk = GetAnimation("Player", "Walk"),
		idle = GetAnimation("Player", "Idle"),
		fall = GetAnimation("Player", "Fall"),
		jump = GetAnimation("Player", "Jump"),
	},
}
