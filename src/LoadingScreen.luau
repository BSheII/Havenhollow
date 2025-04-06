-- I am to never come back to this or I'll genuinely quit coding, this is atrocious in such a wicked way I am unable to describe this abhorrence.

local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Assets = ReplicatedStorage.Assets

local playerGui = Players.localPlayer.PlayerGui
local loadingScreenUI = Assets.UI.LoadingScreen:Clone()
loadingScreenUI.Parent = playerGui

local currentCamera = workspace.CurrentCamera

local taskQueue = {}
local currentTaskIndex = 1
local barTweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Linear)

local module = {}

local function updateUI()
	local currentTask = taskQueue[currentTaskIndex]
	loadingScreenUI.CountLabel.Text = `{currentTaskIndex}/{#taskQueue}`
	loadingScreenUI.LoadingLabel.Text = `LOADING {currentTask.name}`

	local newSize = UDim2.fromScale(currentTaskIndex / #taskQueue, 1)
	TweenService:Create(loadingScreenUI.Bar.Inside, barTweenInfo, { Size = newSize }):Play()
end

local function processTask(_task)
	if typeof(_task.content) == "Instance" then
		ContentProvider:PreloadAsync { _task.content }
	elseif typeof(_task.content) == "function" then
		_task.content()
	end
end

local function loadTasks()
	for index, _task in taskQueue do
		currentTaskIndex = index
		updateUI()

		processTask(_task)
		task.wait(0.1)
	end

	task.wait(0.3)

	module.End()
end

function module.Boot()
	local background = loadingScreenUI:FindFirstChild("Background")

	currentCamera:GetPropertyChangedSignal("ViewportSize"):Wait()

	local viewportSize = currentCamera.ViewportSize

	local approxTileSize = 80
	local gridSizeX = math.ceil(viewportSize.X / approxTileSize)
	local gridSizeY = math.ceil(viewportSize.Y / approxTileSize)

	local tileWidth = 1 / gridSizeX
	local tileHeight = 1 / gridSizeY

	local tileContainer = loadingScreenUI.TileContainer

	for y = 0, gridSizeY - 1 do
		for x = 0, gridSizeX - 1 do
			local tile = tileContainer.TileTemplate:Clone()
			tile.Name = "Tile"
			tile.Visible = true
			tile.Size = UDim2.fromScale(tileWidth, tileHeight)
			tile.Position = UDim2.fromScale(x * tileWidth, y * tileHeight)
			tile.Parent = tileContainer
		end
	end

	background.Visible = false

	task.wait()

	updateUI()
	loadTasks()
end

function module.End()
	local fadeInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

	for _, child in loadingScreenUI:GetDescendants() do
		if child.Name == "Tile" or child.Name == "Background" then continue end
		if not child:IsA("GuiObject") then continue end

		local goal = {}

		if child:IsA("TextLabel") or child:IsA("TextButton") then
			goal.TextTransparency = 1
			goal.TextStrokeTransparency = 1
		end

		if child:IsA("ImageLabel") or child:IsA("ImageButton") then goal.ImageTransparency = 1 end
		if child:IsA("Frame") then goal.BackgroundTransparency = 1 end

		local tween = TweenService:Create(child, fadeInfo, goal)
		tween:Play()
	end

	task.wait(0.2)

	local tileContainer = loadingScreenUI.TileContainer

	local tiles = tileContainer:GetChildren()

	table.remove(tiles, table.find(tiles, tileContainer.TileTemplate))

	table.sort(tiles, function(a, b)
		local aPos = a.Position
		local bPos = b.Position

		if aPos.Y.Scale == bPos.Y.Scale then return aPos.X.Scale < bPos.X.Scale end

		return aPos.Y.Scale < bPos.Y.Scale
	end)

	for _, tile in tiles do
		if not tile:IsA("Frame") then continue end

		tile.BackgroundTransparency = 1
		task.wait(0.007)
	end

	task.wait(0.2)

	loadingScreenUI:Destroy()
end

function module.AddTask(content, name)
	table.insert(taskQueue, { content = content, name = name })
end

return module
