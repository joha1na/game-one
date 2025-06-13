-- love_mock.lua
-- Simuliert die LÖVE API für Tests

local love = {}

-- Grafik-Modul
love.graphics = {
    setColor = function() end,
    rectangle = function() end,
    print = function() end,
    draw = function() end,
    newFont = function() return {} end,
    setFont = function() end,
    getWidth = function() return 800 end,
    getHeight = function() return 600 end
}

-- Tastatur-Modul
love.keyboard = {
    isDown = function(key)
        return false
    end
}

-- Audio-Modul
love.audio = {
    newSource = function() return {} end
}

-- Fenster-Modul
love.window = {
    setTitle = function() end
}

-- Mathematisches Modul
love.math = {
    random = function(min, max) 
        if min and max then
            return min
        elseif min then
            return 1
        else
            return 0
        end
    end
}

-- Datei-Modul
love.filesystem = {
    getInfo = function(path)
        local file = io.open(path, "r")
        if file then
            file:close()
            return { type = "file" }
        else
            return nil
        end
    end,
    read = function(path)
        local file = io.open(path, "r")
        if file then
            local content = file:read("*all")
            file:close()
            return content
        else
            return nil
        end
    end,
    write = function(path, data)
        local file = io.open(path, "w")
        if file then
            file:write(data)
            file:close()
            return true
        else
            return false
        end
    end,
    getDirectoryItems = function(dir)
        -- Einfache Mock-Version
        return {}
    end
}

-- Timer-Modul
love.timer = {
    getTime = function() return os.time() end
}

return love
