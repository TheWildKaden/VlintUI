return function(require)
    local Creator = require("Core.Creator")
    local Theme = require("Core.Theme")
    local AcrylicBlur = require("Effects.AcrylicBlur")

    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")

    local CreateAcrylic = {}
    CreateAcrylic.__index = CreateAcrylic

    local function getCamera()
        return Workspace.CurrentCamera or Workspace:WaitForChild("CurrentCamera")
    end

    function CreateAcrylic.new(parent)
        local self = setmetatable({}, CreateAcrylic)
        self._connections = {}
        self._plane = Creator.Create("Part", {
            Name = "VlintUI_AcrylicPlane",
            Anchored = true,
            CanCollide = false,
            Transparency = 1,
            Size = Vector3.new(10, 6, 0.2),
            CastShadow = false,
            Parent = Workspace,
        })

        local surface = Creator.Create("SurfaceGui", {
            Parent = self._plane,
            Face = Enum.NormalId.Front,
            Adornee = self._plane,
            AlwaysOnTop = true,
            ResetOnSpawn = false,
            CanvasSize = Vector2.new(1920, 1080),
        })

        local background = Creator.Create("Frame", {
            Parent = surface,
            Size = UDim2.fromScale(1, 1),
            Position = UDim2.fromScale(0, 0),
            BackgroundColor3 = Theme.Get().Surface,
            BackgroundTransparency = 0.32,
            BorderSizePixel = 0,
        })

        local gradient = Creator.Create("UIGradient", {
            Parent = background,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Theme.Get().Surface),
            }),
            Rotation = 90,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.74),
                NumberSequenceKeypoint.new(1, 0.85),
            }),
        })

        Creator.Create("UICorner", {
            Parent = background,
            CornerRadius = UDim.new(0, 24),
        })

        self._surface = surface
        self._background = background
        self._blur = AcrylicBlur
        self._blur.Start()

        local function updatePlane()
            local camera = getCamera()
            if camera and self._plane then
                local offset = camera.CFrame * CFrame.new(0, 0, -7)
                self._plane.CFrame = CFrame.new(offset.Position, offset.Position + camera.CFrame.LookVector)
                self._plane.Size = Vector3.new(10, 6, 0.2)
            end
        end

        table.insert(self._connections, RunService.RenderStepped:Connect(updatePlane))
        updatePlane()

        return self
    end

    function CreateAcrylic:Destroy()
        for _, connection in ipairs(self._connections) do
            connection:Disconnect()
        end
        self._connections = {}

        if self._plane then
            self._plane:Destroy()
            self._plane = nil
        end

        if self._blur then
            self._blur.Stop()
        end
    end

    return CreateAcrylic
end
