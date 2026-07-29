return function(require)
    local RunService = game:GetService("RunService")
    local Lighting = game:GetService("Lighting")
    local Workspace = game:GetService("Workspace")

    local AcrylicBlur = {}
    AcrylicBlur.__index = AcrylicBlur

    local effect
    local activeCount = 0
    local renderConnection

    local function getCamera()
        return Workspace.CurrentCamera or Workspace:WaitForChild("CurrentCamera")
    end

    local function ensureEffect()
        if effect and effect.Parent then
            return effect
        end

        effect = Lighting:FindFirstChild("VlintUI_AcrylicDepthOfField")
        if not effect then
            effect = Instance.new("DepthOfFieldEffect")
            effect.Name = "VlintUI_AcrylicDepthOfField"
            effect.FocusDistance = 20
            effect.InFocusRadius = 0
            effect.NearIntensity = 0.3
            effect.FarIntensity = 0.72
            effect.Enabled = false
            effect.Parent = Lighting
        end

        return effect
    end

    local function updateEffect()
        local camera = getCamera()
        if not camera or not effect then
            return
        end
        local focus = camera.Focus.Position - camera.CFrame.Position
        effect.FocusDistance = math.clamp(focus.Magnitude * 0.45, 10, 40)
    end

    function AcrylicBlur.Start()
        local dof = ensureEffect()
        activeCount = activeCount + 1
        dof.Enabled = true

        if not renderConnection then
            renderConnection = RunService.RenderStepped:Connect(updateEffect)
        end
    end

    function AcrylicBlur.Stop()
        activeCount = math.max(0, activeCount - 1)
        if activeCount == 0 and effect then
            effect.Enabled = false
            if renderConnection then
                renderConnection:Disconnect()
                renderConnection = nil
            end
        end
    end

    function AcrylicBlur.Destroy()
        if renderConnection then
            renderConnection:Disconnect()
            renderConnection = nil
        end
        if effect then
            effect:Destroy()
            effect = nil
        end
        activeCount = 0
    end

    return AcrylicBlur
end
