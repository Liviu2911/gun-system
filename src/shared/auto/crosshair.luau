local module = {}
module.__index = module

-- Creating the crosshair
function module.new(player: Player)
    local self = setmetatable({}, module)
    
    local CrosshairScreen = Instance.new("ScreenGui")
    CrosshairScreen.Parent = player.PlayerGui
    CrosshairScreen.IgnoreGuiInset = true

    local CrosshairContainer = Instance.new("Frame")
    CrosshairContainer.Parent = CrosshairScreen
    CrosshairContainer.Size = UDim2.fromScale(1, 1)
    CrosshairContainer.BackgroundTransparency = 1
    CrosshairContainer.Visible = false
    local UiList = Instance.new("UIListLayout")
    UiList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UiList.VerticalAlignment = Enum.VerticalAlignment.Center
    UiList.Parent = CrosshairContainer

    local Crosshair = Instance.new("TextLabel")
    Crosshair.Name = "Crosshair"
    Crosshair.Parent = CrosshairContainer
    Crosshair.Size = UDim2.fromOffset(25, 25)
    Crosshair.BackgroundTransparency = 1
    Crosshair.Text = "+"
    Crosshair.TextSize = 32
    Crosshair.TextColor3 = Color3.fromRGB(255, 255, 255)

    self.Crosshair = CrosshairContainer
    self.Player = player

    return self
end

function module:ActivateCrosshair()
    self.Crosshair.Visible = true
end

function module:DeactivateCrosshair()
    self.Crosshair.Visible = false 
end

return module