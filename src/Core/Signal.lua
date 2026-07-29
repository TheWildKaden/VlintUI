return function(require)
    local Signal = {}
    Signal.__index = Signal

    function Signal.new()
        return setmetatable({
            _connections = {},
            _destroyed = false,
        }, Signal)
    end

    function Signal:Connect(callback)
        if self._destroyed then
            return {
                Disconnect = function() end,
            }
        end

        local connection = {
            Connected = true,
            Disconnect = function()
                if connection.Connected then
                    connection.Connected = false
                    for index, activeConnection in ipairs(self._connections) do
                        if activeConnection == connection then
                            table.remove(self._connections, index)
                            break
                        end
                    end
                end
            end,
        }

        connection._callback = callback
        table.insert(self._connections, connection)
        return connection
    end

    function Signal:Fire(...)
        for _, connection in ipairs(self._connections) do
            if connection.Connected then
                task.spawn(connection._callback, ...)
            end
        end
    end

    function Signal:Destroy()
        self._destroyed = true
        for _, connection in ipairs(self._connections) do
            connection.Connected = false
        end
        self._connections = {}
    end

    return Signal
end
