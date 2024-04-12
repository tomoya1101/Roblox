--当たっているものを入れるようの変数
local CurrentPart = nil
local MaxInc = 11

function onTouched(hit)
	if hit.Parent == nil then
		return
	end

	local humanoid = hit.Parent:findFirstChild("Humanoid")

	if humanoid == nil then
		--何が当たっているかを入れる
		CurrentPart = hit
		--print(hit)
	end
end

function waitForChild(parent, childName)
	local child = parent:findFirstChild(childName)

	if child then
		return child
	end

	while true do
		print(childName)

		child = parent.ChildAdded:wait()

		if child.Name==childName then
			return child
		end
	end
end

local Figure = script.Parent
local Humanoid = waitForChild(Figure, "Humanoid")
local Torso = waitForChild(Figure, "Torso")
local Left = waitForChild(Figure, "Left Leg")
local Right = waitForChild(Figure, "Right Leg")

--ジャンプさせる
--Humanoidのプロパティをいじる
Humanoid.Jump = true

Left.Touched:connect(onTouched)
Right.Touched:connect(onTouched)

while true do
	wait(math.random(0.001, 3))

	--何かに当たっているとき
	if CurrentPart ~= nil then
		--１か２のランダムな数値をとる
		--１だった時に以下の処理を行う
		if math.random(1, 2) == 1 then
			Humanoid.Jump = false
		end

		--Move関数
		--Torso ~ math.rando()) までが場所 , Humanoid.WalkToPart  CurrentPartは規定値nill
		Humanoid:MoveTo(Torso.Position + Vector3.new(math.random(-MaxInc, MaxInc), 0, math.random(-MaxInc, MaxInc)), CurrentPart)
	end
end
