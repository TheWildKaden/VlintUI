return function(require)
    local Config = {}
    Config.__index = Config

    function Config.new()
        return setmetatable({
            Loaded = false,
            Settings = {},
        }, Config)
    end

    function Config:Load(data)
        if type(data) ~= "table" then
            return false
        end

        self.Settings = data
        self.Loaded = true
        return true
    end

    function Config:Get(key, default)
        if self.Settings[key] == nil then
            return default
        end
        return self.Settings[key]
    end

    function Config:Set(key, value)
        self.Settings[key] = value
        return self
    end

    function Config:Export()
        return table.clone(self.Settings)
    end

    return Config
end
