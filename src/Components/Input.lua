return function(require)
    local Creator = require("Core.Creator")
    local Theme = require("Core.Theme")
    local Acrylic = require("Effects.Acrylic")

    local Input = {}
    Input.__index = Input

    function Input.new(section, options)
        options = options or {}
        local self = setmetatable({}, Input)
        self._callback = options.Callback or function() end

        local container = Creator.Create("Frame", {
            Parent = section._panel,
            Size = UDim2.new(1, -24, 0, 52),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
        })

        local label = Creator.Create("TextLabel", {
            Parent = container,
            Size = UDim2.new(1, 0, 0, 16),
            BackgroundTransparency = 1,
            Text = options.Name or "Input",
            TextColor3 = Theme.Get().Text,
            Font = Enum.Font.GothamSemibold,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        local textbox = Creator.Create("TextBox", {
            Parent = container,
            Size = UDim2.new(1, 0, 0, 28),
            Position = UDim2.new(0, 0, 0, 20),
            BackgroundColor3 = Theme.Get().Surface,
            TextColor3 = Theme.Get().Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            Text = options.Default or "",
            PlaceholderText = options.Placeholder or "Enter text...",
            ClearTextOnFocus = false,
        })
        Acrylic.StyleInput(textbox)

        textbox.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                self._callback(textbox.Text)
            end
        end)

        self._textbox = textbox
        return self
    end

    return Input
end
