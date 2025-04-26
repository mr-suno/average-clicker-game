local Debugger = {}

-- Functions --

Debugger.log = function(...)
	print(...)
end

Debugger.issue = function(Error: boolean, ...)
	if Error then
		warn(...)
	else
		error(...)
	end
end

return Debugger
