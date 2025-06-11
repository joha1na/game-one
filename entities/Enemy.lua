local Enemy = {}
Enemy.__index = Enemy

function Enemy.new()
    local self = setmetatable({}, Enemy)
    
    self.x = 375  -- Start in der Mitte
    self.y = 0    -- Start oben
    self.width = 40
    self.height = 40
    self.speed = 100  -- Langsamere Geschwindigkeit als der Spieler
    self.health = 3   -- Feind hat 3 Leben
    
    return self
end

function Enemy:update(dt)
    self.y = self.y + self.speed * dt
    
    -- Zurücksetzen, wenn der Feind den Bildschirm verlässt
    if self.y > love.graphics.getHeight() then
        self:reset()
    end
end

function Enemy:draw()
    love.graphics.setColor(1, 0, 0)  -- Rot
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1)  -- Zurück zu Weiß
end

function Enemy:reset()
    self.y = 0
    self.x = math.random(0, love.graphics.getWidth() - self.width)
    self.health = 3
end

function Enemy:takeDamage()
    self.health = self.health - 1
    if self.health <= 0 then
        self:reset()
        return true
    end
    return false
end

return Enemy 