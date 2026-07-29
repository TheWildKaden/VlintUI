-- init.lua
-- Entry point for the library. The build script bundles module source files into
-- a single runtime file by injecting module factory functions into internalModules.
local internalModules = {}
local moduleCache = {}

local function requireModule(moduleName)
    if moduleCache[moduleName] then
        return moduleCache[moduleName]
    end

    local factory = internalModules[moduleName]
    if not factory then
        error("Module not found: " .. tostring(moduleName), 2)
    end

    local result = factory(requireModule)
    moduleCache[moduleName] = result
    return result
end

-- MODULES_START
-- MODULES_END

local Library = {}
Library.__index = Library

local Theme = requireModule("Core.Theme")
local Config = requireModule("Services.Config")
local NotificationService = requireModule("Services.Notification")

Library.Theme = Theme
Library.Config = Config.new()
Library.Notification = NotificationService.new()

function Library:CreateWindow(options)
    options = options or {}
    local Window = requireModule("Components.Window")
    return Window(self, options)
end

function Library:SetTheme(theme)
    if type(theme) ~= "table" then
        error("SetTheme expects a table", 2)
    end

    Theme.Apply(theme)
    return self
end

function Library:Notify(notificationOptions)
    if type(notificationOptions) ~= "table" then
        error("Notify expects a table", 2)
    end

    self.Notification:Show(notificationOptions)
    return self
end

return setmetatable(Library, {
    __call = function(_, options)
        return Library:CreateWindow(options)
    end,
})
