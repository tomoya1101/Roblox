-- Made by TynouDypak
-- i just changed some sounds and added a working lock


local key = script.KeyName.Value
local sound = script.Parent.door_unlock
local lockk = script.Parent.Display

script.Parent.Click.Touched:Connect(function(unlock)
	if unlock.Parent.Name == key then
		sound:Play()
		lockk.Anchored = false --// makes the lock fall off the door when unlocked
		script.Parent.ClickDelay.Disabled = false
		script.Parent.Open.Disabled = false
		unlock.Parent:Destroy()
		script.Parent.LockedDoor:Destroy()
		script:Destroy()
	end
end)
