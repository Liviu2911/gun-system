local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Crosshair = Players.LocalPlayer.PlayerGui:WaitForChild("Crosshair").Frame
local Ammo = Players.LocalPlayer.PlayerGui:WaitForChild("Ammo"):WaitForChild("CurrentAmmo")
local ammo = require(ReplicatedStorage.Shared.Weapons.ammo)

local module = {}

local ammos: {
    [string]: {
        Ammo: typeof(ammo),
        active: true?,
    }
} = {}

local crosshair = false

function module.OpenCrosshair()
    Crosshair.Visible = true
    crosshair = true
end

function module.CloseCrosshair()
    crosshair = false
    task.delay(0.5, function() 
        print(crosshair)
        if not crosshair then Crosshair.Visible = false end
    end)
end

function module.ChangeAmmo(name: string, newVal: string)
    if ammos[name].active then
        Ammo.Text = newVal
    end
end

function module.ChangeWeapon(name: string?)
    for _, ammo in ammos do
        ammo.active = false
    end
    if name ~= nil then 
        ammos[name].active = true
        ammos[name].Ammo:Equip()
     end
end

function module.GetAmmo(name: string?)
    if name then return ammos[name].Ammo end
    for _, ammo in ammos do
        if ammo.active then
            print(ammo)
            return ammo.Ammo
        end
    end
    return nil
end

function module.InitAmmo(name: string, MagazineSize: number, initVal: string)
    local newAmmo = ammo.new(16, MagazineSize, name)
    ammos[name] = {
        Ammo = nil
    }
    ammos[name].Ammo = newAmmo
    Ammo.Text = initVal
end

return module