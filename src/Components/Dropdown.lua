return function(require)
    local Creator = require("Core.Creator")
    local Theme = require("Core.Theme")
    local Acrylic = require("Effects.Acrylic")
    local Animation = require("Core.Animation")

    local Dropdown = {}
    Dropdown.__index = Dropdown

    function Dropdown.new(section, options)
        options = options or {}
        local self = setmetatable({}, Dropdown)
        self._items = options.Items or {}
        self._callback = options.Callback or function() end
        self._value = options.Default or self._items[1]

        local container = Creator.Create("Frame", {
            Parent = section._panel,
            Size = UDim2.new(1, -24, 0, 42),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
        })

        local label = Creator.Create("TextLabel", {
            Parent = container,
            Size = UDim2.new(1, -12, 0, 16),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = options.Name or "Dropdown",
            TextColor3 = Theme.Get().Text,
            Font = Enum.Font.GothamSemibold,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        local toggle = Acrylic.CreateButton(container, {
            Size = UDim2.new(1, 0, 0, 26),
            Position = UDim2.new(0, 0, 0, 16),
            Text = tostring(self._value),
        })

        local list = Creator.Create("Frame", {
            Parent = container,
            Size = UDim2.new(1, 0, 0, 0),
            Position = UDim2.new(0, 0, 0, 42),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
        })

        local listContent = Creator.Create("Frame", {
            Parent = list,
            Size = UDim2.new(1, 0, 0, #self._items * 34),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
        })

        local layout = Creator.Create("UIListLayout", {
            Parent = listContent,
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 4),
        })

        local function updateOptions()
            for _, child in ipairs(listContent:GetChildren()) do
                if child ~= layout then
                    child:Destroy()
                end
            end

            for index, item in ipairs(self._items) do
                local optionButton = Acrylic.CreateButton(listContent, {
                    Size = UDim2.new(1, -12, 0, 30),
                    Text = tostring(item),
                })
                optionButton.LayoutOrder = index
                optionButton.MouseButton1Click:Connect(function()
                    self._value = item
                    toggle.Text = tostring(item)
                    self._callback(item)
                    list.Size = UDim2.new(1, 0, 0, 0)
                end)
            end
        end

        local open = false
        toggle.MouseButton1Click:Connect(function()
            open = not open
            list.Size = UDim2.new(1, 0, open and math.min(200, #self._items * 34) or 0, 0)
        end)

        updateOptions()

        self._container = container
        return self
    end

    return Dropdown
end
