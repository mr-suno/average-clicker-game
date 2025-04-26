local Animate = {}

-- Services --

local TweenService = game:GetService("TweenService")


-- Functions --

Animate.AnimateUI = function(Time: number, AnimationType: Enum.EasingStyle, Interface: GuiObject, Reaction: SharedTable, Callback: any): nil
	local TweenInfo = TweenInfo.new(Time, AnimationType)
	local Tween = TweenService:Create(Interface, TweenInfo, Reaction)
	
	Tween:Play()
	Tween.Completed:Connect(Callback)
end

return Animate
