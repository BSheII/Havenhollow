local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Signal = require(ReplicatedStorage.Packages.Signal)

local module = {
	visualizeSignal = Signal.new(),
	devisualizeSignal = Signal.new(),

	hookInputsSignal = Signal.new(),
	unhookInputsSignal = Signal.new(),

	placeSignal = Signal.new(),
	unplaceSignal = Signal.new(),

	holdingFurniture = nil,
	currentFurniturePosition = nil,
}

function module.StartPlacing(model)
	module.visualizeSignal:Fire(model)
	module.hookInputsSignal:Fire()
end

function module.StopPlacing()
	module.devisualizeSignal:Fire(module.holdingFurniture)
	module.unhookInputsSignal:Fire()
end

return module
