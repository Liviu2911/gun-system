local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UpdateUi: BindableEvent = ReplicatedStorage.Events.UpdateUi
local UserInputService = game:GetService("UserInputService")
local state = require(ReplicatedStorage.Shared.Weapons.state)
local AmmoButton: TextButton = Players.LocalPlayer.PlayerGui:WaitForChild("Ammo").AddAmmo

AmmoButton.MouseButton1Click:Connect(function()
    state.GetAmmo():AddAmmo(16)
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.R then
        local ammo = state.GetAmmo()
        if ammo then 
            print(ammo)
            ammo:Reload()
        end
    end
end)

UpdateUi.Event:Connect(function(name: string, newVal: string)
    state.ChangeAmmo(name, newVal)
end)