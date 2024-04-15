--親子関係のオブジェクトを探す 引数（親、探す名前）
function waitForChild(parent, childName)
	local child = parent:findFirstChild(childName)
	--探している親子関係のオブジェクトが存在すればそのオブジェクトを返す
	if child then return child end
	--探している子供が追加されるまで繰り返す
	while true do
		--子供がついかされるまで待つ
		child = parent.ChildAdded:wait()
		--追加された子供が探しているのと同じかを確認する
		if child.Name==childName then return child end
	end
end

--このスクリプトのついている親をとる
local Figure = script.Parent

--それぞれの名前の付いた子供オブジェクトを探す
local Torso = waitForChild(Figure, "Torso")
local RightShoulder = waitForChild(Torso, "Right Shoulder")
local LeftShoulder = waitForChild(Torso, "Left Shoulder")
local RightHip = waitForChild(Torso, "Right Hip")
local LeftHip = waitForChild(Torso, "Left Hip")
local Neck = waitForChild(Torso, "Neck")
local Humanoid = waitForChild(Figure, "Humanoid")

--現在のアニメーション
local pose = "Standing"
--今の行っているアニメーションの名前
local currentAnim = ""
--現在のアニメトラック
local currentAnimTrack = nil
--キーフレーム名のトリガーを設定
local currentAnimKeyframeHandler = nil
local oldAnimTrack = nil
--テーブルを作成
local animTable = {}
--アニメーションの名前を管理
local animNames = {
	idle = 	{	
				{ id = "http://www.roblox.com/asset/?id=125750544", weight = 9 },
				{ id = "http://www.roblox.com/asset/?id=125750618", weight = 1 }
			},
	walk = 	{ 	
				{ id = "http://www.roblox.com/asset/?id=125749145", weight = 10 }
			},
	run = 	{
				{ id = "run.xml", weight = 10 }
			},
	jump = 	{
				{ id = "http://www.roblox.com/asset/?id=125750702", weight = 10 }
			},
	fall = 	{
				{ id = "http://www.roblox.com/asset/?id=125750759", weight = 10 }
			},
	climb = {
				{ id = "http://www.roblox.com/asset/?id=125750800", weight = 10 }
			},
	toolnone = {
				{ id = "http://www.roblox.com/asset/?id=125750867", weight = 10 }
			},
	toolslash = {
				{ id = "http://www.roblox.com/asset/?id=129967390", weight = 10 }
--				{ id = "slash.xml", weight = 10 }
			},
	toollunge = {
				{ id = "http://www.roblox.com/asset/?id=129967478", weight = 10 }
			},
	wave = {
				{ id = "http://www.roblox.com/asset/?id=128777973", weight = 10 }
			},
	point = {
				{ id = "http://www.roblox.com/asset/?id=128853357", weight = 10 }
			},
	dance = {
				{ id = "http://www.roblox.com/asset/?id=130018893", weight = 10 },
				{ id = "http://www.roblox.com/asset/?id=132546839", weight = 10 },
				{ id = "http://www.roblox.com/asset/?id=132546884", weight = 10 }
			},
	laugh = {
				{ id = "http://www.roblox.com/asset/?id=129423131", weight = 10 }
			},
	cheer = {
				{ id = "http://www.roblox.com/asset/?id=129423030", weight = 10 }
			},
}

-- Existance in this list signifies that it is an emote, the value indicates if it is a looping emote
--このリストに存在すればエモートであることを示し、値はループするエモートであるかどうかを示す。
local emoteNames = { wave = false, point = false, dance = true, laugh = false, cheer = false}

--乱数ジェネレーターを初期化（引数は1970年1月1日からの経過時間を入れる）
math.randomseed(tick())

-- Setup animation objects
--アニメーションオブジェクトの設定
-- nameに名前 fileListに内容 pairs関数を使用すると、連想配列のキーと値のペアを返す
for name, fileList in pairs(animNames) do
	--テーブル作成
	animTable[name] = {}
	--テーブルの中に変数を作る
	animTable[name].count = 0
	animTable[name].totalWeight = 0

	-- check for config values
	--設定値のチェック
	--nilが返ってくるのが正しい
	local config = script:FindFirstChild(name)
	--print(config)
	--存在するときは
	if (config ~= nil) then
		print("Loading anims " .. name)
		local idx = 1
		for _, childPart in pairs(config:GetChildren()) do
			animTable[name][idx] = {}
			--テーブルにアニメーションの名前を入れる変数を作る
			animTable[name][idx].anim = childPart
			--アニメーションの重量がせっていされているか
			local weightObject = childPart:FindFirstChild("Weight")
			--設定されていなければ
			if (weightObject == nil) then
				--テーブルに重量を入れる変数を作る
				animTable[name][idx].weight = 1
			else
				--設定されていれば取る
				animTable[name][idx].weight = weightObject.Value
			end
			--カウントを増やす
			animTable[name].count = animTable[name].count + 1
			--総重量を増やす
			animTable[name].totalWeight = animTable[name].totalWeight + animTable[name][idx].weight
--			print(name .. " [" .. idx .. "] " .. animTable[name][idx].anim.AnimationId .. " (" .. animTable[name][idx].weight .. ")")
			idx = idx + 1
		end
	end

	-- fallback to defaults
	--カウントが0以下のときに行う
	if (animTable[name].count <= 0) then
		for idx, anim in pairs(fileList) do
			animTable[name][idx] = {}
			animTable[name][idx].anim = Instance.new("Animation")
			animTable[name][idx].anim.Name = name
			animTable[name][idx].anim.AnimationId = anim.id
			animTable[name][idx].weight = anim.weight
			animTable[name].count = animTable[name].count + 1
			animTable[name].totalWeight = animTable[name].totalWeight + anim.weight
--			print(name .. " [" .. idx .. "] " .. anim.id .. " (" .. anim.weight .. ")")
		end
	end
end

-- ANIMATION

-- declarations
--宣言
local toolAnim = "None"
local toolAnimTime = 0

local jumpAnimTime = 0
local jumpAnimDuration = 0.175

local toolTransitionTime = 0.1
local fallTransitionTime = 0.2
local jumpMaxLimbVelocity = 0.75

-- functions
--機能

--全てのアニメーションを止める
function stopAllAnimations()
	--今のアニメーションをとる
	local oldAnim = currentAnim

	-- return to idle if finishing an emote
	--エモートを終えたらアイドルエモートにする
	if (emoteNames[oldAnim] ~= nil and emoteNames[oldAnim] == false) then
		oldAnim = "idle"
	end

	--現在のエモートを空にする
	currentAnim = ""

	if (currentAnimKeyframeHandler ~= nil) then
		--イベントの切断
		currentAnimKeyframeHandler:disconnect()
	end

	if (oldAnimTrack ~= nil) then
		--前のアニメトラックを止める
		oldAnimTrack:Stop()
		--消す
		oldAnimTrack:Destroy()
		--nilを入れる
		oldAnimTrack = nil
	end

	if (currentAnimTrack ~= nil) then
		--現在のアニメトラックを止める
		currentAnimTrack:Stop()
		--消す
		currentAnimTrack:Destroy()
		--nilを入れる
		currentAnimTrack = nil
	end
	return oldAnim
end

--キーフレーム到達関数
local function keyFrameReachedFunc(frameName)
	if (frameName == "End") then
--		print("Keyframe : ".. frameName)
		local repeatAnim = stopAllAnimations()
		playAnimation(repeatAnim, 0.0, Humanoid)
	end
end

-- Preload animations
--アニメーションをロード
function playAnimation(animName, transitionTime, humanoid)
	--アニメーションの名前が現在のアニメーションと違うとき
	if (animName ~= currentAnim) then		
		
		if (oldAnimTrack ~= nil) then
			--前のアニメトラックを止める
			oldAnimTrack:Stop()
			--消す
			oldAnimTrack:Destroy()
		end

		--乱数生成
		local roll = math.random(1, animTable[animName].totalWeight)
		local origRoll = roll
		local idx = 1
		--rollのサイズが指定したアニメショーンサイズより大きいとき
		while (roll > animTable[animName][idx].weight) do
			--小さくする
			roll = roll - animTable[animName][idx].weight
			--idxを増やして全てのサイズより小さいかを確認する
			idx = idx + 1
		end
--		print(animName .. " " .. idx .. " [" .. origRoll .. "]")
		local anim = animTable[animName][idx].anim

		-- load it to the humanoid; get AnimationTrack
		--アニメーショントラックをヒューマノイドからとる
		oldAnimTrack = currentAnimTrack
		--指定されたアニメーションをロードし再生可能なアニメーショントラックを返す
		currentAnimTrack = humanoid:LoadAnimation(anim)
		
		-- play the animation
		--アニメーション再生
		currentAnimTrack:Play(transitionTime)
		--現在のアニメーションに再生するアニメーション名を入れる
		currentAnim = animName

		-- set up keyframe name triggers
		if (currentAnimKeyframeHandler ~= nil) then
			--イベントの切断
			currentAnimKeyframeHandler:disconnect()
		end
		--キーフレーム到達関数を現在のアニメトラックのキーフレーム到達にコネクト
		currentAnimKeyframeHandler = currentAnimTrack.KeyframeReached:connect(keyFrameReachedFunc)
	end
end

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
--ツールアニメ名前
local toolAnimName = ""
--ツールアニメの前トラック
local toolOldAnimTrack = nil
--ツールアニメのトラック
local toolAnimTrack = nil
--現在ツールアニメキーフレームハンドル
local currentToolAnimKeyframeHandler = nil

local function toolKeyFrameReachedFunc(frameName)
	if (frameName == "End") then
--		print("Keyframe : ".. frameName)
		local repeatAnim = stopToolAnimations()
		playToolAnimation(repeatAnim, 0.0, Humanoid)
	end
end


function playToolAnimation(animName, transitionTime, humanoid)
	if (animName ~= toolAnimName) then		
		
		if (toolAnimTrack ~= nil) then
			toolAnimTrack:Stop()
			toolAnimTrack:Destroy()
			transitionTime = 0
		end

		local roll = math.random(1, animTable[animName].totalWeight)
		local origRoll = roll
		local idx = 1
		while (roll > animTable[animName][idx].weight) do
			roll = roll - animTable[animName][idx].weight
			idx = idx + 1
		end
--		print(animName .. " * " .. idx .. " [" .. origRoll .. "]")
		local anim = animTable[animName][idx].anim

		-- load it to the humanoid; get AnimationTrack
		toolOldAnimTrack = toolAnimTrack
		toolAnimTrack = humanoid:LoadAnimation(anim)
		
		-- play the animation
		toolAnimTrack:Play(transitionTime)
		toolAnimName = animName

		currentToolAnimKeyframeHandler = toolAnimTrack.KeyframeReached:connect(toolKeyFrameReachedFunc)
	end
end

function stopToolAnimations()
	local oldAnim = toolAnimName

	if (currentToolAnimKeyframeHandler ~= nil) then
		currentToolAnimKeyframeHandler:disconnect()
	end

	toolAnimName = ""
	if (toolAnimTrack ~= nil) then
		toolAnimTrack:Stop()
		toolAnimTrack:Destroy()
		toolAnimTrack = nil
	end


	return oldAnim
end

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

--走ってるとき
function onRunning(speed)
	--スピードが０より大きいとき
	if speed>0 then
		--歩くアニメーションを再生
		playAnimation("walk", 0.1, Humanoid)
		pose = "Running"
	else
		--止まっているときアイドルアニメーション
		playAnimation("idle", 0.1, Humanoid)
		pose = "Standing"
	end
end

--死亡アニメーション
function onDied()
	pose = "Dead"
end

--ジャンプアニメーション
function onJumping()
	playAnimation("jump", 0.1, Humanoid)
	jumpAnimTime = jumpAnimDuration
	pose = "Jumping"
end

--クライミングアニメーション
function onClimbing()
	playAnimation("climb", 0.1, Humanoid)
	pose = "Climbing"
end

function onGettingUp()
	pose = "GettingUp"
end

function onFreeFall()
	if (jumpAnimTime <= 0) then
		playAnimation("fall", fallTransitionTime, Humanoid)
	end
	pose = "FreeFall"
end

function onFallingDown()
	pose = "FallingDown"
end

function onClimbing()
	pose = "Seated"
end

function onPlatformStanding()
	pose = "PlatformStanding"
end

function onSwimming(speed)
	if speed>0 then
		pose = "Running"
	else
		pose = "Standing"
	end
end


local function getTool()	
	for _, kid in ipairs(Figure:GetChildren()) do
		if kid.className == "Tool" then return kid end
	end
	return nil
end

local function getToolAnim(tool)
	for _, c in ipairs(tool:GetChildren()) do
		if c.Name == "toolanim" and c.className == "StringValue" then
			return c
		end
	end
	return nil
end

local function animateTool()
	
	if (toolAnim == "None") then
		playToolAnimation("toolnone", toolTransitionTime, Humanoid)
		return
	end

	if (toolAnim == "Slash") then
		playToolAnimation("toolslash", 0, Humanoid)
		return
	end

	if (toolAnim == "Lunge") then
		playToolAnimation("toollunge", 0, Humanoid)
		return
	end
end

local function moveSit()
	--最大速度設定
	RightShoulder.MaxVelocity = 0.15
	LeftShoulder.MaxVelocity = 0.15
	--角度設定
	RightShoulder:SetDesiredAngle(3.14 /2)
	LeftShoulder:SetDesiredAngle(-3.14 /2)
	RightHip:SetDesiredAngle(3.14 /2)
	LeftHip:SetDesiredAngle(-3.14 /2)
end

local lastTick = 0

function move(time)
	--振幅
	local amplitude = 1
	--頻度
	local frequency = 1
	local deltaTime = time - lastTick
	lastTick = time

	local climbFudge = 0
	local setAngles = false

	--ジャンプアニメーション時間が０より大きいとき
	if (jumpAnimTime > 0) then
		jumpAnimTime = jumpAnimTime - deltaTime
	end

	if (pose == "FreeFall" and jumpAnimTime <= 0) then
		playAnimation("fall", fallTransitionTime, Humanoid)
	elseif (pose == "Seated") then
		stopAllAnimations()
		moveSit()
		return
	elseif (pose == "Running") then
		playAnimation("walk", 0.1, Humanoid)
	elseif (pose == "Dead" or pose == "GettingUp" or pose == "FallingDown" or pose == "Seated" or pose == "PlatformStanding") then
--		print("Wha " .. pose)
		amplitude = 0.1
		frequency = 1
		setAngles = true
	end

	if (setAngles) then
		local desiredAngle = amplitude * math.sin(time * frequency)
		--角度の設定
		RightShoulder:SetDesiredAngle(desiredAngle + climbFudge)
		LeftShoulder:SetDesiredAngle(desiredAngle - climbFudge)
		RightHip:SetDesiredAngle(-desiredAngle)
		LeftHip:SetDesiredAngle(-desiredAngle)
	end

	-- Tool Animation handling
	local tool = getTool()
	--ツールを持っているときだけ処理
	if tool then
	
		local animStringValueObject = getToolAnim(tool)

		if animStringValueObject then
			toolAnim = animStringValueObject.Value
			-- message recieved, delete StringValue
			animStringValueObject.Parent = nil
			toolAnimTime = time + .3
		end

		if time > toolAnimTime then
			toolAnimTime = 0
			toolAnim = "None"
		end

		animateTool()		
	else
		--ツールのアニメーションを止める
		stopToolAnimations()
		toolAnim = "None"
		toolAnimTime = 0
	end
end

-- connect events
--Healthが０になったときに発生する
Humanoid.Died:connect(onDied)
--実行速度が変化したときに発生する
Humanoid.Running:connect(onRunning)
--ジャンプするときに発生する
Humanoid.Jumping:connect(onJumping)
--上昇速度が変化したときに発生
Humanoid.Climbing:connect(onClimbing)
--Enum.HumanoidStateType.GettingUp状態に入るとき、または出るときに発生する
Humanoid.GettingUp:connect(onGettingUp)
--Freefall Enum.HumanoidStateTypeに出入りするときに発生する
Humanoid.FreeFalling:connect(onFreeFall)
--FallingDown Enum.HumanoidStateTypeに出入りするときに発生する
Humanoid.FallingDown:connect(onFallingDown)
--SeatまたはVehicleSeatに座るか、そこから立ち上がる ときに発生する
--Humanoid.Seated:connect(onSeated)
--PlatformStanding Enum.HumanoidStateTypeに出入りする ときに発生する
Humanoid.PlatformStanding:connect(onPlatformStanding)
--水中を泳ぐ 速度が変化したときに発生する
Humanoid.Swimming:connect(onSwimming)

-- main program

local runService = game:service("RunService");

-- initialize to idle
--最初アイドル状態から
playAnimation("idle", 1, Humanoid)
pose = "Standing"

while Figure.Parent~=nil do
	--値が二つ返ってくるのでいらない方は_で受け取る
	local _, time = wait(1)
	--print(time)
	move(time)
end
