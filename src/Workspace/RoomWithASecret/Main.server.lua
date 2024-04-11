--[[
	
	~DanzLua	
	Your goto buddy for stuff :)
	
--]]

local button = script.Parent.Button
local top = script.Parent.Top
local floor = script.Parent.Floor

local it = false
local d = true
button.ClickDetector.MouseClick:Connect(function(plr)
	if d==true then d=false
		if it==false then it=true
			local x = floor.Position.X
			local y = floor.Position.Y
			local z = floor.Position.Z
			local newy = floor.Position.Y-11.4
			
			repeat wait()
				floor.CFrame=CFrame.new(Vector3.new(x,y,z))
				y=y-.05
			until
			floor.Position.Y<=newy
		elseif it==true then
			it=false
			local x = floor.Position.X
			local y = floor.Position.Y
			local z = floor.Position.Z
			local newy = floor.Position.Y+11.4
			
			repeat wait()
				floor.CFrame=CFrame.new(Vector3.new(x,y,z))
				y=y+.05
			until
			floor.Position.Y>=newy
		end
	end
	d=true
end)