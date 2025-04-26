local Manager = {}

-- Services --

local RS = game:GetService("ReplicatedStorage")
local DS = game:GetService("DataStoreService")


-- Variables --

local debugger = require(RS:WaitForChild("Modules"):WaitForChild("Debugger"))


-- Functions --

Manager.SetData = function(Dictionary: DataStore, Key: string | number, Value: string | number): nil
	local success, issue = pcall(function()
		Dictionary:SetAsync(Key, Value)
	end)
	
	if not success then
		debugger.issue(issue)
	end
end

return Manager
