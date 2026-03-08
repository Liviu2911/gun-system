local weapon: Tool = script.Parent
local player = game:GetService("Players").LocalPlayer
local uis = game:GetService("UserInputService")

local crosshair = require(script.crosshair)

local Crosshair = crosshair.new(player)

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
    
    player.CameraMode = targetMode
    player.CameraMinZoomDistance = 10
    task.delay(0.25, function()
        player.CameraMinZoomDistance = 0
    end)
end

weapon.Equipped:Connect(function()
    cleanup()
    table.insert(connections, uis.InputBegan:Connect(function(input: InputObject)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            setCameraMode(true)
            Crosshair:ActivateCrosshair()
        end
    end))

    table.insert(connections, uis.InputEnded:Connect(function(input: InputObject)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            setCameraMode(false)
            Crosshair:DeactivateCrosshair()
        end
    end))
end)

weapon.Unequipped:Connect(function()
    Crosshair:DeactivateCrosshair()
    cleanup()
end)