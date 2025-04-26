-- Services --

local RS = game:GetService("ReplicatedStorage")
local DS = game:GetService("DataStoreService")
local Players = game:GetService("Players")


-- Variables --

local debugger = require(RS:WaitForChild("Modules"):WaitForChild("Debugger"))
local manager = require(script.Parent:FindFirstChild("Manager"))

local dataStore: string = script.Parent:FindFirstChild("Store").Value :: string
local store: DataStore = DS:GetDataStore(dataStore) :: DataStore

local clicksQueue: SharedTable = {} :: SharedTable
local saveInterval: number = 5 :: number
local saveThreshold: number = 10 :: number

local event: RemoteEvent = RS:WaitForChild("Remotes"):WaitForChild("Event") :: RemoteEvent


-- Functions

local function saveClicks(UserID: number, clicks: number)
	local success, issue = pcall(function()
		store:SetAsync(UserID, clicks)
	end)

	if not success then
		debugger.issue(`Failed to save clicks for User ID and click-stack: {UserID}, {clicks} - ({issue})`)
	end
end

local function loadClicks(UserID: number)
	local success, clicks = pcall(function()
		return store:GetAsync(UserID)
	end)

	if success and clicks then
		return clicks
	else
		return 0
	end
end


-- Connections -- 

Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder") do
		leaderstats.Name = "leaderstats"
		leaderstats.Parent = player
	end

	local clicks = Instance.new("NumberValue") do
		clicks.Name = "Clicks"
		clicks.Value = loadClicks(tostring(player.UserId))
		clicks.Parent = leaderstats
	end

	clicksQueue[tostring(player.UserId)] = { count = clicks.Value, lastSaved = tick() }
end)

event.OnServerEvent:Connect(function(Player: Player, Method: string, Value: string | number)
	local user: string = tostring(Player.UserId) :: string

	if Method == "Click" then
		if not clicksQueue[user] then
			clicksQueue[user] = { count = 0, lastSaved = tick() }
		end

		clicksQueue[user].count += 1

		local leaderstats: Folder = Player:FindFirstChild("leaderstats") :: Folder
		local clicks: NumberValue = leaderstats:FindFirstChild("Clicks") :: NumberValue

		clicks.Value = clicksQueue[user].count

		local currentTime: number = tick() :: number
		if currentTime - clicksQueue[user].lastSaved >= saveInterval or clicksQueue[user].count >= saveThreshold then
			saveClicks(user, clicksQueue[user].count)

			clicksQueue[user].lastSaved = currentTime
		end
	end
end)

Players.PlayerRemoving:Connect(function(Player: Player)
	local user: string = tostring(Player.UserId) :: string

	if clicksQueue[user] then
		saveClicks(user, clicksQueue[user].count)
	end
end)
