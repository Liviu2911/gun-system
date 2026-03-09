local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPack = game:GetService("StarterPack")
local Assets = ReplicatedStorage.Assets

local GunScript = ReplicatedStorage.Shared.Weapons.Guns
local AutoScript = ReplicatedStorage.Shared.Weapons.Auto

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

local Enemies = workspace.Enemies:GetChildren()
local EnemyScript = ReplicatedStorage.Shared.Enemy

task.spawn(function()
    for _, enemy in Enemies do
        local ScriptCopy = EnemyScript:Clone()
        ScriptCopy.Parent = enemy

        local root = enemy:FindFirstChild("HumanoidRootPart")
        if root and root:IsA("BasePart") then
            root:SetNetworkOwner(nil) 
        end
    end
end)
