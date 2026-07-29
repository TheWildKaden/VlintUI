return function(require)
    local Creator = require("Core.Creator")
    local Theme = require("Core.Theme")
    local Acrylic = require("Effects.Acrylic")
    local Animation = require("Core.Animation")

    local Toggle = {}
    Toggle.__index = Toggle

    function Toggle.new(section, options)
        options = options or {}
        local self = setmetatable({}, Toggle)
        self._value = options.Default == true
        self._callback = options.Callback or function() end

        local container = Creator.Create("Frame", {
            Parent = section._panel,
            Size = UDim2.new(1, -24, 0, 42),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
        })

        local label = Creator.Create("TextLabel", {
            Parent = container,
            Size = UDim2.new(0.7, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = options.Name or "Toggle",
            TextColor3 = Theme.Get().Text,
            Font = Enum.Font.GothamSemibold,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        local toggle = Creator.Create("TextButton", {
            Parent = container,
            Size = UDim2.new(0, 52, 0, 26),
            Position = UDim2.new(1, -52, 0.5, -13),
            AutoButtonColor = false,
            BackgroundColor3 = self._value and Theme.Get().Accent or Theme.Get().Border,
            BorderSizePixel = 0,
            Text = "",
        })
        Acrylic.AddCorner(toggle, UDim.new(0, 16))

        local indicator = Creator.Create("Frame", {
            Parent = toggle,
            Size = UDim2.new(0.48, 0, 0.8, 0),
            Position = self._value and UDim2.new(0.52, 0, 0.1, 0) or UDim2.new(0.08, 0, 0.1, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
        })
        Acrylic.AddCorner(indicator, UDim.new(0, 12))

        local function updateState(value)
            self._value = value
            toggle.BackgroundColor3 = self._value and Theme.Get().Accent or Theme.Get().Border
            Animation.Tween(indicator, {
                Position = self._value and UDim2.new(0.52, 0, 0.1, 0) or UDim2.new(0.08, 0, 0.1, 0),
            }, 0.2)
            task.spawn(self._callback, self._value)
        end

        toggle.MouseButton1Click:Connect(function()
            updateState(not self._value)
        end)

        self._container = container
        self._toggle = toggle
        return self
    end

    return Toggle
end
