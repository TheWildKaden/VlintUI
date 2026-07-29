return function(require)
    local TweenService = game:GetService("TweenService")

    local Animation = {}
    Animation.__index = Animation

    function Animation.Tween(object, properties, duration, easingStyle, easingDirection)
        easingStyle = easingStyle or Enum.EasingStyle.Quad
        easingDirection = easingDirection or Enum.EasingDirection.Out
        duration = duration or 0.22

        local success, tween = pcall(function()
            return TweenService:Create(object, TweenInfo.new(duration, easingStyle, easingDirection), properties)
        end)

        if success and tween then
            tween:Play()
            return tween
        end

        return nil
    end

    function Animation.Fade(object, transparency, duration)
        if not object then
            return nil
        end

        local properties = {}
        if object:IsA("GuiObject") then
            properties.BackgroundTransparency = transparency
            if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
                properties.TextTransparency = transparency
            end
        end

        return Animation.Tween(object, properties, duration)
    end

    return Animation
end
