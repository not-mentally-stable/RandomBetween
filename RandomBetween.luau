_G.RandomBetween = function(a, b, step)
    local rng = Random.new()

    local function numbersAreWhole(x, y)
        return x % 1 == 0 and y % 1 == 0
    end

    local function steppedNumber(minVal, maxVal)
        if step and step > 0 then
            local steps = math.floor((maxVal - minVal) / step + 0.5)
            local choice = rng:NextInteger(0, steps)
            return minVal + choice * step
        else
            return rng:NextNumber(minVal, maxVal)
        end
    end

    if typeof(a) == "number" and typeof(b) == "number" then
        if numbersAreWhole(a, b) and not step then
            return rng:NextInteger(math.min(a, b), math.max(a, b))
        else
            return steppedNumber(math.min(a, b), math.max(a, b))
        end
    end

    if typeof(a) == "Vector3" and typeof(b) == "Vector3" then
        return Vector3.new(
            steppedNumber(math.min(a.X, b.X), math.max(a.X, b.X)),
            steppedNumber(math.min(a.Y, b.Y), math.max(a.Y, b.Y)),
            steppedNumber(math.min(a.Z, b.Z), math.max(a.Z, b.Z))
        )
    end

    if typeof(a) == "Color3" and typeof(b) == "Color3" then
        return Color3.new(
            steppedNumber(math.min(a.R, b.R), math.max(a.R, b.R)),
            steppedNumber(math.min(a.G, b.G), math.max(a.G, b.G)),
            steppedNumber(math.min(a.B, b.B), math.max(a.B, b.B))
        )
    end

    if typeof(a) == "CFrame" and typeof(b) == "CFrame" then
        local p1, p2 = a.Position, b.Position
        return CFrame.new(
            steppedNumber(math.min(p1.X, p2.X), math.max(p1.X, p2.X)),
            steppedNumber(math.min(p1.Y, p2.Y), math.max(p1.Y, p2.Y)),
            steppedNumber(math.min(p1.Z, p2.Z), math.max(p1.Z, p2.Z))
        )
    end

    if typeof(a) == "UDim2" and typeof(b) == "UDim2" then
        return UDim2.new(
            steppedNumber(math.min(a.X.Scale, b.X.Scale), math.max(a.X.Scale, b.X.Scale)),
            steppedNumber(math.min(a.X.Offset, b.X.Offset), math.max(a.X.Offset, b.X.Offset)),
            steppedNumber(math.min(a.Y.Scale, b.Y.Scale), math.max(a.Y.Scale, b.Y.Scale)),
            steppedNumber(math.min(a.Y.Offset, b.Y.Offset), math.max(a.Y.Offset, b.Y.Offset))
        )
    end

    if typeof(a) == "BrickColor" and typeof(b) == "BrickColor" then
        local minId, maxId = math.min(a.Number, b.Number), math.max(a.Number, b.Number)
        return BrickColor.new(rng:NextInteger(minId, maxId))
    end

    if typeof(a) == "boolean" and typeof(b) == "boolean" then
        if a == b then return a end
        return rng:NextInteger(0, 1) == 1
    end

    error(`Unsupported type: {typeof(a)}`)
end
