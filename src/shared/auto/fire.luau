local weapon = script.Parent.Parent

function Fire(player: Player, weaponPosition: Vector3)
    local mouse = player:GetMouse().Hit.Position
    local origin = weaponPosition
    local direction = (mouse - origin).Unit * 50
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { player.Character, weapon }

    local raycast = workspace:Raycast(origin, direction, params)

    if raycast then
        local target = raycast.Instance
        local humanoid: Humanoid = target.Parent:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:TakeDamage(10)
        end

    end
end

return Fire