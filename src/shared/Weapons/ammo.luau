local ReplicatedStorage = game:GetService("ReplicatedStorage")
local updateUiEvent = ReplicatedStorage.Events.UpdateUi

local module = {}
module.__index = module

function module.new(startingAmmo: number, MagazineSize: number, name: string)
    local self = setmetatable({}, module)

    if startingAmmo >= MagazineSize then
        self.CurrentMagazine = MagazineSize
    else
        self.CurrentMagazine = startingAmmo % MagazineSize
    end

    self.Ammos = startingAmmo 
    self.MagazineSize = MagazineSize
    self.isReloading = false
    self.Name = name

    return self
end

function module:Equip()
    updateUiEvent:Fire(self.Name, self.isReloading and "Reload..." or self.CurrentMagazine.."/"..self.MagazineSize)
end

function UpdateUi(self)
    updateUiEvent:Fire(self.Name, "Reload...")
    self.isReloading = true
    task.wait(4)
    self.isReloading = false
    updateUiEvent:Fire(self.Name, self.CurrentMagazine.."/"..self.MagazineSize)
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
    if self.isReloading then return false end
    if self.CurrentMagazine > 0 then
        self.CurrentMagazine -= 1
        self.Ammos -= 1
        updateUiEvent:Fire(self.Name, self.CurrentMagazine.."/"..self.MagazineSize)
        return true
    end
    return false
end

function module:AddAmmo(value: number)
    self.Ammos += value
end

return module