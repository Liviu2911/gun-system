local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local state = require(ReplicatedStorage.Shared.Weapons.state)
local AmmoButton: TextButton = Players.LocalPlayer.PlayerGui:WaitForChild("Ammo").AddAmmo

AmmoButton.MouseButton1Click:Connect(function()
    state.GetAmmos():AddAmmo(16)
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.R then
        local ammo = state.GetAmmos()
        if ammo then 
            ammo:Reload()
        end
    end
end)