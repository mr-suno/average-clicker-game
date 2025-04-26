-- Services --

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")


-- Variables --

local animator = require(RS:FindFirstChild("Animate", true))
local yielder = require(RS:FindFirstChild("Yielding", true))

local event: RemoteEvent = RS:WaitForChild("Remotes"):WaitForChild("Event") :: RemoteEvent

local buttonClick: Sound = RS:WaitForChild("Audios"):WaitForChild("Button Click") :: Sound

local localPlayer: Player = Players.LocalPlayer :: Player
local playerGui: PlayerGui = localPlayer.PlayerGui :: PlayerGui

local bottomRow: ScreenGui = playerGui:WaitForChild("Bottom Row") :: ScreenGui
local inner: Frame = bottomRow:WaitForChild("Inner") :: Frame

local data: SharedTable = {
	tapper = {
		tappable = true,
		cooldown = 0.23
	},
	
	shop = {
		tappable = true,
		cooldown = 0.5
	}
}


-- Yielding --

repeat yielder.Pause() until inner


-- Functions --

local function trigger(Keybind: string, Name: string, DataPath: SharedTable, Callback: any)
	for _, Frame in inner:GetChildren() do
		if Frame:IsA("Frame") and Frame.Name:lower() == Name:lower() then
			local backboard: Frame = Frame:FindFirstChild("Backboard") :: Frame
			local hitbox: TextButton = backboard:FindFirstChild("Hitbox") :: TextButton
			
			local function action()
				if DataPath.tappable then
					DataPath.tappable = false
					backboard.Position = UDim2.new(0.5, 0, 0.5, 4)

					buttonClick:Play()
					yielder.Pause(DataPath.cooldown)

					backboard.Position = UDim2.new(0.5, 0, 0.5, 0)
					DataPath.tappable = true

					if Callback then
						Callback()
					end
				end
			end
			
			hitbox.MouseButton1Click:Connect(action)
			
			UIS.InputBegan:Connect(function(Input: InputObject, GameProcessed: boolean)
				if not GameProcessed then
					if Input.KeyCode.Name == Keybind then
						action()
					end
				end
			end)
		end
	end
end


-- GUI Interactions --

trigger("F", "Click", data.tapper, function()
	event:FireServer("Click")
end)

trigger("B", "Store", data.shop, function()
	playerGui:WaitForChild("Store").Enabled = true
end)
