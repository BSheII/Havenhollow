local Animations = require(script.Parent.Animations)
local AnimationsManager = require(script.Parent.AnimationsManager)
return {
	[Enum.HumanoidStateType.Running] = function(character)
		local humanoid = character.Humanoid

		local play, stop = {}, {}

		table.insert(play, "idle")

		table.insert(stop, "fall")

		if humanoid.MoveDirection.Magnitude > 0 then
			table.insert(play, "walk")
		else
			table.insert(stop, "walk")
		end

		return play, stop
	end,
	[Enum.HumanoidStateType.Jumping] = function()
		local play, stop = {}, {}

		table.insert(play, "jump")
		table.insert(stop, "walk")

		return play, stop
	end,
	[Enum.HumanoidStateType.Freefall] = function(character)
		local animator = character.Humanoid.Animator
		local jumpAnimation = AnimationsManager.GetTrack(animator, Animations.player.jump)

		local play, stop = {}, {}

		if not jumpAnimation.IsPlaying then table.insert(play, "fall") end

		return play, stop
	end,
}
