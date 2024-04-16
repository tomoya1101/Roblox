-- Made by TynouDypak
-- i just added a lock and changed some sounds


local sound = script.Parent.door_locked

function LockedDoor()
	script.Parent.Click.ClickDetector.MaxActivationDistance = 0
	script.Parent.Unlock.Disabled = true
	sound:Play()
	wait(1)
	script.Parent.Click.ClickDetector.MaxActivationDistance = 10
	script.Parent.Unlock.Disabled = false
end
script.Parent.Click.ClickDetector.MouseClick:Connect(LockedDoor)