--取ってくるツールの名前
local ToolNames = "robux bomb"
--ツールの入っている場所
local Storage = game:GetService("ServerStorage")
--このスクリプトの親
local proximityPrompt = script.Parent

--Eキー長押しでアイテムを獲得する
proximityPrompt.Triggered:Connect(function(Player)
	--プレイヤーかどうか
	if Player and Player.Character then
		--プレイヤーのバックパックを取得する
		local Backpack = Player:WaitForChild("Backpack")
			--ほしいツールを探す
			local Tool = Storage:FindFirstChild(ToolNames)
			--ほしいツールがあれば
			if Tool then
				--ツールのクローンを作り、その親をバックパックにする
				Tool:clone().Parent = Backpack
			end
	end
end)