# VlintUI

A lightweight Roblox UI library with acrylic-style components and a bundled single-file runtime.

## Features

- Single-file runtime output in `dist/library.lua`
- `Library:CreateWindow({...})` entrypoint
- Tabbed window layout with sections and controls
- Buttons, toggles, sliders, dropdowns, inputs, and keybinds
- Theme customization and notification support
- Compatible with `loadstring(game:HttpGet(URL))()` style loading

## Usage

### Load the library

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/<owner>/<repo>/main/dist/library.lua"))()
```

> Replace the URL above with the actual raw path to `dist/library.lua`.

### Create a window

```lua
local ui = Library:CreateWindow({
    Title = "My UI",
    Size = UDim2.new(0, 640, 0, 440),
    Position = UDim2.new(0.5, 0, 0.5, 0),
})
```

### Add a tab and section

```lua
local tab = ui:AddTab("Main")
local section = tab:AddSection("Actions")
```

### Add components

```lua
section:AddButton({
    Name = "Press Me",
    Callback = function()
        print("Button clicked")
    end,
})

section:AddToggle({
    Name = "Enable Feature",
    Default = true,
    Callback = function(value)
        print("Toggle state:", value)
    end,
})

section:AddSlider({
    Name = "Volume",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Slider value:", value)
    end,
})

section:AddDropdown({
    Name = "Mode",
    Items = {"Easy", "Normal", "Hard"},
    Default = "Normal",
    Callback = function(value)
        print("Selected:", value)
    end,
})

section:AddInput({
    Name = "Chat Prompt",
    Placeholder = "Type here...",
    Default = "",
    Callback = function(text)
        print("Input text:", text)
    end,
})

section:AddKeybind({
    Name = "Quick Key",
    Default = "F",
    Callback = function(key)
        print("Bound key:", key)
    end,
})
```

## Theme and notifications

```lua
Library:SetTheme({
    Background = Color3.fromRGB(18, 20, 28),
    Surface = Color3.fromRGB(30, 34, 44),
    Accent = Color3.fromRGB(94, 118, 255),
})

Library:Notify({
    Title = "Ready",
    Text = "VlintUI is loaded",
    Duration = 5,
})
```

## Config API

```lua
Library.Config:Load({
    SomeSetting = true,
})

local value = Library.Config:Get("SomeSetting", false)
```

## Build

To regenerate the single-file runtime:

```bash
python3 build.py
```

This writes `dist/library.lua`. If `darklua` is installed and available on `PATH`, the output is also formatted.

## Source layout

- `src/init.lua` — library entrypoint and module bundler anchor
- `src/Core` — foundational utilities and theme manager
- `src/Components` — window, tab, section, and controls
- `src/Effects` — acrylic styling helpers
- `src/Services` — notification and config services

## Notes

- Use `dist/library.lua` for runtime deployment.
- Modify source files in `src/` and rebuild with `python3 build.py`.
