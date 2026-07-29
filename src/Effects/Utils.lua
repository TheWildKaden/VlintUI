return function(require)
    local Creator = require("Core.Creator")
    local Theme = require("Core.Theme")

    local Utils = {}
    Utils.__index = Utils

    local DEFAULT_CORNER = UDim.new(0, 14)

    function Utils.AddCorner(parent, radius)
        return Creator.Create("UICorner", {
            Parent = parent,
            CornerRadius = radius or DEFAULT_CORNER,
        })
    end

    function Utils.AddStroke(parent, thickness, color)
        return Creator.Create("UIStroke", {
            Parent = parent,
            Thickness = thickness or 1,
            Color = color or Theme.Get().Border,
            LineJoinMode = Enum.LineJoinMode.Round,
            Transparency = 0.35,
        })
    end

    function Utils.AddGradient(parent, accent)
        return Creator.Create("UIGradient", {
            Parent = parent,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, accent or Theme.Get().GradientAccent),
                ColorSequenceKeypoint.new(1, Theme.Get().Surface),
            }),
            Rotation = 90,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.85),
                NumberSequenceKeypoint.new(1, 0.95),
            }),
            Offset = Vector2.new(0, 0.15),
        })
    end

    function Utils.AddNoise(parent)
        local image = Creator.Create("ImageLabel", {
            Parent = parent,
            Name = "NoiseOverlay",
            Size = UDim2.fromScale(1, 1),
            Position = UDim2.fromScale(0, 0),
            BackgroundTransparency = 1,
            Image = "rbxassetid://12175030056",
            ImageColor3 = Color3.new(1, 1, 1),
            ImageTransparency = 0.88,
            ScaleType = Enum.ScaleType.Tile,
            SliceCenter = Rect.new(0, 0, 0, 0),
        })

        Creator.Create("UIAspectRatioConstraint", {
            Parent = image,
            AspectRatio = 1,
        })

        return image
    end

    function Utils.ApplyAcrylicStyle(frame)
        if not frame or not frame:IsA("GuiObject") then
            return
        end

        frame.BackgroundColor3 = Theme.Get().Surface
        frame.BackgroundTransparency = 0.12
        frame.BorderSizePixel = 0

        Utils.AddCorner(frame, UDim.new(0, 18))
        Utils.AddStroke(frame, 1, Theme.Get().Border)
        Utils.AddGradient(frame)
        Utils.AddNoise(frame)
    end

    return Utils
end
