return function(require)
    local Creator = {}
    Creator.__index = Creator

    function Creator.Create(className, properties)
        local instance = Instance.new(className)
        if type(properties) == "table" then
            for key, value in pairs(properties) do
                if key == "Parent" then
                    instance.Parent = value
                elseif key == "Children" and type(value) == "table" then
                    for _, child in ipairs(value) do
                        if child then
                            child.Parent = instance
                        end
                    end
                else
                    instance[key] = value
                end
            end
        end
        return instance
    end

    return Creator
end
