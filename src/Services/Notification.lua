return function(require)
    local Creator = require("Core.Creator")
    local Theme = require("Core.Theme")
    local Animation = require("Core.Animation")

    local Notification = {}
    Notification.__index = Notification

    local StarterGui = game:GetService("StarterGui")

    function Notification.new()
        local self = setmetatable({}, Notification)
        self._container = Creator.Create("ScreenGui", {
            Name = "VlintUI_Notifications",
            ResetOnSpawn = false,
            Parent = game:GetService("CoreGui"),
        })

        self._layout = Creator.Create("UIListLayout", {
            Parent = self._container,
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
        })

        self._container.Enabled = true
        return self
    end

    function Notification:_buildNotification(options)
        local frame = Creator.Create("Frame", {
            Parent = self._container,
            Size = UDim2.new(0, 320, 0, 84),
            BackgroundTransparency = 0.08,
            BackgroundColor3 = Theme.Get().Surface,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, 1, 1, -16),
            LayoutOrder = 1,
        })

        Creator.Create("UICorner", {
            Parent = frame,
            CornerRadius = UDim.new(0, 18),
        })

        Creator.Create("UIStroke", {
            Parent = frame,
            Color = Theme.Get().Border,
            Thickness = 1,
            Transparency = 0.35,
            LineJoinMode = Enum.LineJoinMode.Round,
        })

        local title = Creator.Create("TextLabel", {
            Parent = frame,
            Size = UDim2.new(1, -28, 0, 28),
            Position = UDim2.new(0, 16, 0, 12),
            BackgroundTransparency = 1,
            Text = options.Title or "Notification",
            TextColor3 = Theme.Get().Text,
            TextSize = 16,
            Font = Enum.Font.GothamSemibold,
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        local message = Creator.Create("TextLabel", {
            Parent = frame,
            Size = UDim2.new(1, -28, 0, 40),
            Position = UDim2.new(0, 16, 0, 38),
            BackgroundTransparency = 1,
            Text = options.Text or "Action completed.",
            TextColor3 = Theme.Get().SubText,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        return frame
    end

    function Notification:Show(options)
        options = options or {}
        local frame = self:_buildNotification(options)

        frame.Position = UDim2.new(1, 320, 1, -16)
        frame.BackgroundTransparency = 1
        frame.TextTransparency = 1

        Animation.Tween(frame, {Position = UDim2.new(1, -16, 1, -16), BackgroundTransparency = 0.08}, 0.26)
        for _, child in ipairs(frame:GetChildren()) do
            if child:IsA("TextLabel") then
                Animation.Tween(child, {TextTransparency = 0}, 0.26)
            end
        end

        task.delay(options.Duration or 4, function()
            if frame and frame.Parent then
                Animation.Tween(frame, {BackgroundTransparency = 1}, 0.2)
                for _, child in ipairs(frame:GetChildren()) do
                    if child:IsA("TextLabel") then
                        Animation.Tween(child, {TextTransparency = 1}, 0.2)
                    end
                end
                task.delay(0.2, function()
                    if frame and frame.Parent then
                        frame:Destroy()
                    end
                end)
            end
        end)
    end

    return Notification
end
