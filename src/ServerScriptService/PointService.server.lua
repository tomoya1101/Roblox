local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ServerStorage = game:GetService("ServerStorage")

-- Modules
local Leaderboard = require(ServerStorage.Leaderboard)
local PlayerData = require(ServerStorage.PlayerData)

local coinsFolder = Workspace.P5.Clear
local coins = coinsFolder:GetChildren()

local COIN_KEY_NAME = PlayerData.COIN_KEY_NAME
local COOLDOWN = 10
local COIN_AMOUNT_TO_ADD = 1


local function onPlayerAdded(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local points = Instance.new("IntValue")
	points.Name = COIN_KEY_NAME
	points.Value = 0
	points.Parent = leaderstats
end

Players.PlayerAdded:Connect(onPlayerAdded)




local function updatePlayerCoins(player, updateFunction)
	-- Update the coin table
	local newCoinAmount = PlayerData.updateValue(player, COIN_KEY_NAME, updateFunction)

	-- Update the coin leaderboard
	Leaderboard.setStat(player, COIN_KEY_NAME, newCoinAmount)
end

-- Defining the event handler
local function onCoinTouched(otherPart, coin)
	if coin:GetAttribute("Enabled") then
		local character = otherPart.Parent
		local player = Players:GetPlayerFromCharacter(character)
		if player then
			-- Player touched a coin
			coin.Transparency = 1
			coin:SetAttribute("Enabled", false)
			updatePlayerCoins(player, function(oldCoinAmount)
				oldCoinAmount = oldCoinAmount or 0
				return oldCoinAmount + COIN_AMOUNT_TO_ADD
			end)

			task.wait(COOLDOWN)
			coin.Transparency = 0
			coin:SetAttribute("Enabled", true)
		end
	end
end

-- Setting up event listeners
for _, coin in coins do
	coin:SetAttribute("Enabled", true)
	coin.Touched:Connect(function(otherPart)
		onCoinTouched(otherPart, coin)
	end)
end