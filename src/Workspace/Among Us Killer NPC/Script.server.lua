local distanciamax = 20 -- 20 metros para o NPC perSeguir o jogador NPCがプレイヤーを追いかけるまでの20メートル
local distanciamin = 0 -- 5 de distancia minima para o bot parar 5 ボットが停止するための最短距離
function jogador()
	repeat wait() until #game.Players:GetPlayers() >= 1 -- esperar até que a quantidade de jogadores for maior que 1 ou igual プレーヤーの数が1以上になるまで待つ。
	local NPC = script.Parent
	local NPCHumanoidRoot = NPC.HumanoidRootPart
	local NPCHumanoid = NPC.Humanoid
	for i,v in pairs(game.Players:GetPlayers()) do -- Pegar a lista dos jogadores 選手リスト取得
		repeat wait() until v.Character -- Aguardar o character do player プレイヤーキャラクターを待つ
		if (v.Character.HumanoidRootPart.Position - NPCHumanoidRoot.Position).Magnitude <= 20 and (v.Character.HumanoidRootPart.Position - NPCHumanoidRoot.Position).Magnitude >= distanciamin then
			NPCHumanoid:MoveTo(v.Character.HumanoidRootPart.Position - Vector3.new(0,distanciamin,0))
			if v.Character.Humanoid.Jump == true then -- se o jogador pular o npc também irá pular プレイヤーがジャンプすれば、NPCもジャンプする。
				NPCHumanoid.Jump = true
			end
			NPCHumanoidRoot.Touched:Connect(function(hit) -- dar dano no jogador 選手にダメージを与える
				if hit.Parent:FindFirstChild("Humanoid") then
					hit.Parent:FindFirstChild("Humanoid"):TakeDamage(100)
				end
			end)
		end
	end
end

while wait() do
	jogador()
end