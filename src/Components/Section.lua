return function(require)
    local Creator = require("Core.Creator")
    local Theme = require("Core.Theme")
    local Acrylic = require("Effects.Acrylic")

    local Section = {}
    Section.__index = Section

    function Section.new(tab, title)
        local self = setmetatable({}, Section)
        self._tab = tab
        self._elements = {}

        local frame = Creator.Create("Frame", {
            Parent = tab._content,
            Size = UDim2.new(1, -12, 0, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
        })

        local header = Creator.Create("TextLabel", {
            Parent = frame,
            Size = UDim2.new(1, 0, 0, 24),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = Theme.Get().Text,
            TextSize = 16,
            Font = Enum.Font.GothamSemibold,
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        local panel = Creator.Create("Frame", {
            Parent = frame,
            Size = UDim2.new(1, 0, 0, 0),
            Position = UDim2.new(0, 0, 0, 34),
            BackgroundTransparency = 0,
            BackgroundColor3 = Theme.Get().Surface,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
        })
        Acrylic.AddCorner(panel, UDim.new(0, 18))
        Acrylic.AddStroke(panel, 1, Theme.Get().Border)

        local listLayout = Creator.Create("UIListLayout", {
            Parent = panel,
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
        })

        self._frame = frame
        self._panel = panel
        self._title = title

        return self
    end

    function Section:AddButton(options)
        local Button = require("Components.Button")
        local button = Button.new(self, options)
        table.insert(self._elements, button)
        return button
    end

    function Section:AddToggle(options)
        local Toggle = require("Components.Toggle")
        local toggle = Toggle.new(self, options)
        table.insert(self._elements, toggle)
        return toggle
    end

    function Section:AddSlider(options)
        local Slider = require("Components.Slider")
        local slider = Slider.new(self, options)
        table.insert(self._elements, slider)
        return slider
    end

    function Section:AddDropdown(options)
        local Dropdown = require("Components.Dropdown")
        local dropdown = Dropdown.new(self, options)
        table.insert(self._elements, dropdown)
        return dropdown
    end

    function Section:AddInput(options)
        local Input = require("Components.Input")
        local input = Input.new(self, options)
        table.insert(self._elements, input)
        return input
    end

    function Section:AddKeybind(options)
        local Keybind = require("Components.Keybind")
        local keybind = Keybind.new(self, options)
        table.insert(self._elements, keybind)
        return keybind
    end

    return Section
end
