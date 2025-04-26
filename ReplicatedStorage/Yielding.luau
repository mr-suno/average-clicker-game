local Yielding = {}

-- Functions --

Yielding.Pause = function(Seconds: number): nil
	task.wait(Seconds or 0)
end

return Yielding
