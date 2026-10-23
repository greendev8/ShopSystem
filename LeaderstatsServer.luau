local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)

	local leaderstats = Instance.new("Folder") 
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local money = Instance.new("IntValue")
	money.Name = "Cash"
	money.Value = 0
	money.Parent = leaderstats
	
	local Apples = Instance.new("IntValue")
	Apples.Name = "Apples"
	Apples.Value = 0
	Apples.Parent = leaderstats
	
	local Lemons = Instance.new("IntValue")
	Lemons.Name = "Lemons"
	Lemons.Value = 0
	Lemons.Parent = leaderstats
	
	local Pumpkins = Instance.new("IntValue")
	Pumpkins.Name = "Pumpkins"
	Pumpkins.Value = 0
	Pumpkins.Parent = leaderstats
end)