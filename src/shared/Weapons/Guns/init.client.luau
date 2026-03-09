local weapon: Tool = script.Parent
local player = game:GetService("Players").LocalPlayer
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local uis = game:GetService("UserInputService")
local hit = ReplicatedStorage.Assets.Hit
local FireSound: Sound = script.Parent.FireSound
FireSound.Volume = 0.2

-- max distance the bullet can reach
local DISTANCE = 50

-- Starting values of the gun
local Damage = script.parent.Damage.Value
local Ammo = script.Parent.Ammo
local MagazineSize = script.Parent.Magazine.Value
local CurrentMagazine = if Ammo.Value >= MagazineSize then MagazineSize else Ammo.Value 
local isReloading = false
local isEquipped = false

-- ammo ui
local GunUi = Instance.new("ScreenGui")
GunUi.Parent = player.PlayerGui
GunUi.Name = "GunUi"
GunUi.IgnoreGuiInset = true

local CurrentAmmo = Instance.new("TextLabel")
CurrentAmmo.Parent = GunUi
CurrentAmmo.Name = "CurrentAmmo"
CurrentAmmo.Text = CurrentMagazine.."/"..MagazineSize
CurrentAmmo.TextSize = 48
CurrentAmmo.TextColor3 = Color3.fromRGB(255, 255, 255)
CurrentAmmo.Font = Enum.Font.Cartoon
CurrentAmmo.Position = UDim2.fromScale(0.85, 0.85)
CurrentAmmo.Visible = false

local Crosshair = Instance.new("TextLabel")
Crosshair.Parent = GunUi
Crosshair.Text = "+"
Crosshair.TextSize = 24
Crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
Crosshair.TextColor3 = Color3.fromRGB(255, 255, 255)
Crosshair.Visible = false

-- used when weapon fires
function Fire(shooter, weaponPosition: Vector3, destination)
    -- update ammo
    Ammo.Value -= 1
    CurrentMagazine -= 1
    CurrentAmmo.Text = CurrentMagazine.."/"..MagazineSize

    -- calculate positions
    local origin = weaponPosition
    local direction = (destination - origin).Unit * DISTANCE

    -- set up raycast
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { shooter, weapon }

    -- camera shake
    local shakeIntensity = 0.25

    -- random shake every frame
    local shake = RunService.RenderStepped:Connect(function()
        if shakeIntensity > 0.1 then
            local x = math.random(-100, 100) / 100 * shakeIntensity
            local y = math.random(-100, 100) / 100 * shakeIntensity
            local z = math.random(-100, 100) / 100 * shakeIntensity
            
            workspace.CurrentCamera.CFrame *= CFrame.Angles(math.rad(x), math.rad(y), math.rad(z))
        else
            shakeIntensity = 0
        end
    end)
    -- erase the effect
    task.delay(.25, function()
        shake:Disconnect()
    end)

    local raycast = workspace:Raycast(origin, direction, params)

    if raycast then
        -- try to find the character after shooting
        local target = raycast.Instance
        local character = target:FindFirstAncestorOfClass("Model")
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                -- add a hit mark on player hit
                local newHit = hit:Clone()
                local vector = workspace.CurrentCamera:WorldToScreenPoint(target.Position)
                newHit.Parent = GunUi
                newHit.Position = UDim2.fromOffset(vector.X - 10, vector.Y + 50)
                Debris:AddItem(newHit, 0.25)

                -- damage the other player
                humanoid:TakeDamage(Damage)
            end
        end
    end
end

-- helper function to reload
function Reload()
    if CurrentMagazine == MagazineSize or Ammo.Value == CurrentMagazine then return end
    isReloading = true
    CurrentAmmo.Text = "Reload..."
    task.delay(2, function()
        isReloading = false
        CurrentMagazine = if Ammo.Value >= MagazineSize then MagazineSize else Ammo.Value
        CurrentAmmo.Text = CurrentMagazine.."/"..MagazineSize
    end)
end

-- helper function to enter first person on aiming
function setCameraMode(isAiming)
    if not isEquipped then return end
    local targetMode = isAiming and Enum.CameraMode.LockFirstPerson or Enum.CameraMode.Classic
    
    uis.MouseIconEnabled = not isAiming
    Crosshair.Visible = isAiming

    player.CameraMode = targetMode
    player.CameraMinZoomDistance = 10
    task.delay(0.25, function()
        player.CameraMinZoomDistance = 0
    end)
end

weapon.Equipped:Connect(function()  
    -- enters first person
    uis.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            setCameraMode(true)
        end
    end)

    -- exits first person
    uis.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            setCameraMode(false)
        end
    end)
end)

-- wepaon shoots 
weapon.Activated:Connect(function()
    if Ammo.Value <= 0 or isReloading then return end
    -- checks if reloading is needed or ongoing
    if CurrentMagazine <= 0 then
        Reload()
    elseif not isReloading and Ammo.Value > 0 then
        local handle = weapon:FindFirstChild("Handle") :: BasePart
        FireSound:Play()
        Fire(player.Character, handle.Position, player:GetMouse().Hit.Position)
        task.wait(.25) -- cooldown so the player can't spam
    end
end)

-- toggle ammo visibility
weapon.Equipped:Connect(function()
    CurrentAmmo.Visible = true
    isEquipped = true
end)

weapon.Unequipped:Connect(function()
    CurrentAmmo.Visible = false
    isEquipped = false
end)

-- reload when player presses R
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.R then
        Reload()
    end
end)
