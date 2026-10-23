local UIS = game:GetService("UserInputService")
local Tw = game:GetService("TweenService")
local replicated = game:GetService("ReplicatedStorage")

local LPlayer = game.Players.LocalPlayer

local Mouse = LPlayer:GetMouse()

local Camera = workspace.CurrentCamera

local State = nil

local MarketStand = workspace:FindFirstChild("MarketStand") or workspace:WaitForChild("MarketStand")
local AppleBox = MarketStand:FindFirstChild("AppleBox") or MarketStand:WaitForChild("AppleBox")
local LemonBox = MarketStand:FindFirstChild("LemonBox") or MarketStand:WaitForChild("LemonBox")
local PumkinBox = MarketStand:FindFirstChild("PumkinBox") or MarketStand:WaitForChild("PumkinBox")

local BotBogdanNpc = workspace:FindFirstChild("BotBogdan03") or workspace:WaitForChild("BotBogdan03")
local NpcHrp = BotBogdanNpc:FindFirstChild("HumanoidRootPart") or BotBogdanNpc:WaitForChild("HumanoidRootPart")
local Proximity = NpcHrp:FindFirstChild("ProximityPrompt") or NpcHrp:WaitForChild("ProximityPrompt")

local AppleHitbox = AppleBox:FindFirstChild("AppleBox") or AppleBox:WaitForChild("AppleBox")
local LemonHitbox = LemonBox:FindFirstChild("LemonBox") or LemonBox:WaitForChild("LemonBox")
local PumkinHitbox = PumkinBox:FindFirstChild("PumkinBox") or PumkinBox:WaitForChild("PumkinBox")

local Highlight1 = Instance.new("Highlight")
Highlight1.Parent = MarketStand
Highlight1.FillColor = Color3.fromRGB(255, 255, 255)
Highlight1.DepthMode = Enum.HighlightDepthMode.Occluded
Highlight1.FillTransparency = 0.55
Highlight1.Enabled = false

local Highlight2 = Highlight1:Clone()
local Highlight3 = Highlight1:Clone()

Highlight1.Parent = MarketStand
Highlight2.Parent = MarketStand
Highlight3.Parent = MarketStand

Proximity.Triggered:Connect(function(Player)
	
	if Player == LPlayer then
		
		
		local BuyConnections = {
			BuyApplesConnection = nil;
			BuyLemonsConnection = nil;
			BuyPumpkinsConnection = nil;
		}
		
		local HighlightConnection
		local ApplesConnection
		local LemonsConnection
		local PumpkinsConnection
		
		Proximity.Enabled = false
		
		local Character = Player.Character
		
		local CameraPart = workspace.CameraPart
		Camera.CameraType = Enum.CameraType.Scriptable
		
		Tw:Create(Camera, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CameraPart.CFrame}):Play()
		
		Character.HumanoidRootPart.CFrame = workspace.CharacterPosition.CFrame
		Character.HumanoidRootPart.Anchored = true
		
		task.wait(0.7)
		
		script.Parent.Enabled = true
		
		AppleBox.ForBillboard.BillboardGui.Enabled = true
		LemonBox.ForBillboard.BillboardGui.Enabled = true
		PumkinBox.ForBillboard.BillboardGui.Enabled = true
		
		HighlightConnection = UIS.InputChanged:Connect(function(Input, gpe)

			if gpe then return end
			
			if Camera.CFrame ~= CameraPart.CFrame then
				
				if Highlight1.Enabled == false then return end

				Highlight1.Adornee = nil
				Highlight2.Adornee = nil
				Highlight3.Adornee = nil

				Highlight1.Enabled = false
				Highlight2.Enabled = false
				Highlight3.Enabled = false
				
			end

			if Input.UserInputType == Enum.UserInputType.MouseMovement then

				if Mouse.Target == AppleHitbox then

					Highlight1.Adornee = AppleBox.DeviderPartApple
					Highlight2.Adornee = AppleBox.Part
					Highlight3.Adornee = AppleBox.OtherPart

					Highlight1.Enabled = true
					Highlight2.Enabled = true
					Highlight3.Enabled = true

				elseif Mouse.Target == LemonHitbox then

					Highlight1.Adornee = LemonBox.Part
					Highlight2.Adornee = AppleBox.DeviderPartApple
					Highlight3.Adornee = PumkinBox.DeviderPartPumpkin

					Highlight1.Enabled = true
					Highlight2.Enabled = true
					Highlight3.Enabled = true

				elseif Mouse.Target == PumkinHitbox then

					Highlight1.Adornee = PumkinBox.DeviderPartPumpkin
					Highlight2.Adornee = PumkinBox.Right
					Highlight3.Adornee = PumkinBox.Part

					Highlight1.Enabled = true
					Highlight2.Enabled = true
					Highlight3.Enabled = true

				else

					if Highlight1.Enabled == false then return end

					Highlight1.Adornee = nil
					Highlight2.Adornee = nil
					Highlight3.Adornee = nil

					Highlight1.Enabled = false
					Highlight2.Enabled = false
					Highlight3.Enabled = false

				end		

			end

		end)
		
		ApplesConnection = AppleHitbox.ClickDetector.MouseClick:Connect(function()
			
			if Camera.CFrame ~= CameraPart.CFrame then return end
			
			Highlight1.Adornee = nil
			Highlight2.Adornee = nil
			Highlight3.Adornee = nil

			Highlight1.Enabled = false
			Highlight2.Enabled = false
			Highlight3.Enabled = false
			
			Tw:Create(Camera, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = AppleHitbox.ClickDetector.CameraForApples.CFrame}):Play()
			State = "Transitioning"
			
			AppleBox.ForBillboard.BillboardGui.TextLabel.Text = "1$ = 1 Apple"
			LemonBox.ForBillboard.BillboardGui.Enabled = false
			PumkinBox.ForBillboard.BillboardGui.Enabled = false
			
			task.wait(0.7)
			
			State = nil
			
			script.Parent.Enabled = true
			script.Parent.AppleGUI.AppleQuantity.Text = 1
			
			Tw:Create(script.Parent.AppleGUI, TweenInfo.new(0.5), {GroupTransparency = 0}):Play()
			
			task.wait(0.5)
			
			local BuyCD = false
			
			BuyConnections.BuyApplesConnection = script.Parent.AppleGUI.AppleBuy.MouseButton1Click:Connect(function()
				
				if BuyCD then return end
				
				BuyCD = true
				
				
				local Quantity = tonumber(script.Parent.AppleGUI.AppleQuantity.Text)
				
				if Quantity then
					
					
					if Player.leaderstats.Cash.Value >= Quantity * AppleBox.Price.Value then
						
						replicated.UpdateStats:FireServer("Apples", Quantity)
						replicated.UpdateStats:FireServer("Cash", -(Quantity * AppleBox.Price.Value))
						MarketStand.BoughtSound:Play()
						BuyCD = false
						
						
					elseif Player.leaderstats.Cash.Value <= Quantity * AppleBox.Price.Value then
						
						
						BuyCD = true
						script.Parent.AppleGUI.AppleBuy.Text = "You don't have enough money!"
						MarketStand.ErrorSound:Play()
						task.wait(1.5)
						script.Parent.AppleGUI.AppleBuy.Text = "Buy"
						BuyCD = false
						
						
					end
				
				elseif script.Parent.AppleGUI.AppleQuantity.Text == "" then
					
					script.Parent.AppleGUI.AppleQuantity.Text = 1
					Quantity = 1
					
					if Player.leaderstats.Cash.Value >= Quantity * AppleBox.Price.Value then

						replicated.UpdateStats:FireServer("Apples", Quantity)
						replicated.UpdateStats:FireServer("Cash", -(Quantity * AppleBox.Price.Value))
						MarketStand.BoughtSound:Play()
						BuyCD = false


					elseif Player.leaderstats.Cash.Value <= Quantity * AppleBox.Price.Value then


						BuyCD = true
						script.Parent.AppleGUI.AppleBuy.Text = "You don't have enough money!"
						MarketStand.ErrorSound:Play()
						task.wait(1.5)
						script.Parent.AppleGUI.AppleBuy.Text = "Buy"
						BuyCD = false


					end
					
				else
					
					BuyCD = true
					script.Parent.AppleGUI.AppleBuy.Text = "That isn't a valid quantity!"
					MarketStand.ErrorSound:Play()
					task.wait(1.5)
					script.Parent.AppleGUI.AppleBuy.Text = "Buy"
					BuyCD = false
					
					
				end
				
			end)
			
		end)
		
		PumpkinsConnection = PumkinHitbox.ClickDetector.MouseClick:Connect(function()
			
			if Camera.CFrame ~= CameraPart.CFrame then return end
			
			Highlight1.Adornee = nil
			Highlight2.Adornee = nil
			Highlight3.Adornee = nil

			Highlight1.Enabled = false
			Highlight2.Enabled = false
			Highlight3.Enabled = false

			Tw:Create(Camera, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = PumkinHitbox.ClickDetector.CameraForPumpkin.CFrame}):Play()
			State = "Transitioning"
			
			AppleBox.ForBillboard.BillboardGui.Enabled = false
			LemonBox.ForBillboard.BillboardGui.Enabled = false
			PumkinBox.ForBillboard.BillboardGui.TextLabel.Text = "5$ = 1 Pumpkin"
			
			task.wait(0.7)
			
			State = nil
			
			script.Parent.Enabled = true
			script.Parent.PumpkinGUI.PumpkinQuantity.Text = 1
			
			Tw:Create(script.Parent.PumpkinGUI, TweenInfo.new(0.5), {GroupTransparency = 0}):Play()

			task.wait(0.5)

			local BuyCD = false

			BuyConnections.BuyPumpkinsConnection = script.Parent.PumpkinGUI.PumpkinBuy.MouseButton1Click:Connect(function()

				if BuyCD then return end
				
				BuyCD = true
				

				local Quantity = tonumber(script.Parent.PumpkinGUI.PumpkinQuantity.Text)

				if Quantity then

					if Player.leaderstats.Cash.Value >= Quantity * PumkinBox.Price.Value then

						replicated.UpdateStats:FireServer("Pumpkins", Quantity)
						replicated.UpdateStats:FireServer("Cash", -(Quantity * PumkinBox.Price.Value))
						MarketStand.BoughtSound:Play()
						task.wait(0.7)
						BuyCD = false

					else

						BuyCD = true
						script.Parent.PumpkinGUI.PumpkinBuy.Text = "You don't have enough money!"
						MarketStand.ErrorSound:Play()
						task.wait(1.5)
						script.Parent.PumpkinGUI.PumpkinBuy.Text = "Buy"
						BuyCD = false

					end
					
				elseif 	script.Parent.PumpkinGUI.PumpkinQuantity.Text == "" then
					
					script.Parent.PumpkinGUI.PumpkinQuantity.Text = 1
					Quantity = 1


					if Player.leaderstats.Cash.Value >= Quantity * PumkinBox.Price.Value then

						replicated.UpdateStats:FireServer("Pumpkins", Quantity)
						replicated.UpdateStats:FireServer("Cash", -(Quantity * PumkinBox.Price.Value))
						MarketStand.BoughtSound:Play()
						task.wait(0.7)
						BuyCD = false

					else

						BuyCD = true
						script.Parent.PumpkinGUI.PumpkinBuy.Text = "You don't have enough money!"
						MarketStand.ErrorSound:Play()
						task.wait(1.5)
						script.Parent.PumpkinGUI.PumpkinBuy.Text = "Buy"
						BuyCD = false

					end

				else

					BuyCD = true
					script.Parent.PumpkinGUI.PumpkinBuy.Text = "That isn't a valid quantity!"
					MarketStand.ErrorSound:Play()
					task.wait(1.5)
					script.Parent.PumpkinGUI.PumpkinBuy.Text = "Buy"
					BuyCD = false

				end

			end)
			
		end)
		
		LemonsConnection = LemonHitbox.ClickDetector.MouseClick:Connect(function()
			
			if Camera.CFrame ~= CameraPart.CFrame then return end
			
			Highlight1.Adornee = nil
			Highlight2.Adornee = nil
			Highlight3.Adornee = nil

			Highlight1.Enabled = false
			Highlight2.Enabled = false
			Highlight3.Enabled = false

			Tw:Create(Camera, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = LemonHitbox.ClickDetector.CameraForLemons.CFrame}):Play()
			State = "Transitioning"
			
			AppleBox.ForBillboard.BillboardGui.Enabled = false
			LemonBox.ForBillboard.BillboardGui.TextLabel.Text = "3$ = 1 Lemon"
			PumkinBox.ForBillboard.BillboardGui.Enabled = false
			
			task.wait(0.7)
			
			State = nil

			script.Parent.Enabled = true
			script.Parent.LemonGUI.LemonQuantity.Text = 1
			
			Tw:Create(script.Parent.LemonGUI, TweenInfo.new(0.5), {GroupTransparency = 0}):Play()

			task.wait(0.5)

			local BuyCD = false
			
			BuyConnections.BuyLemonsConnection = script.Parent.LemonGUI.LemonBuy.MouseButton1Click:Connect(function()

				if BuyCD then return end
				
				BuyCD = true
				

				local Quantity = tonumber(script.Parent.LemonGUI.LemonQuantity.Text)

				if Quantity then

					if Player.leaderstats.Cash.Value >= Quantity * LemonBox.Price.Value then
					

						replicated.UpdateStats:FireServer("Lemons", Quantity)
						replicated.UpdateStats:FireServer("Cash", -(Quantity * LemonBox.Price.Value))
						MarketStand.BoughtSound:Play()
						task.wait(0.7)
						BuyCD = false

					else

						BuyCD = true
						script.Parent.LemonGUI.LemonBuy.Text = "You don't have enough money!"
						MarketStand.ErrorSound:Play()
						task.wait(1.5)
						script.Parent.LemonGUI.LemonBuy.Text = "Buy"
						BuyCD = false

					end
					
				elseif script.Parent.LemonGUI.LemonQuantity.Text == "" then
					script.Parent.LemonGUI.LemonQuantity.Text = 1
					
					Quantity = 1
					
					if Player.leaderstats.Cash.Value >= Quantity * LemonBox.Price.Value then


						replicated.UpdateStats:FireServer("Lemons", Quantity)
						replicated.UpdateStats:FireServer("Cash", -(Quantity * LemonBox.Price.Value))
						MarketStand.BoughtSound:Play()
						task.wait(0.7)
						BuyCD = false

					else

						BuyCD = true
						script.Parent.LemonGUI.LemonBuy.Text = "You don't have enough money!"
						MarketStand.ErrorSound:Play()
						task.wait(1.5)
						script.Parent.LemonGUI.LemonBuy.Text = "Buy"
						BuyCD = false

					end

				else

					BuyCD = true
					script.Parent.LemonGUI.LemonBuy.Text = "That isn't a valid quantity!"
					MarketStand.ErrorSound:Play()
					task.wait(1.5)
					script.Parent.LemonGUI.LemonBuy.Text = "Buy"
					BuyCD = false

				end

			end)
			
		end)
		
		script.Parent.ShopBack.MouseButton1Click:Connect(function()
			
			if State == "Transitioning" then return end

			if Camera.CFrame ~= CameraPart.CFrame then

				Tw:Create(Camera, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CameraPart.CFrame}):Play()
				State = "Transitioning"
				
				for i, connection in pairs(BuyConnections) do
					if connection then
						connection:Disconnect()
					end
				end
				
				AppleBox.ForBillboard.BillboardGui.TextLabel.Text = "Apple"
				LemonBox.ForBillboard.BillboardGui.TextLabel.Text = "Lemon"
				PumkinBox.ForBillboard.BillboardGui.TextLabel.Text = "Pumpkin"
				
				AppleBox.ForBillboard.BillboardGui.Enabled = true
				LemonBox.ForBillboard.BillboardGui.Enabled = true
				PumkinBox.ForBillboard.BillboardGui.Enabled = true
				
				Tw:Create(script.Parent.AppleGUI, TweenInfo.new(0.5), {GroupTransparency = 1}):Play()
				Tw:Create(script.Parent.LemonGUI, TweenInfo.new(0.5), {GroupTransparency = 1}):Play()
				Tw:Create(script.Parent.PumpkinGUI, TweenInfo.new(0.5), {GroupTransparency = 1}):Play()
				
				
				task.wait(0.7)
				
				script.Parent.AppleGUI.AppleQuantity.Text = 1
				script.Parent.LemonGUI.LemonQuantity.Text = 1
				script.Parent.PumpkinGUI.PumpkinQuantity.Text = 1
				
				State = nil

			else

				HighlightConnection:Disconnect()
				ApplesConnection:Disconnect()
				LemonsConnection:Disconnect()
				PumpkinsConnection:Disconnect()
				for i, connection in pairs(BuyConnections) do
					if connection then
						connection:Disconnect()
					end
				end

				Camera.CameraType = Enum.CameraType.Custom
				Character.HumanoidRootPart.Anchored = false
				
				script.Parent.Enabled = false
				Tw:Create(script.Parent.AppleGUI, TweenInfo.new(0.5), {GroupTransparency = 1}):Play()
				script.Parent.AppleGUI.AppleQuantity.Text = 1
				Tw:Create(script.Parent.LemonGUI, TweenInfo.new(0.5), {GroupTransparency = 1}):Play()
				script.Parent.LemonGUI.LemonQuantity.Text = 1
				Tw:Create(script.Parent.PumpkinGUI, TweenInfo.new(0.5), {GroupTransparency = 1}):Play()
				script.Parent.PumpkinGUI.PumpkinQuantity.Text = 1
				
				AppleBox.ForBillboard.BillboardGui.TextLabel.Text = "Apple"
				LemonBox.ForBillboard.BillboardGui.TextLabel.Text = "Lemon"
				PumkinBox.ForBillboard.BillboardGui.TextLabel.Text = "Pumpkin"

				AppleBox.ForBillboard.BillboardGui.Enabled = false
				LemonBox.ForBillboard.BillboardGui.Enabled = false
				PumkinBox.ForBillboard.BillboardGui.Enabled = false

				Proximity.Enabled = true

			end

		end)
		
	end
	
end)