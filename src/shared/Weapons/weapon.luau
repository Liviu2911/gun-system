local module = {}
module.__index = {}

function module.new(name: string, fireType: "auto" | "manual")
    local self = setmetatable({}, module)

    self.Ammos = 0
    self.CurrentMagazine = 0
    self.isReloading = false

    return self
end

return module