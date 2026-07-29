return function(require)
    local Creator = require("Core.Creator")
    local Theme = require("Core.Theme")
    local Acrylic = require("Effects.Acrylic")
    local UserInputService = game:GetService("UserInputService")

    local Keybind = {}
    Keybind.__index = Keybind

    function Keybind.new(section, options)
        options = options or {}
        local self = setmetatable({}, Keybind)
        self._callback = options.Callback or function() end
        self._value = options.Default or "None"

        local container = Creator.Create("Frame", {
            Parent = section._panel,
            Size = UDim2.new(1, -24, 0, 42),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
        })

        local label = Creator.Create("TextLabel", {
            Parent = container,
            Size = UDim2.new(1, 0, 0, 18),
            BackgroundTransparency = 1,
            Text = options.Name or "Keybind",
            TextColor3 = Theme.Get().Text,
            Font = Enum.Font.GothamSemibold,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        local button = Acrylic.CreateButton(container, {
            Size = UDim2.new(1, 0, 0, 24),
            Position = UDim2.new(0, 0, 0, 18),
            Text = tostring(self._value),
        })

        self._listening = false

        local function beginListening()
            self._listening = true
            button.Text = "Press a key..."
        end

        button.MouseButton1Click:Connect(beginListening)

        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if self._listening and not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
                self._listening = false
                self._value = input.KeyCode.Name
                button.Text = self._value
                task.spawn(self._callback, self._value)
            end
        end)

        self._button = button
        return self
    end

    return Keybind
end
