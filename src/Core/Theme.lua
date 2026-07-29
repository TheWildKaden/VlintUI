return function(require)
    local Theme = {}
    Theme.__index = Theme

    local defaultTheme = {
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

    Theme.current = table.clone(defaultTheme)

    function Theme.Get()
        return Theme.current
    end

    function Theme.Merge(base, override)
        local merged = table.clone(base)
        if type(override) == "table" then
            for key, value in pairs(override) do
                merged[key] = value
            end
        end
        return merged
    end

    function Theme.Apply(overrides)
        Theme.current = Theme.Merge(defaultTheme, overrides)
        return Theme.current
    end

    function Theme.Reset()
        Theme.current = table.clone(defaultTheme)
        return Theme.current
    end

    function Theme.Create(options)
        return Theme.Merge(defaultTheme, options)
    end

    return Theme
end
