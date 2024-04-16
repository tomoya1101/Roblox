--disable
-- Made by TynouDypak
-- i just changed some sounds and added a working lock

local Hinge = script.Parent.PrimaryPart
local sound = script.Parent.door_open
local sound2 = script.Parent.door_close
local opened = script.Opened

function OpenDoor()
	if opened.Value == false then
		opened.Value = true
		sound:Play()
		for i = 1, 18 do
			script.Parent:SetPrimaryPartCFrame(Hinge.CFrame*CFrame.Angles(0, math.rad(-5), 0)) --change -5 to 5 if you want to change the door opening direction.
			wait()
		end
	else
		opened.Value = false
		sound2:Play()
		for i = 1, 18 do
			script.Parent:SetPrimaryPartCFrame(Hinge.CFrame*CFrame.Angles(0, math.rad(5), 0)) --change 5 to -5 if you want to change the door opening direction.
			wait()
		end
	end
end

script.Parent.Click.ClickDetector.MouseClick:Connect(OpenDoor)