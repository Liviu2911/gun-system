local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = ReplicatedStorage.Assets

local Gun: Tool = Assets.Weapons.Gun
local WeaponScript = ReplicatedStorage.Weapons

game:GetService("Players").PlayerAdded:Connect(function(player: Player)
    local NewGun = Gun:Clone()
    NewGun.Parent = game:GetService("StarterPack")
end)

for _, weapon in pairs(Assets.Weapons:GetChildren()) do
    local CopyScript = WeaponScript:Clone()
    CopyScript.Parent = weapon
end