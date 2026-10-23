local rp = game:GetService("ReplicatedStorage")

local remote = rp:FindFirstChild("UpdateStats") or rp:WaitForChild("UpdateStats")


remote.OnServerEvent:Connect(function(player, value, amount)
	print("got")
	player.leaderstats[value].Value += amount
	
end)