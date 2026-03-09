local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Crosshair = Players.LocalPlayer.PlayerGui:WaitForChild("Crosshair").Frame
local Ammo = Players.LocalPlayer.PlayerGui:WaitForChild("Ammo"):WaitForChild("CurrentAmmo")
local ammo = require(ReplicatedStorage.Shared.Weapons.ammo)

local module = {}

local ammos = {}
local currentAmmo = nil

function module.OpenCrosshair()
    Crosshair.Visible = true
end

function module.CloseCrosshair()
    Crosshair.Visible = false
end

function module.ChangeAmmo(name: string, ammo: number, magazineSize: number)
    Ammo.Text = ammo.."/"..magazineSize
    currentAmmo = ammos[name]
end

function module.InitAmmo(name: string, MagazineSize: number)
    local newAmmo = ammo.new(16, MagazineSize)
    ammos[name] = newAmmo
end

function module.GetAmmos(name: string?)
    return ammos[name] or currentAmmo
end

return module