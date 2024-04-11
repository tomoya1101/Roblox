--Moving Platform Script by darklord246


--DO NOT REPUBLISH THIS MODEL!

time = 1 --Time is how many seconds the platform will wait. Change the 3.
bp = script.Parent.Position --Don't remove this part!
while true do
--After Vector3.new, put in the coordinates you want the platform to move to by editing the vectors.
--For example, if you want it to go 20 studs back from its original position in the X vector, put in Vector3.new(bp.x-20, bp.y, bp.z)
script.Parent.BodyPosition.position = Vector3.new(bp.x-40, bp.y, bp.z)
wait(time)
script.Parent.BodyPosition.position = Vector3.new(bp.x, bp.y, bp.z)
wait(time)
end 