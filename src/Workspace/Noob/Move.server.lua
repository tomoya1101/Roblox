--当たっているものを入れるようの変数
local CurrentPart = nil
local MaxInc = 11

function onTouched(hit)
	--当たっている親が無いとき戻る
	if hit.Parent == nil then
		return
	end

	--当たっている親の子供にHumanoidが存在するか
	local humanoid = hit.Parent:findFirstChild("Humanoid")

	--存在しない場合のみ以下の処理を行う
	if humanoid == nil then
		--何が当たっているかを入れる
		CurrentPart = hit
		--print(CurrentPart)
	end
end

--親子関係のオブジェクトを探す 引数（親、探す名前）
function waitForChild(parent, childName)
	local child = parent:findFirstChild(childName)

	--探している親子関係のオブジェクトが存在すればそのオブジェクトを返す
	if child then
		return child
	end

	--探している子供が追加されるまで繰り返す
	while true do
		--子供がついされるまで待つ
		child = parent.ChildAdded:wait()
		--追加された子供が探しているのと同じかを確認する
		if child.Name==childName then
			return child
		end
	end
end

--このスクリプトのついている親をとる
local Figure = script.Parent

--それぞれの名前の付いた子供オブジェクトを探す
local Humanoid = waitForChild(Figure, "Humanoid")
local Torso = waitForChild(Figure, "Torso")
local Left = waitForChild(Figure, "Left Leg")
local Right = waitForChild(Figure, "Right Leg")

--ジャンプさせる
--Humanoidのプロパティをいじる
Humanoid.Jump = true

--両足に今何に当たっているかを取らす
Left.Touched:connect(onTouched)
Right.Touched:connect(onTouched)

while true do
	--次に動き出すまでの時間
	wait(math.random(0.001, 3))

	--何かに当たっているとき
	if CurrentPart ~= nil then
		--１か２のランダムな数値をとる
		--１だった時に以下の処理を行う
		if math.random(1, 2) == 1 then
			Humanoid.Jump = true
		end
		
		wait(math.random(1, 2))

		--Move関数
		--Torso ~ math.rando()) までが場所（現在のx + (-11 ~ 11) , 現在のy + 0 , 現在のz + (-11 ~ 11)） , Humanoid.WalkToPart  CurrentPartは規定値nill（設定しておいた方がよい）
		--向いている方向も変わる
		Humanoid:MoveTo(Torso.Position + Vector3.new(math.random(-MaxInc, MaxInc), 0, math.random(-MaxInc, MaxInc)), CurrentPart)
	end
end
