local weapon: Tool = script.Parent
local player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local FireSound: Sound = script.Parent.FireSound
FireSound.Volume = 0.2

local state = require(ReplicatedStorage.Shared.Weapons.state)
local fire = require(ReplicatedStorage.Shared.Weapons.fire)
local MagazineSize = script.Parent.Magazine.Value
state.InitAmmo("auto", MagazineSize)
local Ammo = state.GetAmmos("auto")

local connections = {}

function cleanup()
    for _, conn in connections do
        conn:Disconnect()
    end

    table.clear(connections)
    player.CameraMode = Enum.CameraMode.Classic
    workspace.Camera.FieldOfView = 70
end

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
    cleanup()
    state.ChangeAmmo("auto", Ammo.CurrentMagazine, MagazineSize)
    table.insert(connections, uis.InputBegan:Connect(function(input: InputObject)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            setCameraMode(true)
            state.OpenCrosshair()
        end
    end))

    table.insert(connections, uis.InputEnded:Connect(function(input: InputObject)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            setCameraMode(false)
            state.CloseCrosshair()
        end
    end))
end)

weapon.Activated:Connect(function() 
    local handle = weapon:FindFirstChild("Handle") :: BasePart
    task.spawn(function()
        while uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
            local damage = script.Parent.Damage.Value
            fire(player.Character, handle.Position, player:GetMouse().Hit.Position, damage)
            FireSound:Play()
            Ammo:Shoot()
            task.wait(0.1)
        end
    end)
end)

weapon.Unequipped:Connect(function()
    state.CloseCrosshair()
    cleanup()
    state.ChangeAmmo("auto", 0, 0)
end)