return function(require)
    local Creator = require("Core.Creator")
    local Theme = require("Core.Theme")
    local Acrylic = require("Effects.Acrylic")
    local Animation = require("Core.Animation")

    local Button = {}
    Button.__index = Button

    function Button.new(section, options)
        options = options or {}
        local self = setmetatable({}, Button)
        self._callback = options.Callback or function() end

        local button = Acrylic.CreateButton(section._panel, {
            Size = UDim2.new(1, -24, 0, 38),
            Position = UDim2.new(0, 12, 0, 0),
            Text = options.Name or "Button",
        })

        button.MouseEnter:Connect(function()
            Animation.Tween(button, {BackgroundTransparency = 0.1}, 0.2)
        end)
        button.MouseLeave:Connect(function()
            Animation.Tween(button, {BackgroundTransparency = 0.14}, 0.2)
        end)
        button.MouseButton1Click:Connect(function()
            pcall(self._callback)
        end)

        self._button = button
        return self
    end

    return Button
end
