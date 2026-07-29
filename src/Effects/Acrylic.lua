return function(require)
    local Creator = require("Core.Creator")
    local Theme = require("Core.Theme")
    local Utils = require("Effects.Utils")

    local Acrylic = {}
    Acrylic.__index = Acrylic

    function Acrylic.CreatePanel(parent, properties)
        properties = properties or {}
        properties.Parent = parent
        properties.BackgroundTransparency = 0.12
        properties.BackgroundColor3 = Theme.Get().Surface
        properties.BorderSizePixel = 0

        local frame = Creator.Create("Frame", properties)
        Utils.AddCorner(frame, UDim.new(0, 20))
        Utils.AddStroke(frame, 1, Theme.Get().Border)
        Utils.AddGradient(frame, Theme.Get().Accent)
        Utils.AddNoise(frame)
        return frame
    end

    function Acrylic.CreateButton(parent, properties)
        properties = properties or {}
        properties.Parent = parent
        properties.BackgroundTransparency = 0.14
        properties.BackgroundColor3 = Theme.Get().Surface
        properties.BorderSizePixel = 0
        properties.AutoButtonColor = false
        properties.Font = Enum.Font.Gotham
        properties.TextColor3 = Theme.Get().Text
        properties.TextSize = 14

        local button = Creator.Create("TextButton", properties)
        Utils.AddCorner(button, UDim.new(0, 16))
        Utils.AddStroke(button, 1, Theme.Get().Border)
        Utils.AddNoise(button)
        return button
    end

    function Acrylic.StyleInput(textbox)
        if not textbox then
            return
        end
        textbox.BackgroundTransparency = 0.16
        textbox.BackgroundColor3 = Theme.Get().Surface
        textbox.BorderSizePixel = 0
        textbox.TextColor3 = Theme.Get().Text
        textbox.PlaceholderColor3 = Theme.Get().SubText
        textbox.ClearTextOnFocus = false
        textbox.Font = Enum.Font.Gotham
        textbox.TextSize = 14
        Utils.AddCorner(textbox, UDim.new(0, 16))
        Utils.AddStroke(textbox, 1, Theme.Get().Border)
    end

    return Acrylic
end
