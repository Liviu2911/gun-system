local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer.PlayerGui

local AmmoScreen = Instance.new("ScreenGui")
AmmoScreen.Parent = PlayerGui
AmmoScreen.Name = "Ammo"

local CurrentAmmo = Instance.new("TextLabel")
CurrentAmmo.Parent = AmmoScreen
CurrentAmmo.Position = UDim2.fromScale(0.95, 0.95)
CurrentAmmo.Name = "CurrentAmmo"
CurrentAmmo.Text = "0/0"
CurrentAmmo.BackgroundTransparency = 1
CurrentAmmo.TextColor3 = Color3.fromRGB(255, 255, 255)
CurrentAmmo.TextSize = 20
CurrentAmmo.Font = Enum.Font.Cartoon

local AddAmmo = Instance.new("TextButton")
AddAmmo.Parent = AmmoScreen
AddAmmo.Name = "AddAmmo"
AddAmmo.Position = UDim2.fromScale(0.8, 0.9)
AddAmmo.Text = "Add Ammo"
AddAmmo.Font = Enum.Font.Cartoon
AddAmmo.TextSize = 24
AddAmmo.ZIndex = 10
AddAmmo.Size = UDim2.fromScale(0.08, 0.08)