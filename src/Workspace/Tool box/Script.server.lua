--ツールの入っている場所
local Storage = game:GetService("ServerStorage")
--このスクリプトの親
local ProximityPrompt = script.Parent
--取ってくるツールの名前（今回は親の名前）
local ToolNames = ProximityPrompt.Parent.Name

--Eキー長押しされたか
ProximityPrompt.Triggered:Connect(function(Player)
	print(ToolNames)
	--プレイヤーかどうか
	if Player then
		--プレイヤーのバックパックを取得する
		local Backpack = Player:WaitForChild("Backpack")
		--ほしいツールを探す
		local Tool = Storage:FindFirstChild(ToolNames)
		--ほしいツールがあれば
		if Tool then
			--ツールのクローンを作り、その親をバックパックにする
			Tool:clone().Parent = Backpack
		end
		--ツールを手に入れたのでフィールドに存在するツールは消す
		ProximityPrompt.Parent:Destroy()
	end
end)
