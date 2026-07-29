local a = {}
local b = {}

local function requireModule(c)
	if b[c] then
		return b[c]
	end

	local d = a[c]

	if not d then
		error("Module not found: " .. tostring(c), 2)
	end

	local e = d(requireModule)

	b[c] = e

	return e
end

a["Components.Button"] = function(c)
	c("Core.Creator")
	c("Core.Theme")

	local d = c("Effects.Acrylic")
	local e = c("Core.Animation")
	local f = {}

	f.__index = f

	function f.new(g, h)
		h = h or {}

		local i = setmetatable({}, f)

		i._callback = h.Callback or function() end

		local j = d.CreateButton(g._panel, {
			Size = UDim2.new(1, -24, 0, 38),
			Position = UDim2.new(0, 12, 0, 0),
			Text = h.Name or "Button",
		})

		j.MouseEnter:Connect(function()
			e.Tween(j, { BackgroundTransparency = 0.1 }, 0.2)
		end)
		j.MouseLeave:Connect(function()
			e.Tween(j, { BackgroundTransparency = 0.14 }, 0.2)
		end)
		j.MouseButton1Click:Connect(function()
			pcall(i._callback)
		end)

		i._button = j

		return i
	end

	return f
end
a["Components.Dropdown"] = function(c)
	local d = c("Core.Creator")
	local e = c("Core.Theme")
	local f = c("Effects.Acrylic")

	c("Core.Animation")

	local g = {}

	g.__index = g

	function g.new(h, i)
		i = i or {}

		local j = setmetatable({}, g)

		j._items = i.Items or {}
		j._callback = i.Callback or function() end
		j._value = i.Default or j._items[1]

		local k = d.Create("Frame", {
			Parent = h._panel,
			Size = UDim2.new(1, -24, 0, 42),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
		})

		d.Create("TextLabel", {
			Parent = k,
			Size = UDim2.new(1, -12, 0, 16),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			Text = i.Name or "Dropdown",
			TextColor3 = e.Get().Text,
			Font = Enum.Font.GothamSemibold,
			TextSize = 15,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		local l = f.CreateButton(k, {
			Size = UDim2.new(1, 0, 0, 26),
			Position = UDim2.new(0, 0, 0, 16),
			Text = tostring(j._value),
		})
		local m = d.Create("Frame", {
			Parent = k,
			Size = UDim2.new(1, 0, 0, 0),
			Position = UDim2.new(0, 0, 0, 42),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = true,
		})
		local n = d.Create("Frame", {
			Parent = m,
			Size = UDim2.new(1, 0, 0, #j._items * 34),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
		})
		local o = d.Create("UIListLayout", {
			Parent = n,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 4),
		})

		local function updateOptions()
			for p, q in ipairs(n:GetChildren()) do
				if q ~= o then
					q:Destroy()
				end
			end
			for p, q in ipairs(j._items) do
				local r = f.CreateButton(n, {
					Size = UDim2.new(1, -12, 0, 30),
					Text = tostring(q),
				})

				r.LayoutOrder = p

				r.MouseButton1Click:Connect(function()
					j._value = q
					l.Text = tostring(q)

					j._callback(q)

					m.Size = UDim2.new(1, 0, 0, 0)
				end)
			end
		end

		local p = false

		l.MouseButton1Click:Connect(function()
			p = not p
			m.Size = UDim2.new(1, 0, p and math.min(200, #j._items * 34) or 0, 0)
		end)
		updateOptions()

		j._container = k

		return j
	end

	return g
end
a["Components.Input"] = function(c)
	local d = c("Core.Creator")
	local e = c("Core.Theme")
	local f = c("Effects.Acrylic")
	local g = {}

	g.__index = g

	function g.new(h, i)
		i = i or {}

		local j = setmetatable({}, g)

		j._callback = i.Callback or function() end

		local k = d.Create("Frame", {
			Parent = h._panel,
			Size = UDim2.new(1, -24, 0, 52),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
		})

		d.Create("TextLabel", {
			Parent = k,
			Size = UDim2.new(1, 0, 0, 16),
			BackgroundTransparency = 1,
			Text = i.Name or "Input",
			TextColor3 = e.Get().Text,
			Font = Enum.Font.GothamSemibold,
			TextSize = 15,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		local l = d.Create("TextBox", {
			Parent = k,
			Size = UDim2.new(1, 0, 0, 28),
			Position = UDim2.new(0, 0, 0, 20),
			BackgroundColor3 = e.Get().Surface,
			TextColor3 = e.Get().Text,
			TextSize = 14,
			Font = Enum.Font.Gotham,
			Text = i.Default or "",
			PlaceholderText = i.Placeholder or "Enter text...",
			ClearTextOnFocus = false,
		})

		f.StyleInput(l)
		l.FocusLost:Connect(function(m)
			if m then
				j._callback(l.Text)
			end
		end)

		j._textbox = l

		return j
	end

	return g
end
a["Components.Keybind"] = function(c)
	local d = c("Core.Creator")
	local e = c("Core.Theme")
	local f = c("Effects.Acrylic")
	local g = game:GetService("UserInputService")
	local h = {}

	h.__index = h

	function h.new(i, j)
		j = j or {}

		local k = setmetatable({}, h)

		k._callback = j.Callback or function() end
		k._value = j.Default or "None"

		local l = d.Create("Frame", {
			Parent = i._panel,
			Size = UDim2.new(1, -24, 0, 42),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
		})

		d.Create("TextLabel", {
			Parent = l,
			Size = UDim2.new(1, 0, 0, 18),
			BackgroundTransparency = 1,
			Text = j.Name or "Keybind",
			TextColor3 = e.Get().Text,
			Font = Enum.Font.GothamSemibold,
			TextSize = 15,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		local m = f.CreateButton(l, {
			Size = UDim2.new(1, 0, 0, 24),
			Position = UDim2.new(0, 0, 0, 18),
			Text = tostring(k._value),
		})

		k._listening = false

		local function beginListening()
			k._listening = true
			m.Text = "Press a key..."
		end

		m.MouseButton1Click:Connect(beginListening)
		g.InputBegan:Connect(function(n, o)
			if k._listening and not o and n.UserInputType == Enum.UserInputType.Keyboard then
				k._listening = false
				k._value = n.KeyCode.Name
				m.Text = k._value

				task.spawn(k._callback, k._value)
			end
		end)

		k._button = m

		return k
	end

	return h
end
a["Components.Section"] = function(c)
	local d = c("Core.Creator")
	local e = c("Core.Theme")
	local f = c("Effects.Acrylic")
	local g = {}

	g.__index = g

	function g.new(h, i)
		local j = setmetatable({}, g)

		j._tab = h
		j._elements = {}

		local k = d.Create("Frame", {
			Parent = h._content,
			Size = UDim2.new(1, -12, 0, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
		})

		d.Create("TextLabel", {
			Parent = k,
			Size = UDim2.new(1, 0, 0, 24),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			Text = i,
			TextColor3 = e.Get().Text,
			TextSize = 16,
			Font = Enum.Font.GothamSemibold,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		local l = d.Create("Frame", {
			Parent = k,
			Size = UDim2.new(1, 0, 0, 0),
			Position = UDim2.new(0, 0, 0, 34),
			BackgroundTransparency = 0,
			BackgroundColor3 = e.Get().Surface,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
		})

		f.AddCorner(l, UDim.new(0, 18))
		f.AddStroke(l, 1, e.Get().Border)
		d.Create("UIListLayout", {
			Parent = l,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8),
		})

		j._frame = k
		j._panel = l
		j._title = i

		return j
	end
	function g.AddButton(h, i)
		local j = c("Components.Button")
		local k = j.new(h, i)

		table.insert(h._elements, k)

		return k
	end
	function g.AddToggle(h, i)
		local j = c("Components.Toggle")
		local k = j.new(h, i)

		table.insert(h._elements, k)

		return k
	end
	function g.AddSlider(h, i)
		local j = c("Components.Slider")
		local k = j.new(h, i)

		table.insert(h._elements, k)

		return k
	end
	function g.AddDropdown(h, i)
		local j = c("Components.Dropdown")
		local k = j.new(h, i)

		table.insert(h._elements, k)

		return k
	end
	function g.AddInput(h, i)
		local j = c("Components.Input")
		local k = j.new(h, i)

		table.insert(h._elements, k)

		return k
	end
	function g.AddKeybind(h, i)
		local j = c("Components.Keybind")
		local k = j.new(h, i)

		table.insert(h._elements, k)

		return k
	end

	return g
end
a["Components.Slider"] = function(c)
	local d = c("Core.Creator")
	local e = c("Core.Theme")
	local f = c("Effects.Acrylic")

	c("Core.Animation")

	local g = {}

	g.__index = g

	function g.new(h, i)
		i = i or {}

		local j = setmetatable({}, g)

		j._value = math.clamp(i.Default or 0, i.Min or 0, i.Max or 100)
		j._callback = i.Callback or function() end
		j._min = i.Min or 0
		j._max = i.Max or 100

		local k = d.Create("Frame", {
			Parent = h._panel,
			Size = UDim2.new(1, -24, 0, 64),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
		})

		d.Create("TextLabel", {
			Parent = k,
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundTransparency = 1,
			Text = i.Name or "Slider",
			TextColor3 = e.Get().Text,
			Font = Enum.Font.GothamSemibold,
			TextSize = 15,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		local l = d.Create("TextLabel", {
			Parent = k,
			Size = UDim2.new(1, 0, 0, 18),
			Position = UDim2.new(0, 0, 0, 20),
			BackgroundTransparency = 1,
			Text = tostring(j._value),
			TextColor3 = e.Get().SubText,
			Font = Enum.Font.Gotham,
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
		})
		local m = d.Create("Frame", {
			Parent = k,
			Size = UDim2.new(1, 0, 0, 18),
			Position = UDim2.new(0, 0, 0, 40),
			BackgroundColor3 = e.Get().Border,
			BorderSizePixel = 0,
		})

		f.AddCorner(m, UDim.new(0, 12))

		local n = d.Create("Frame", {
			Parent = m,
			Size = UDim2.new((j._value - j._min) / math.max(1, j._max - j._min), 0, 1, 0),
			BackgroundColor3 = e.Get().Accent,
			BorderSizePixel = 0,
		})

		f.AddCorner(n, UDim.new(0, 12))

		local o = d.Create("Frame", {
			Parent = m,
			Size = UDim2.new(0, 14, 1, 0),
			Position = UDim2.new(math.clamp(n.Size.X.Scale - 0.04, 0, 1), 0, 0, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderSizePixel = 0,
		})

		f.AddCorner(o, UDim.new(0, 12))

		local p = false

		local function updateSlider(q)
			local r = math.clamp((q.X - m.AbsolutePosition.X) / m.AbsoluteSize.X, 0, 1)

			j._value = j._min + r * (j._max - j._min)
			n.Size = UDim2.new(r, 0, 1, 0)
			o.Position = UDim2.new(math.clamp(r - 0.04, 0, 1), 0, 0, 0)
			l.Text = string.format("%.0f", j._value)

			task.spawn(j._callback, j._value)
		end

		m.InputBegan:Connect(function(q)
			if q.UserInputType == Enum.UserInputType.MouseButton1 then
				p = true

				updateSlider(q.Position)
			end
		end)
		m.InputEnded:Connect(function(q)
			if q.UserInputType == Enum.UserInputType.MouseButton1 then
				p = false
			end
		end)
		game:GetService("UserInputService").InputChanged:Connect(function(q)
			if p and q.UserInputType == Enum.UserInputType.MouseMovement then
				updateSlider(q.Position)
			end
		end)

		j._container = k

		return j
	end

	return g
end
a["Components.Tab"] = function(c)
	local d = c("Core.Creator")
	local e = c("Core.Theme")
	local f = c("Effects.Acrylic")
	local g = {}

	g.__index = g

	function g.new(h, i)
		local j = setmetatable({}, g)

		j._window = h
		j._name = i
		j._sections = {}

		local k = d.Create("TextButton", {
			Parent = h._tabRow,
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			Text = i,
			TextColor3 = e.Get().SubText,
			TextSize = 15,
			Font = Enum.Font.GothamSemibold,
			Size = UDim2.new(0, 88, 0, 34),
		})

		f.AddCorner(k, UDim.new(0, 16))

		local l = d.Create("Frame", {
			Parent = h._body,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			Visible = false,
		})

		d.Create("UIListLayout", {
			Parent = l,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 12),
		})

		j._button = k
		j._content = l

		k.MouseButton1Click:Connect(function()
			j:Select()
		end)

		return j
	end
	function g.Select(h)
		for i, j in ipairs(h._window._tabs) do
			j._content.Visible = false
			j._button.TextColor3 = e.Get().SubText
		end

		h._content.Visible = true
		h._button.TextColor3 = e.Get().Text
	end
	function g.AddSection(h, i)
		local j = c("Components.Section")
		local k = j.new(h, i)

		table.insert(h._sections, k)

		return k
	end

	return g
end
a["Components.Toggle"] = function(c)
	local d = c("Core.Creator")
	local e = c("Core.Theme")
	local f = c("Effects.Acrylic")
	local g = c("Core.Animation")
	local h = {}

	h.__index = h

	function h.new(i, j)
		j = j or {}

		local k = setmetatable({}, h)

		k._value = j.Default == true
		k._callback = j.Callback or function() end

		local l = d.Create("Frame", {
			Parent = i._panel,
			Size = UDim2.new(1, -24, 0, 42),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
		})

		d.Create("TextLabel", {
			Parent = l,
			Size = UDim2.new(0.7, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = j.Name or "Toggle",
			TextColor3 = e.Get().Text,
			Font = Enum.Font.GothamSemibold,
			TextSize = 15,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		local m = d.Create("TextButton", {
			Parent = l,
			Size = UDim2.new(0, 52, 0, 26),
			Position = UDim2.new(1, -52, 0.5, -13),
			AutoButtonColor = false,
			BackgroundColor3 = k._value and e.Get().Accent or e.Get().Border,
			BorderSizePixel = 0,
			Text = "",
		})

		f.AddCorner(m, UDim.new(0, 16))

		local n = d.Create("Frame", {
			Parent = m,
			Size = UDim2.new(0.48, 0, 0.8, 0),
			Position = k._value and UDim2.new(0.52, 0, 0.1, 0) or UDim2.new(0.08, 0, 0.1, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderSizePixel = 0,
		})

		f.AddCorner(n, UDim.new(0, 12))

		local function updateState(o)
			k._value = o
			m.BackgroundColor3 = k._value and e.Get().Accent or e.Get().Border

			g.Tween(n, {
				Position = k._value and UDim2.new(0.52, 0, 0.1, 0) or UDim2.new(0.08, 0, 0.1, 0),
			}, 0.2)
			task.spawn(k._callback, k._value)
		end

		m.MouseButton1Click:Connect(function()
			updateState(not k._value)
		end)

		k._container = l
		k._toggle = m

		return k
	end

	return h
end
a["Components.Window"] = function(c)
	local d = c("Core.Creator")
	local e = c("Core.Theme")

	c("Core.Animation")

	local f = c("Effects.Acrylic")
	local g = c("Effects.CreateAcrylic")
	local h = {}

	h.__index = h

	function h.new(i, j)
		j = j or {}

		local k = setmetatable({}, h)

		k._library = i
		k._tabs = {}
		k._container = d.Create("ScreenGui", {
			Name = j.Name or "VlintUI_Window",
			ResetOnSpawn = false,
			Parent = game:GetService("CoreGui"),
		})
		k._root = d.Create("Frame", {
			Parent = k._container,
			Size = j.Size or UDim2.fromOffset(640, 440),
			Position = j.Position or UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
		})
		k._overlay = d.Create("Frame", {
			Parent = k._container,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 0.75,
			BackgroundColor3 = Color3.new(0, 0, 0),
			ZIndex = 0,
		})
		k._panel = d.Create("Frame", {
			Parent = k._root,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 0,
			BackgroundColor3 = e.Get().Background,
			BorderSizePixel = 0,
			ZIndex = 1,
		})

		f.AddCorner(k._panel, UDim.new(0, 24))

		k._header = d.Create("Frame", {
			Parent = k._panel,
			Size = UDim2.new(1, 0, 0, 64),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 0.18,
			BackgroundColor3 = e.Get().Surface,
			BorderSizePixel = 0,
			ZIndex = 2,
		})

		f.AddCorner(k._header, UDim.new(0, 24))
		d.Create("TextLabel", {
			Parent = k._header,
			Size = UDim2.new(0.5, -24, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			Text = j.Title or "Window",
			TextColor3 = e.Get().Text,
			Font = Enum.Font.GothamSemibold,
			TextSize = 20,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		k._tabsContainer = d.Create("Frame", {
			Parent = k._panel,
			Size = UDim2.new(1, 0, 1, -64),
			Position = UDim2.new(0, 0, 0, 64),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 2,
		})
		k._tabRow = d.Create("Frame", {
			Parent = k._tabsContainer,
			Size = UDim2.new(1, 0, 0, 46),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
		})
		k._tabButtonHolder = d.Create("UIListLayout", {
			Parent = k._tabRow,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8),
		})
		k._body = d.Create("ScrollingFrame", {
			Parent = k._tabsContainer,
			Size = UDim2.new(1, -24, 1, -72),
			Position = UDim2.new(0, 12, 0, 56),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			CanvasSize = UDim2.new(0, 0, 1, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = 8,
			VerticalScrollBarInset = Enum.ScrollBarInset.Always,
			ScrollBarImageColor3 = e.Get().Accent,
			ScrollBarImageTransparency = 0.3,
			ClipsDescendants = true,
		})
		k._acrylic = g.new(k._root)

		return k
	end
	function h.AddTab(i, j)
		local k = c("Components.Tab")
		local l = k.new(i, j)

		table.insert(i._tabs, l)

		return l
	end
	function h.Destroy(i)
		if i._acrylic then
			i._acrylic:Destroy()

			i._acrylic = nil
		end
		if i._container then
			i._container:Destroy()

			i._container = nil
		end
	end

	return h
end
a["Core.Animation"] = function(c)
	local d = game:GetService("TweenService")
	local e = {}

	e.__index = e

	function e.Tween(f, g, h, i, j)
		i = i or Enum.EasingStyle.Quad
		j = j or Enum.EasingDirection.Out
		h = h or 0.22

		local k, l = pcall(function()
			return d:Create(f, TweenInfo.new(h, i, j), g)
		end)

		if k and l then
			l:Play()

			return l
		end

		return nil
	end
	function e.Fade(f, g, h)
		if not f then
			return nil
		end

		local i = {}

		if f:IsA("GuiObject") then
			i.BackgroundTransparency = g

			if f:IsA("TextLabel") or f:IsA("TextButton") or f:IsA("TextBox") then
				i.TextTransparency = g
			end
		end

		return e.Tween(f, i, h)
	end

	return e
end
a["Core.Creator"] = function(c)
	local d = {}

	d.__index = d

	function d.Create(e, f)
		local g = Instance.new(e)

		if type(f) == "table" then
			for h, i in pairs(f) do
				if h == "Parent" then
					g.Parent = i
				elseif h == "Children" and type(i) == "table" then
					for j, k in ipairs(i) do
						if k then
							k.Parent = g
						end
					end
				else
					g[h] = i
				end
			end
		end

		return g
	end

	return d
end
a["Core.Signal"] = function(c)
	local d = {}

	d.__index = d

	function d.new()
		return setmetatable({
			_connections = {},
			_destroyed = false,
		}, d)
	end
	function d.Connect(e, f)
		if e._destroyed then
			return {
				Disconnect = function() end,
			}
		end

		local g = {
			Connected = true,
			Disconnect = function()
				if connection.Connected then
					connection.Connected = false

					for g, h in ipairs(e._connections) do
						if h == connection then
							table.remove(e._connections, g)

							break
						end
					end
				end
			end,
		}

		g._callback = f

		table.insert(e._connections, g)

		return g
	end
	function d.Fire(e, ...)
		for f, g in ipairs(e._connections) do
			if g.Connected then
				task.spawn(g._callback, ...)
			end
		end
	end
	function d.Destroy(e)
		e._destroyed = true

		for f, g in ipairs(e._connections) do
			g.Connected = false
		end

		e._connections = {}
	end

	return d
end
a["Core.Theme"] = function(c)
	local d = {}

	d.__index = d

	local e = {
		Background = Color3.fromRGB(20, 23, 30),
		Surface = Color3.fromRGB(30, 34, 44),
		Accent = Color3.fromRGB(109, 132, 255),
		Border = Color3.fromRGB(67, 75, 95),
		Text = Color3.fromRGB(239, 242, 247),
		SubText = Color3.fromRGB(169, 178, 196),
		Highlight = Color3.fromRGB(111, 140, 255),
		Error = Color3.fromRGB(255, 107, 107),
		Shadow = Color3.fromRGB(0, 0, 0),
		NoiseAlpha = 0.08,
		GradientAccent = Color3.fromRGB(93, 113, 227),
	}

	d.current = table.clone(e)

	function d.Get()
		return d.current
	end
	function d.Merge(f, g)
		local h = table.clone(f)

		if type(g) == "table" then
			for i, j in pairs(g) do
				h[i] = j
			end
		end

		return h
	end
	function d.Apply(f)
		d.current = d.Merge(e, f)

		return d.current
	end
	function d.Reset()
		d.current = table.clone(e)

		return d.current
	end
	function d.Create(f)
		return d.Merge(e, f)
	end

	return d
end
a["Effects.Acrylic"] = function(c)
	local d = c("Core.Creator")
	local e = c("Core.Theme")
	local f = c("Effects.Utils")
	local g = {}

	g.__index = g

	function g.CreatePanel(h, i)
		i = i or {}
		i.Parent = h
		i.BackgroundTransparency = 0.12
		i.BackgroundColor3 = e.Get().Surface
		i.BorderSizePixel = 0

		local j = d.Create("Frame", i)

		f.AddCorner(j, UDim.new(0, 20))
		f.AddStroke(j, 1, e.Get().Border)
		f.AddGradient(j, e.Get().Accent)
		f.AddNoise(j)

		return j
	end
	function g.CreateButton(h, i)
		i = i or {}
		i.Parent = h
		i.BackgroundTransparency = 0.14
		i.BackgroundColor3 = e.Get().Surface
		i.BorderSizePixel = 0
		i.AutoButtonColor = false
		i.Font = Enum.Font.Gotham
		i.TextColor3 = e.Get().Text
		i.TextSize = 14

		local j = d.Create("TextButton", i)

		f.AddCorner(j, UDim.new(0, 16))
		f.AddStroke(j, 1, e.Get().Border)
		f.AddNoise(j)

		return j
	end
	function g.StyleInput(h)
		if not h then
			return
		end

		h.BackgroundTransparency = 0.16
		h.BackgroundColor3 = e.Get().Surface
		h.BorderSizePixel = 0
		h.TextColor3 = e.Get().Text
		h.PlaceholderColor3 = e.Get().SubText
		h.ClearTextOnFocus = false
		h.Font = Enum.Font.Gotham
		h.TextSize = 14

		f.AddCorner(h, UDim.new(0, 16))
		f.AddStroke(h, 1, e.Get().Border)
	end

	return g
end
a["Effects.AcrylicBlur"] = function(c)
	local d = game:GetService("RunService")
	local e = game:GetService("Lighting")
	local f = game:GetService("Workspace")
	local g = {}

	g.__index = g

	local h
	local i = 0
	local j

	local function getCamera()
		return f.CurrentCamera or f:WaitForChild("CurrentCamera")
	end
	local function ensureEffect()
		if h and h.Parent then
			return h
		end

		h = e:FindFirstChild("VlintUI_AcrylicDepthOfField")

		if not h then
			h = Instance.new("DepthOfFieldEffect")
			h.Name = "VlintUI_AcrylicDepthOfField"
			h.FocusDistance = 20
			h.InFocusRadius = 0
			h.NearIntensity = 0.3
			h.FarIntensity = 0.72
			h.Enabled = false
			h.Parent = e
		end

		return h
	end
	local function updateEffect()
		local k = getCamera()

		if not k or not h then
			return
		end

		local l = k.Focus.Position - k.CFrame.Position

		h.FocusDistance = math.clamp(l.Magnitude * 0.45, 10, 40)
	end

	function g.Start()
		local k = ensureEffect()

		i = i + 1
		k.Enabled = true

		if not j then
			j = d.RenderStepped:Connect(updateEffect)
		end
	end
	function g.Stop()
		i = math.max(0, i - 1)

		if i == 0 and h then
			h.Enabled = false

			if j then
				j:Disconnect()

				j = nil
			end
		end
	end
	function g.Destroy()
		if j then
			j:Disconnect()

			j = nil
		end
		if h then
			h:Destroy()

			h = nil
		end

		i = 0
	end

	return g
end
a["Effects.CreateAcrylic"] = function(c)
	local d = c("Core.Creator")
	local e = c("Core.Theme")
	local f = c("Effects.AcrylicBlur")
	local g = game:GetService("RunService")
	local h = game:GetService("Workspace")
	local i = {}

	i.__index = i

	local function getCamera()
		return h.CurrentCamera or h:WaitForChild("CurrentCamera")
	end

	function i.new(j)
		local k = setmetatable({}, i)

		k._connections = {}
		k._plane = d.Create("Part", {
			Name = "VlintUI_AcrylicPlane",
			Anchored = true,
			CanCollide = false,
			Transparency = 1,
			Size = Vector3.new(10, 6, 0.2),
			CastShadow = false,
			Parent = h,
		})

		local l = d.Create("SurfaceGui", {
			Parent = k._plane,
			Face = Enum.NormalId.Front,
			Adornee = k._plane,
			AlwaysOnTop = true,
			ResetOnSpawn = false,
			CanvasSize = Vector2.new(1920, 1080),
		})
		local m = d.Create("Frame", {
			Parent = l,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0, 0),
			BackgroundColor3 = e.Get().Surface,
			BackgroundTransparency = 0.32,
			BorderSizePixel = 0,
		})

		d.Create("UIGradient", {
			Parent = m,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
				ColorSequenceKeypoint.new(1, e.Get().Surface),
			}),
			Rotation = 90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.74),
				NumberSequenceKeypoint.new(1, 0.85),
			}),
		})
		d.Create("UICorner", {
			Parent = m,
			CornerRadius = UDim.new(0, 24),
		})

		k._surface = l
		k._background = m
		k._blur = f

		k._blur.Start()

		local function updatePlane()
			local n = getCamera()

			if n and k._plane then
				local o = n.CFrame * CFrame.new(0, 0, -7)

				k._plane.CFrame = CFrame.new(o.Position, o.Position + n.CFrame.LookVector)
				k._plane.Size = Vector3.new(10, 6, 0.2)
			end
		end

		table.insert(k._connections, g.RenderStepped:Connect(updatePlane))
		updatePlane()

		return k
	end
	function i.Destroy(j)
		for k, l in ipairs(j._connections) do
			l:Disconnect()
		end

		j._connections = {}

		if j._plane then
			j._plane:Destroy()

			j._plane = nil
		end
		if j._blur then
			j._blur.Stop()
		end
	end

	return i
end
a["Effects.Utils"] = function(c)
	local d = c("Core.Creator")
	local e = c("Core.Theme")
	local f = {}

	f.__index = f

	local g = UDim.new(0, 14)

	function f.AddCorner(h, i)
		return d.Create("UICorner", {
			Parent = h,
			CornerRadius = i or g,
		})
	end
	function f.AddStroke(h, i, j)
		return d.Create("UIStroke", {
			Parent = h,
			Thickness = i or 1,
			Color = j or e.Get().Border,
			LineJoinMode = Enum.LineJoinMode.Round,
			Transparency = 0.35,
		})
	end
	function f.AddGradient(h, i)
		return d.Create("UIGradient", {
			Parent = h,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, i or e.Get().GradientAccent),
				ColorSequenceKeypoint.new(1, e.Get().Surface),
			}),
			Rotation = 90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.85),
				NumberSequenceKeypoint.new(1, 0.95),
			}),
			Offset = Vector2.new(0, 0.15),
		})
	end
	function f.AddNoise(h)
		local i = d.Create("ImageLabel", {
			Parent = h,
			Name = "NoiseOverlay",
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0, 0),
			BackgroundTransparency = 1,
			Image = "rbxassetid://12175030056",
			ImageColor3 = Color3.new(1, 1, 1),
			ImageTransparency = 0.88,
			ScaleType = Enum.ScaleType.Tile,
			SliceCenter = Rect.new(0, 0, 0, 0),
		})

		d.Create("UIAspectRatioConstraint", {
			Parent = i,
			AspectRatio = 1,
		})

		return i
	end
	function f.ApplyAcrylicStyle(h)
		if not h or not h:IsA("GuiObject") then
			return
		end

		h.BackgroundColor3 = e.Get().Surface
		h.BackgroundTransparency = 0.12
		h.BorderSizePixel = 0

		f.AddCorner(h, UDim.new(0, 18))
		f.AddStroke(h, 1, e.Get().Border)
		f.AddGradient(h)
		f.AddNoise(h)
	end

	return f
end
a["Services.Config"] = function(c)
	local d = {}

	d.__index = d

	function d.new()
		return setmetatable({
			Loaded = false,
			Settings = {},
		}, d)
	end
	function d.Load(e, f)
		if type(f) ~= "table" then
			return false
		end

		e.Settings = f
		e.Loaded = true

		return true
	end
	function d.Get(e, f, g)
		if e.Settings[f] == nil then
			return g
		end

		return e.Settings[f]
	end
	function d.Set(e, f, g)
		e.Settings[f] = g

		return e
	end
	function d.Export(e)
		return table.clone(e.Settings)
	end

	return d
end
a["Services.Notification"] = function(c)
	local d = c("Core.Creator")
	local e = c("Core.Theme")
	local f = c("Core.Animation")
	local g = {}

	g.__index = g

	game:GetService("StarterGui")

	function g.new()
		local h = setmetatable({}, g)

		h._container = d.Create("ScreenGui", {
			Name = "VlintUI_Notifications",
			ResetOnSpawn = false,
			Parent = game:GetService("CoreGui"),
		})
		h._layout = d.Create("UIListLayout", {
			Parent = h._container,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8),
		})
		h._container.Enabled = true

		return h
	end
	function g._buildNotification(h, i)
		local j = d.Create("Frame", {
			Parent = h._container,
			Size = UDim2.new(0, 320, 0, 84),
			BackgroundTransparency = 0.08,
			BackgroundColor3 = e.Get().Surface,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, 1, 1, -16),
			LayoutOrder = 1,
		})

		d.Create("UICorner", {
			Parent = j,
			CornerRadius = UDim.new(0, 18),
		})
		d.Create("UIStroke", {
			Parent = j,
			Color = e.Get().Border,
			Thickness = 1,
			Transparency = 0.35,
			LineJoinMode = Enum.LineJoinMode.Round,
		})
		d.Create("TextLabel", {
			Parent = j,
			Size = UDim2.new(1, -28, 0, 28),
			Position = UDim2.new(0, 16, 0, 12),
			BackgroundTransparency = 1,
			Text = i.Title or "Notification",
			TextColor3 = e.Get().Text,
			TextSize = 16,
			Font = Enum.Font.GothamSemibold,
			TextXAlignment = Enum.TextXAlignment.Left,
		})
		d.Create("TextLabel", {
			Parent = j,
			Size = UDim2.new(1, -28, 0, 40),
			Position = UDim2.new(0, 16, 0, 38),
			BackgroundTransparency = 1,
			Text = i.Text or "Action completed.",
			TextColor3 = e.Get().SubText,
			TextSize = 14,
			Font = Enum.Font.Gotham,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		return j
	end
	function g.Show(h, i)
		i = i or {}

		local j = h:_buildNotification(i)

		j.Position = UDim2.new(1, 320, 1, -16)
		j.BackgroundTransparency = 1
		j.TextTransparency = 1

		f.Tween(j, {
			Position = UDim2.new(1, -16, 1, -16),
			BackgroundTransparency = 0.08,
		}, 0.26)

		for k, l in ipairs(j:GetChildren()) do
			if l:IsA("TextLabel") then
				f.Tween(l, { TextTransparency = 0 }, 0.26)
			end
		end

		task.delay(i.Duration or 4, function()
			if j and j.Parent then
				f.Tween(j, { BackgroundTransparency = 1 }, 0.2)

				for k, l in ipairs(j:GetChildren()) do
					if l:IsA("TextLabel") then
						f.Tween(l, { TextTransparency = 1 }, 0.2)
					end
				end

				task.delay(0.2, function()
					if j and j.Parent then
						j:Destroy()
					end
				end)
			end
		end)
	end

	return g
end

local c = {}

c.__index = c

local d = requireModule("Core.Theme")
local e = requireModule("Services.Config")
local f = requireModule("Services.Notification")

c.Theme = d
c.Config = e.new()
c.Notification = f.new()

function c.CreateWindow(g, h)
	h = h or {}

	local i = requireModule("Components.Window")

	return i(g, h)
end
function c.SetTheme(g, h)
	if type(h) ~= "table" then
		error("SetTheme expects a table", 2)
	end

	d.Apply(h)

	return g
end
function c.Notify(g, h)
	if type(h) ~= "table" then
		error("Notify expects a table", 2)
	end

	g.Notification:Show(h)

	return g
end

return setmetatable(c, {
	__call = function(g, h)
		return c:CreateWindow(h)
	end,
})
