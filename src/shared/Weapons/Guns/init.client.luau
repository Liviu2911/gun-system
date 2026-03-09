local weapon: Tool = script.Parent
local player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local FireSound: Sound = script.Parent.FireSound
FireSound.Volume = 0.2

local state = require(ReplicatedStorage.Shared.Weapons.state)
local fire = require(ReplicatedStorage.Shared.Weapons.fire)
local MagazineSize = script.Parent.Magazine.Value
state.InitAmmo("gun", MagazineSize)
local Ammo = state.GetAmmos("gun")

local function setCameraMode(isAiming)
    local targetMode = isAiming and Enum.CameraMode.LockFirstPerson or Enum.CameraMode.Classic
    
    uis.MouseIconEnabled = not isAiming

    player.CameraMode = targetMode
    player.CameraMinZoomDistance = 10
    task.delay(0.25, function()
        player.CameraMinZoomDistance = 0
    end)
end

weapon.Equipped:Connect(function()  
    state.ChangeAmmo("gun", Ammo.CurrentMagazine, MagazineSize)
    uis.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            setCameraMode(true)
            state.OpenCrosshair()
        end
    end)

    uis.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            setCameraMode(false)
            state.CloseCrosshair()
        end
    end)
end)

weapon.Activated:Connect(function()
    local handle = weapon:FindFirstChild("Handle") :: BasePart
    FireSound:Play()
    fire(player.Character, handle.Position, player:GetMouse().Hit.Position)
    Ammo:Shoot()
end)

weapon.Unequipped:Connect(function()
    state.CloseCrosshair()
    state.ChangeAmmo("gun", 0, 0)
end)