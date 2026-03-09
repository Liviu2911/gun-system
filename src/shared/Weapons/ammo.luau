local Players = game:GetService("Players")
local CurrentAmmo = Players.LocalPlayer.PlayerGui.Ammo.CurrentAmmo

local module = {}
module.__index = module

function module.new(startingAmmo: number, MagazineSize: number)
    local self = setmetatable({}, module)

    if startingAmmo >= MagazineSize then
        self.CurrentMagazine = MagazineSize
    else
        self.CurrentMagazine = startingAmmo % MagazineSize
    end

    self.Ammos = startingAmmo 
    self.MagazineSize = MagazineSize
    self.isReloading = false

    return self
end

function UpdateUi(self)
    CurrentAmmo.Text = "Reload..."
    self.isReloading = true
    task.wait(2)
    self.isReloading = false
    CurrentAmmo.Text = self.CurrentMagazine.."/"..self.MagazineSize

end

function module:Reload()
    if self.isReloading then return end
    if self.Ammos <= self.MagazineSize then
        if self.CurrentMagazine < self.Ammos then
            print(self.Ammos)
            self.CurrentMagazine = self.Ammos
            UpdateUi(self)
            return
        else
            return
        end
    end

    self.CurrentMagazine = self.MagazineSize
    UpdateUi(self)
end

function module:Shoot()
    if self.isReloading then return end
    if self.CurrentMagazine > 0 then
        self.CurrentMagazine -= 1
        self.Ammos -= 1
        CurrentAmmo.Text = self.CurrentMagazine.."/"..self.MagazineSize
    end
end

function module:AddAmmo(value: number)
    self.Ammos += value
end

return module