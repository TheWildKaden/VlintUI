return function(require)
    local Creator = require("Core.Creator")
    local Theme = require("Core.Theme")
    local Acrylic = require("Effects.Acrylic")
    local Animation = require("Core.Animation")

    local Slider = {}
    Slider.__index = Slider

    function Slider.new(section, options)
        options = options or {}
        local self = setmetatable({}, Slider)
        self._value = math.clamp(options.Default or 0, options.Min or 0, options.Max or 100)
        self._callback = options.Callback or function() end
        self._min = options.Min or 0
        self._max = options.Max or 100

        local container = Creator.Create("Frame", {
            Parent = section._panel,
            Size = UDim2.new(1, -24, 0, 64),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
        })

        local title = Creator.Create("TextLabel", {
            Parent = container,
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            Text = options.Name or "Slider",
            TextColor3 = Theme.Get().Text,
            Font = Enum.Font.GothamSemibold,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        local valueLabel = Creator.Create("TextLabel", {
            Parent = container,
            Size = UDim2.new(1, 0, 0, 18),
            Position = UDim2.new(0, 0, 0, 20),
            BackgroundTransparency = 1,
            Text = tostring(self._value),
            TextColor3 = Theme.Get().SubText,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        local barBackground = Creator.Create("Frame", {
            Parent = container,
            Size = UDim2.new(1, 0, 0, 18),
            Position = UDim2.new(0, 0, 0, 40),
            BackgroundColor3 = Theme.Get().Border,
            BorderSizePixel = 0,
        })
        Acrylic.AddCorner(barBackground, UDim.new(0, 12))

        local fill = Creator.Create("Frame", {
            Parent = barBackground,
            Size = UDim2.new((self._value - self._min) / math.max(1, self._max - self._min), 0, 1, 0),
            BackgroundColor3 = Theme.Get().Accent,
            BorderSizePixel = 0,
        })
        Acrylic.AddCorner(fill, UDim.new(0, 12))

        local thumb = Creator.Create("Frame", {
            Parent = barBackground,
            Size = UDim2.new(0, 14, 1, 0),
            Position = UDim2.new(math.clamp(fill.Size.X.Scale - 0.04, 0, 1), 0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
        })
        Acrylic.AddCorner(thumb, UDim.new(0, 12))

        local dragging = false

        local function updateSlider(inputPosition)
            local relative = math.clamp((inputPosition.X - barBackground.AbsolutePosition.X) / barBackground.AbsoluteSize.X, 0, 1)
            self._value = self._min + relative * (self._max - self._min)
            fill.Size = UDim2.new(relative, 0, 1, 0)
            thumb.Position = UDim2.new(math.clamp(relative - 0.04, 0, 1), 0, 0, 0)
            valueLabel.Text = string.format("%.0f", self._value)
            task.spawn(self._callback, self._value)
        end

        barBackground.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                updateSlider(input.Position)
            end
        end)

        barBackground.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input.Position)
            end
        end)

        self._container = container
        return self
    end

    return Slider
end
