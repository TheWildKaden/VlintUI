return function(require)
    local Creator = require("Core.Creator")
    local Theme = require("Core.Theme")
    local Acrylic = require("Effects.Acrylic")

    local Tab = {}
    Tab.__index = Tab

    function Tab.new(window, name)
        local self = setmetatable({}, Tab)
        self._window = window
        self._name = name
        self._sections = {}

        local button = Creator.Create("TextButton", {
            Parent = window._tabRow,
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = Theme.Get().SubText,
            TextSize = 15,
            Font = Enum.Font.GothamSemibold,
            Size = UDim2.new(0, 88, 0, 34),
        })
        Acrylic.AddCorner(button, UDim.new(0, 16))

        local content = Creator.Create("Frame", {
            Parent = window._body,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Visible = false,
        })

        Creator.Create("UIListLayout", {
            Parent = content,
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 12),
        })

        self._button = button
        self._content = content

        button.MouseButton1Click:Connect(function()
            self:Select()
        end)

        return self
    end

    function Tab:Select()
        for _, tab in ipairs(self._window._tabs) do
            tab._content.Visible = false
            tab._button.TextColor3 = Theme.Get().SubText
        end

        self._content.Visible = true
        self._button.TextColor3 = Theme.Get().Text
    end

    function Tab:AddSection(title)
        local Section = require("Components.Section")
        local section = Section.new(self, title)
        table.insert(self._sections, section)
        return section
    end

    return Tab
end
