local weapon = script.Parent.Parent

function Fire(shooter, weaponPosition: Vector3, destination)
    local origin = weaponPosition
    local direction = (destination - origin).Unit * 50
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { shooter, weapon }

    local raycast = workspace:Raycast(origin, direction, params)

    if raycast then
        local target = raycast.Instance
        local character = target:FindFirstAncestorOfClass("Model")
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:TakeDamage(0)
            end
        end
    end
end

return Fire