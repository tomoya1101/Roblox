name="Humanoid"

robo=script.Parent:clone()

while true do
	if script.Parent.Humanoid.Health<1 then
		wait(5)
		robot=robo:clone()
		robot.Parent=script.Parent.Parent
		robot:makeJoints()
		script.Parent:remove()
	end
	wait(5)
end