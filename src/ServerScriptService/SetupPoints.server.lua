local Players = game:GetService("Players")

local function onPlayerAdded(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local points = Instance.new("IntValue")
    points.Name = "Points"
    points.Value = 0
    points.Parent = leaderstats
end

Players.PlayerAdded:Connect(onPlayerAdded)

while true do
    task.wait(1)
    --local playerList = Players:GetPlayers()
    
end