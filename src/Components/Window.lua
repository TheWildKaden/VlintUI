return function(require)
    local Creator = require("Core.Creator")
    local Theme = require("Core.Theme")
    local Animation = require("Core.Animation")
    local Acrylic = require("Effects.Acrylic")
    local CreateAcrylic = require("Effects.CreateAcrylic")

    local Window = {}
    Window.__index = Window

    function Window.new(library, options)
        options = options or {}
        local self = setmetatable({}, Window)
        self._library = library
        self._tabs = {}
        self._container = Creator.Create("ScreenGui", {
            Name = options.Name or "VlintUI_Window",
            ResetOnSpawn = false,
            Parent = game:GetService("CoreGui"),
        })

        self._root = Creator.Create("Frame", {
            Parent = self._container,
            Size = options.Size or UDim2.fromOffset(640, 440),
            Position = options.Position or UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
        })

        self._overlay = Creator.Create("Frame", {
            Parent = self._container,
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 0.75,
            BackgroundColor3 = Color3.new(0, 0, 0),
            ZIndex = 0,
        })

        self._panel = Creator.Create("Frame", {
            Parent = self._root,
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 0.0,
            BackgroundColor3 = Theme.Get().Background,
            BorderSizePixel = 0,
            ZIndex = 1,
        })
        Acrylic.AddCorner(self._panel, UDim.new(0, 24))

        self._header = Creator.Create("Frame", {
            Parent = self._panel,
            Size = UDim2.new(1, 0, 0, 64),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 0.18,
            BackgroundColor3 = Theme.Get().Surface,
            BorderSizePixel = 0,
            ZIndex = 2,
        })
        Acrylic.AddCorner(self._header, UDim.new(0, 24))

        local title = Creator.Create("TextLabel", {
            Parent = self._header,
            Size = UDim2.new(0.5, -24, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = options.Title or "Window",
            TextColor3 = Theme.Get().Text,
            Font = Enum.Font.GothamSemibold,
            TextSize = 20,
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        self._tabsContainer = Creator.Create("Frame", {
            Parent = self._panel,
            Size = UDim2.new(1, 0, 1, -64),
            Position = UDim2.new(0, 0, 0, 64),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 2,
        })

        self._tabRow = Creator.Create("Frame", {
            Parent = self._tabsContainer,
            Size = UDim2.new(1, 0, 0, 46),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
        })

        self._tabButtonHolder = Creator.Create("UIListLayout", {
            Parent = self._tabRow,
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
        })

        self._body = Creator.Create("ScrollingFrame", {
            Parent = self._tabsContainer,
            Size = UDim2.new(1, -24, 1, -72),
            Position = UDim2.new(0, 12, 0, 56),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 1, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 8,
            VerticalScrollBarInset = Enum.ScrollBarInset.Always,
            ScrollBarImageColor3 = Theme.Get().Accent,
            ScrollBarImageTransparency = 0.3,
            ClipsDescendants = true,
        })

        self._acrylic = CreateAcrylic.new(self._root)

        return self
    end

    function Window:AddTab(name)
        local Tab = require("Components.Tab")
        local tab = Tab.new(self, name)
        table.insert(self._tabs, tab)
        return tab
    end

    function Window:Destroy()
        if self._acrylic then
            self._acrylic:Destroy()
            self._acrylic = nil
        end
        if self._container then
            self._container:Destroy()
            self._container = nil
        end
    end

    return Window
end
