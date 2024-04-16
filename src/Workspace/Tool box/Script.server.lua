local ToolNames = {"robux bomb", "robux bomb"}
local Storage = game:GetService("ServerStorage")


local Part = script.Parent
local ClickDetector = Part:WaitForChild("ClickDetector")

ClickDetector.MouseClick:connect(function(Player)
	if Player and Player.Character then
		local Backpack = Player:WaitForChild("Backpack")
		for i = 1, #ToolNames do
			local Tool = Storage:FindFirstChild(ToolNames[i])
			if Tool then
				Tool:clone().Parent = Backpack
			end
		end
	end
end)
