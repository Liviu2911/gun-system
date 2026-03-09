local weapon: Tool = script.Parent
local player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local FireSound: Sound = script.Parent.FireSound
FireSound.Volume = 0.2

local DISTANCE = 50

-- used when weapon fires
function Fire(shooter, weaponPosition: Vector3, destination, damage)
    -- calculate positions
    local origin = weaponPosition
    local direction = (destination - origin).Unit * DISTANCE

    -- set up raycast
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { shooter, weapon }

    local raycast = workspace:Raycast(origin, direction, params)

    if raycast then
        -- try to find the character after shooting
        local target = raycast.Instance
        local character = target:FindFirstAncestorOfClass("Model")
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:TakeDamage(tonumber(damage))
            end
        end
    end
end

return Fire

-- helper function to enter first person on aiming
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
    -- checks if user is aiming
    uis.InputBegan:Connect(function(input)
        -- change to first person
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            setCameraMode(true)
        end
    end)

    uis.InputEnded:Connect(function(input)
        -- exit first person
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            setCameraMode(false)
        end
    end)
end)

-- play vfx when shooting
weapon.Activated:Connect(function()
    local handle = weapon:FindFirstChild("Handle") :: BasePart
    FireSound:Play()
    local damage = script.Parent.Damage.Value
    fire(player.Character, handle.Position, player:GetMouse().Hit.Position, damage)
end)
