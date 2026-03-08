local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPack = game:GetService("StarterPack")
local Assets = ReplicatedStorage.Assets

local Gun: Tool = Assets.Weapons.Gun
local GunScript = ReplicatedStorage.Guns
local AutoScript = ReplicatedStorage.Auto

game:GetService("Players").PlayerAdded:Connect(function(player: Player)
    for _, weapon in pairs(Assets.Weapons:GetChildren()) do
        if weapon.Name == "Gun" then
            local CopyScript = GunScript:Clone()
            CopyScript.Parent = weapon
        else
            local CopyScript = AutoScript:Clone()
            CopyScript.Parent = weapon
        end

        local newWeapon = Assets.Weapons[weapon.Name]:Clone()
        newWeapon.Parent = StarterPack
    end
end)