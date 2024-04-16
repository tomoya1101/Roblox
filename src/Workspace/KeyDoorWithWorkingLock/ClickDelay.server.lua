--disable
-- Made by TynouDypak
-- i just changed some sounds and added a working lock


local click = script.Parent.Click

function OpenDoor()
	click.ClickDetector.MaxActivationDistance = 0
	wait(1)
	click.ClickDetector.MaxActivationDistance=10
end
script.Parent.Click.ClickDetector.MouseClick:Connect(OpenDoor)